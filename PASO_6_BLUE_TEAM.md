# Paso 6: Defensa Blue Team
<a id="readme-top"></a>

## 📜 Objetivo

Completar la implementación defensiva del laboratorio agregando un plan operativo para el Blue Team: generación de tráfico legítimo constante, instrumentación adicional, reglas de detección en Elasticsearch/Kibana, acciones de respuesta y documentación del ciclo de defensa.

---

## 🔄 Resumen del flujo extendido

```
Usuarios legítimos ──┐
Red Team (ataques) ──┼─► Juice Shop ─► Nginx (proxy opcional) ─► Docker logs
                     │                                              │
                     │                                              ▼
                     └──────────────► Filebeat ─► Elasticsearch ─► Kibana
                                                      │                │
                                                      ▼                ▼
                                             Detecciones (SIGMA/KQL)   Dashboards/Alertas
```

---

## 1. Actividades Blue Team

### 1.1 Generación de tráfico diario (baseline)

- Automatiza requests legítimas que emulen el comportamiento esperado de los usuarios para diferenciar ruido normal de ataques.
- Crea el script `scripts/blue-team-traffic.sh`:

```bash
#!/bin/bash
ENDPOINTS=(
  "http://localhost:3000"
  "http://localhost:3000/#/login"
  "http://localhost:3000/rest/products/search?q=apple"
  "http://localhost:3000/rest/products/search?q=juce"
  "http://localhost:3000/api/Products"
)
for url in "${ENDPOINTS[@]}"; do
  curl -s "$url" > /dev/null
  echo "$(date -u) OK $url"
  sleep 5
done
```

- Programa su ejecución cada 15 minutos (ej. con `cron` en macOS/Linux):

```
*/15 * * * * /Users/admin/Documents/Git/UVG/proyecto_2/scripts/blue-team-traffic.sh >> /tmp/juice-blue-team.log 2>&1
```

- Registra en Kibana una Saved Search “Baseline Blue Team” para revisar el volumen y tipos de logs generados por el script (filtro `host.name:"<tu-host>" AND fileset.name:"blue-team"` si agregas un campo personalizado).

### 1.2 Reproducción de los endpoints atacados por el Red Team

- Documenta los endpoints críticos (por ejemplo: `/rest/user/login`, `/rest/products/search`) y ejecútalos con payloads benignos.
- Guarda los resultados en un dashboard “Comparativa Red vs Blue” con:
  - Panel 1: Conteo de 2xx/3xx vs 4xx/5xx por endpoint.
  - Panel 2: Detecciones por regla.
  - Panel 3: Top IPs legítimas vs sospechosas.

---

## 2. Instrumentación ampliada

### 2.1 Reverse proxy Nginx (opcional, recomendado)

1. Añade al `docker-compose.yml`:

```yaml
  juice-proxy:
    image: nginx:1.25
    container_name: juice-proxy
    depends_on:
      juice-shop:
        condition: service_started
    ports:
      - "8080:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
      - proxy-logs:/var/log/nginx
    networks:
      - elk-network
```

2. Crea `nginx/default.conf`:

```
server {
  listen 80;
  server_name _;

  add_header Access-Control-Allow-Origin "*" always;
  add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
  add_header Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With";

  location / {
    proxy_pass http://juice-shop:3000;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    access_log /var/log/nginx/juice_access.log;
    error_log  /var/log/nginx/juice_error.log warn;
  }

  location /healthz {
    return 200 "ok\n";
  }
}
```

3. Actualiza la colección de endpoints para usar `http://localhost:8080`.

4. **CORS**: El reverse proxy inyecta los encabezados requeridos. Si prefieres ajustar Juice Shop directamente, exporta `NODE_OPTIONS=--require cors` y añade un middleware en `server.js`, pero el enfoque de Nginx evita tocar la imagen oficial.

### 2.2 Ajustes Filebeat específicos

#### 2.2.1 Campos personalizados

Agrega en `filebeat.yml` dentro de `filebeat.inputs[0]`:

```yaml
    fields:
      service.environment: "lab"
      service.owner: "blue-team"
    fields_under_root: true
```

Esto permite filtrar fácilmente la data generada por el tráfico legítimo.

#### 2.2.2 Ingest pipelines (en Elasticsearch)

Configura un pipeline que normalice rutas y detecte payloads peligrosos:

```bash
curl -X PUT "http://localhost:9200/_ingest/pipeline/juice-threat-normalizer" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Normaliza logs de Juice Shop y detecta payloads comunes",
    "processors": [
      { "lowercase": { "field": "url.original", "ignore_missing": true } },
      { "script": {
          "source": """
            if (ctx?.url?.original != null) {
              if (ctx.url.original.contains(\"union select\") || ctx.url.original.contains(\" or 1=1\")) {
                ctx.threat = ctx.threat != null ? ctx.threat : [:];
                ctx.threat.indicator = ctx.threat.indicator != null ? ctx.threat.indicator : [:];
                ctx.threat.indicator.type = 'sql-injection';
              }
            }
          """
        }
      }
    ]
  }'
```

Aplica el pipeline en Filebeat:

```yaml
output.elasticsearch:
  hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
  pipeline: "juice-threat-normalizer"
  indices:
    - index: "filebeat-juice-shop-%{+yyyy.MM.dd}"
      when.contains:
        container.name: "juice-shop"
    - index: "filebeat-docker-%{+yyyy.MM.dd}"
```

### 2.3 Módulo Nginx (opcional)

Filebeat ofrece un módulo dedicado. Actívalo si prefieres parsing más rico:

```bash
docker exec filebeat filebeat modules enable nginx
docker exec filebeat filebeat setup --modules nginx -E setup.kibana.host=kibana:5601
```

Configura `modules.d/nginx.yml` para apuntar a `/var/log/nginx/*.log`.

---

## 3. Reglas de detección (Elastic Security / Kibana Detection Engine)

> **Recomendación:** Configura todas las reglas con intervalo de 5 minutos y ventanas de 15 minutos para reducir falsos negativos. Documenta en cada regla la referencia al ataque simulado y los pasos de respuesta.

### 3.1 SQL Injection (Rule ID: `elastic-juice-sqli`)

- **Tipo:** KQL rule.
- **KQL:**

```
url.original:("*' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or
query:("*' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or
message:("*' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*")
```

- **ES DSL extract (para documentación o Watcher):**

```json
{
  "query": {
    "bool": {
      "should": [
        { "wildcard": { "url.original": "*' or 1=1*" } },
        { "wildcard": { "url.original": "*union select*" } },
        { "wildcard": { "message": "*benchmark(*" } }
      ]
    }
  }
}
```

- **Campos clave:** `url.original`, `http.request.body.content`, `message`.
- **Prueba:** `curl "http://localhost:8080/rest/products/search?q=' OR 1=1 --"`
- **Respuesta sugerida:** Probar bloqueo de IP en Nginx (ver sección 4).
- **Falsos positivos:** Consultas legítimas que contengan `union` como término. Mitiga añadiendo lista blanca (`NOT source.ip:("<ip-legitima>")`).

### 3.2 XSS (Rule ID: `elastic-juice-xss`)

- **Tipo:** Threshold rule (conteo >= 1).
- **KQL base:**

```
(url.original:*"<script*" or
 url.original:*"onerror=" or
 http.request.body.content:*"<img*" or
 message.keyword:*"<svg*" )
```

- **Threshold:** 1 evento único por `source.ip` en 5 minutos.
- **Prueba:** `curl 'http://localhost:8080/rest/products/search?q=<script>alert(1)</script>'`
- **Respuesta:** Registrar payload, bloquear IP si repite, habilitar sanitización en Juice Shop (modo parche) para ambientes productivos.
- **Falsos positivos:** Carga de productos con `<img>` legítimo; añade filtro `AND NOT url.original:*"q=%3Cimg%2F%3E"` si fuese necesario.

### 3.3 Scanning/Burst (Rule ID: `elastic-juice-burst`)

- **Tipo:** Threshold rule con agrupación por `source.ip`.
- **Condición:** `event.outcome: "failure"` (4xx/5xx) y `count >= 20` en 2 minutos.
- **KQL:**

```
http.response.status_code: (400 or 401 or 403 or 404 or 500 or 503)
```

- **Configuración de agregación:**
  - `Group by` = `source.ip`
  - `Threshold` = `>= 20`
  - `Time window` = `2 minutes`

- **Prueba:** Ejecuta un escaneo con OWASP ZAP o `ffuf`:
  ```
  ffuf -u http://localhost:8080/FUZZ -w /usr/share/wordlists/dirb/common.txt
  ```
- **Respuesta:** Bloquear IP en proxy, activar alertas en Slack/Email.
- **Falsos positivos:** Monitoreo agresivo de uptime; documenta host de monitoreo y exclúyelo (`NOT source.ip:"<ip-monitor>"`).

### 3.4 (Opcional) Comandos sospechosos / LFI

- **KQL:** `message:("*../../*" or "*;/bin/" or "*cat /etc/passwd*")`
- **Uso:** Detectar intentos de Directory Traversal o ejecución remota.

---

## 4. Plan de respuesta

| Acción | Dónde | Indicaciones |
|--------|-------|--------------|
| Bloqueo IP | Nginx | Añade `deny <IP>;` en el `location /` del proxy y recarga: `docker exec juice-proxy nginx -s reload`. |
| Bloqueo temporal | Kubernetes/Host | Usa `pfctl` (macOS) o `iptables` (Linux) para dropear tráfico sospechoso. |
| Aumento de logging | Juice Shop | Eleva nivel usando `LOG_LEVEL=debug` temporalmente para IP atacantes y captura payloads completos. |
| Comunicación | Kibana alertas | Configura connectores (email/Slack/Webhook) en Kibana → Stack Management → Rules and Connectors. |

Documenta cada intervención en un registro de incidentes (Google Docs, Markdown o ticketing) indicando: hora, IP, payload, regla que disparó, acción tomada y resultado.

---

## 5. Falsos positivos y limitaciones

- **SQLi:** Palabras clave `union`/`select` pueden aparecer en búsquedas legítimas. Solución: combinar con patrones como `'` + `--` o contar repeticiones.
- **XSS:** Los productos o reseñas legítimas pueden incluir HTML. Considera permitir ciertas etiquetas (`<b>`, `<i>`) y bloquear otras.
- **Burst:** Durante pruebas de carga legítimas, el umbral puede dispararse. Ajusta `count` y ventana según baseline.
- **Limitaciones:** No se inspecta tráfico HTTPS cifrado si se conecta directo al Juice Shop sin proxy TLS; considera TLS termination en Nginx para inspección avanzada.

---

## 6. Informe de respuesta (plantilla)

1. **Resumen ejecutivo:** Fecha, impacto, IPs afectadas.
2. **Detección:** Regla que disparó, log de Kibana, captura de pantalla.
3. **Análisis técnico:** Payload, endpoint, correlación con otras reglas.
4. **Acciones:** Bloqueos aplicados, escalamiento, ticket generado.
5. **Lecciones aprendidas:** Ajustes a reglas, tuning, tareas pendientes.
6. **Anexos:** Export JSON de la regla, comandos usados, screenshots de dashboards/alertas.

---

## 7. Dashboards y evidencias

- **Dashboards sugeridos:**
  - `Blue Team Overview`: incluye métricas de volumen, top IPs, reglas disparadas, timeline.
  - `Threat Map (opcional)`: usa `source.geo.location` si enriqueces IPs con GeoIP.
  - `Detection Drilldown`: tabla con `rule.name`, `source.ip`, `url.original`, `message`.

- **Capturas:** Usa Kibana → Share → Generate report o `chrome --headless --screenshot`.
- **Alertas:** Configura output en Slack/Email y adjunta la evidencia en el informe.

---

## 8. Snippets y comandos útiles

### 8.1 Habilitar enriquecimiento GeoIP (opcional)

```bash
curl -X PUT "http://localhost:9200/_ingest/pipeline/geoip" \
  -H 'Content-Type: application/json' \
  -d '{
    "processors": [
      { "geoip": { "field": "source.ip", "target_field": "source.geo" } }
    ]
  }'
```

Aplica el pipeline usando `output.elasticsearch.pipeline: "geoip"` (o encadena con `juice-threat-normalizer` usando `pipeline: "geoip"` y dentro del pipeline añade un `pipeline` processor).

### 8.2 Envío de logs de prueba

```bash
# SQL Injection
curl "http://localhost:8080/rest/products/search?q=' OR 1=1 --"

# XSS
curl "http://localhost:8080/rest/products/search?q=<svg/onload=alert(1)>"

# Burst / Scanning
for i in {1..30}; do curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:8080/non-existent-$i"; done
```

### 8.3 Consultas rápidas en Dev Tools

```json
GET filebeat-juice-shop-*/_search
{
  "size": 5,
  "sort": [{ "@timestamp": "desc" }],
  "query": { "match": { "threat.indicator.type": "sql-injection" } }
}
```

### 8.4 Exportar reglas (JSON)

En Kibana → Security → Detect → Detection rules → Export. Adjunta el JSON en la documentación del incidente.

---

## 9. Próximos pasos sugeridos

- Integrar alertas con Slack/Teams.
- Añadir Metricbeat para métricas de host/container.
- Implementar un WAF ligero (ej. ModSecurity) delante de Nginx si el escenario lo permite.
- Automatizar el reporte diario con Canvas o Reporting.

---

<p align="right">(<a href="#readme-top">Ir al inicio</a>)</p>


