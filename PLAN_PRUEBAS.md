# Plan de Pruebas y Verificación

## 🎯 Objetivo

Este documento proporciona un checklist detallado para verificar que cada paso del proyecto funciona correctamente antes de pasar al siguiente.

## 📋 Metodología

Para cada paso:
1. ✅ **Ejecutar comandos de verificación**
2. 📸 **Capturar screenshots de evidencia**
3. ✍️ **Documentar resultados**
4. 🔄 **Resolver problemas si los hay**
5. ✅ **Confirmar éxito antes de continuar**

---

## 🧪 PASO 1: Juice Shop Básico

### Pre-requisitos
- [ ] Docker instalado y corriendo
- [ ] Docker Compose instalado
- [ ] Puerto 3000 disponible

### Comandos de Verificación

#### 1.1 Construir y levantar servicio
```bash
docker compose up -d
```
**Resultado esperado**: 
- Mensaje "Container juice-shop Started"
- Sin errores

#### 1.2 Verificar estado del contenedor
```bash
docker compose ps
```
**Resultado esperado**:
```
NAME         STATUS    PORTS
juice-shop   Up        0.0.0.0:3000->3000/tcp
```

#### 1.3 Verificar logs de inicio
```bash
docker compose logs juice-shop | tail -20
```
**Resultado esperado**:
- Mensaje "Server listening on port 3000"
- Sin errores de inicio

#### 1.4 Probar conectividad HTTP
```bash
curl -I http://localhost:3000
```
**Resultado esperado**:
- HTTP/1.1 200 OK
- Headers de respuesta

#### 1.5 Probar interfaz web
**Navegador**: http://localhost:3000

**Resultado esperado**:
- Página de Juice Shop carga correctamente
- Productos visibles
- Sin errores en consola del navegador

#### 1.6 Generar logs de prueba
```bash
for i in {1..5}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i completada"
  sleep 1
done
```
**Resultado esperado**:
- 5 requests completadas
- Logs visibles en `docker compose logs juice-shop`

### Checklist de Éxito - Paso 1
- [ ] Contenedor corriendo sin errores
- [ ] Puerto 3000 accesible
- [ ] Interfaz web funcional
- [ ] Logs generándose correctamente
- [ ] Screenshots capturados (mínimo 4)
- [ ] Documentación completada

### Troubleshooting Paso 1

**Problema**: Puerto 3000 ya en uso
```bash
# Verificar qué está usando el puerto
lsof -i :3000
# Detener el proceso o cambiar puerto en docker-compose.yml
```

**Problema**: Contenedor no inicia
```bash
# Ver logs detallados
docker compose logs juice-shop
# Verificar recursos
docker stats
```

---

## 🔍 PASO 2: Elasticsearch

### Pre-requisitos
- [ ] Paso 1 completado exitosamente
- [ ] Puerto 9200 y 9300 disponibles
- [ ] Mínimo 2GB RAM disponible

### Comandos de Verificación

#### 2.1 Levantar servicios
```bash
docker compose up -d
```
**Resultado esperado**:
- Juice Shop y Elasticsearch corriendo

#### 2.2 Verificar estado de servicios
```bash
docker compose ps
```
**Resultado esperado**:
```
NAME            STATUS
juice-shop      Up
elasticsearch   Up (healthy)
```

#### 2.3 Esperar inicialización de Elasticsearch
```bash
# Monitorear logs
docker compose logs -f elasticsearch
```
**Buscar mensaje**:
- "Cluster health status changed from [YELLOW] to [GREEN]"
- Puede tardar 30-60 segundos

#### 2.4 Verificar salud del cluster
```bash
curl http://localhost:9200/_cluster/health?pretty
```
**Resultado esperado**:
```json
{
  "cluster_name" : "docker-cluster",
  "status" : "green",
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1
}
```

#### 2.5 Verificar información del nodo
```bash
curl http://localhost:9200
```
**Resultado esperado**:
```json
{
  "name" : "elasticsearch",
  "version" : {
    "number" : "8.11.0"
  },
  "tagline" : "You Know, for Search"
}
```

#### 2.6 Crear documento de prueba
```bash
curl -X POST "http://localhost:9200/test-index/_doc" \
  -H 'Content-Type: application/json' \
  -d '{
    "message": "Test log entry",
    "timestamp": "2025-11-04T10:00:00Z",
    "level": "INFO"
  }'
```
**Resultado esperado**:
```json
{
  "_index": "test-index",
  "_id": "...",
  "result": "created"
}
```

#### 2.7 Buscar documento creado
```bash
curl "http://localhost:9200/test-index/_search?pretty"
```
**Resultado esperado**:
- Documento encontrado
- `"hits" : { "total" : { "value" : 1 } }`

#### 2.8 Verificar índices
```bash
curl "http://localhost:9200/_cat/indices?v"
```
**Resultado esperado**:
```
health status index      pri rep docs.count
yellow open   test-index   1   1          1
```

### Checklist de Éxito - Paso 2
- [ ] Elasticsearch corriendo y healthy
- [ ] Cluster en estado GREEN o YELLOW
- [ ] Puerto 9200 respondiendo
- [ ] Puede crear documentos
- [ ] Puede buscar documentos
- [ ] Volumen persistente funcionando
- [ ] Screenshots capturados (mínimo 5)
- [ ] Documentación completada

### Troubleshooting Paso 2

**Problema**: Elasticsearch no inicia
```bash
# Verificar memoria
docker stats elasticsearch
# Aumentar límite si es necesario en docker-compose.yml
# ES_JAVA_OPTS=-Xms256m -Xmx256m
```

**Problema**: Status YELLOW
- Normal en single-node
- No afecta funcionalidad
- Documentar en reporte

**Problema**: Puerto 9200 no responde
```bash
# Esperar más tiempo (hasta 2 minutos)
# Verificar logs
docker compose logs elasticsearch | grep ERROR
```

---

## 📊 PASO 3: Kibana

### Pre-requisitos
- [ ] Paso 2 completado exitosamente
- [ ] Elasticsearch en estado healthy
- [ ] Puerto 5601 disponible

### Comandos de Verificación

#### 3.1 Levantar servicios
```bash
docker compose up -d
```
**Resultado esperado**:
- Juice Shop, Elasticsearch y Kibana corriendo

#### 3.2 Verificar estado de servicios
```bash
docker compose ps
```
**Resultado esperado**:
```
NAME            STATUS
juice-shop      Up
elasticsearch   Up (healthy)
kibana          Up (healthy)
```

#### 3.3 Monitorear inicio de Kibana
```bash
docker compose logs -f kibana
```
**Buscar mensaje**:
- "Kibana is now available"
- "http server running at http://0.0.0.0:5601"
- Puede tardar 30-60 segundos

#### 3.4 Verificar estado de Kibana
```bash
curl http://localhost:5601/api/status | jq .
```
**Resultado esperado**:
```json
{
  "status": {
    "overall": {
      "state": "green"
    }
  }
}
```

#### 3.5 Verificar conectividad Kibana → Elasticsearch
```bash
curl http://localhost:5601/api/status | jq '.status.core.elasticsearch'
```
**Resultado esperado**:
```json
{
  "level": "available"
}
```

#### 3.6 Acceder a interfaz web
**Navegador**: http://localhost:5601

**Resultado esperado**:
- Pantalla de bienvenida de Kibana
- Sin errores de conexión
- Puede navegar el menú

#### 3.7 Probar Dev Tools
**Ruta**: Menu → Management → Dev Tools

**Query**:
```
GET /
```

**Resultado esperado**:
- Respuesta de Elasticsearch
- Versión 8.11.0
- Tagline visible

#### 3.8 Verificar índices desde Kibana
**Query en Dev Tools**:
```
GET /_cat/indices?v
```

**Resultado esperado**:
- Lista de índices
- test-index visible

### Checklist de Éxito - Paso 3
- [ ] Kibana corriendo y healthy
- [ ] Puerto 5601 accesible
- [ ] Interfaz web funcional
- [ ] Conectado a Elasticsearch
- [ ] Dev Tools funcional
- [ ] Puede ejecutar queries
- [ ] Screenshots capturados (mínimo 4)
- [ ] Documentación completada

### Troubleshooting Paso 3

**Problema**: Kibana no carga
```bash
# Verificar que Elasticsearch está healthy
docker compose ps
# Esperar más tiempo (hasta 2 minutos)
# Ver logs de error
docker compose logs kibana | grep ERROR
```

**Problema**: "Kibana server is not ready yet"
- Normal durante inicio
- Esperar 1-2 minutos más
- Refrescar navegador

**Problema**: No puede conectar a Elasticsearch
```bash
# Verificar red
docker network inspect proyecto_2_elk-network
# Ambos contenedores deben estar listados
```

---

## 📡 PASO 4: Filebeat

### Pre-requisitos
- [ ] Paso 3 completado exitosamente
- [ ] Todos los servicios healthy
- [ ] Archivo filebeat.yml creado

### Comandos de Verificación

#### 4.1 Levantar servicios
```bash
docker compose up -d
```
**Resultado esperado**:
- Todos los servicios corriendo incluyendo Filebeat

#### 4.2 Verificar estado de servicios
```bash
docker compose ps
```
**Resultado esperado**:
```
NAME            STATUS
juice-shop      Up
elasticsearch   Up (healthy)
kibana          Up (healthy)
filebeat        Up
```

#### 4.3 Verificar logs de Filebeat
```bash
docker compose logs filebeat | grep -i "elasticsearch\|connection\|pipeline"
```
**Resultado esperado**:
- "Elasticsearch url: http://elasticsearch:9200"
- "Connection to backoff(elasticsearch) established"
- "Pipeline is connecting"

#### 4.4 Verificar permisos de Filebeat
```bash
docker exec filebeat ls -la /var/lib/docker/containers
```
**Resultado esperado**:
- Lista de directorios de contenedores
- Sin errores de permisos

#### 4.5 Generar tráfico en Juice Shop
```bash
for i in {1..20}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```
**Resultado esperado**:
- 20 requests completadas
- Logs generados en Juice Shop

#### 4.6 Esperar procesamiento
```bash
# Esperar 30-60 segundos
sleep 60
```

#### 4.7 Verificar índices de Filebeat
```bash
curl "http://localhost:9200/_cat/indices?v" | grep filebeat
```
**Resultado esperado**:
```
yellow open filebeat-juice-shop-2025.11.04  1 1  20
yellow open filebeat-docker-2025.11.04      1 1  100
```

#### 4.8 Contar documentos por índice
```bash
curl "http://localhost:9200/filebeat-juice-shop-*/_count?pretty"
```
**Resultado esperado**:
```json
{
  "count" : 20
}
```

#### 4.9 Ver un documento de log
```bash
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"
```
**Resultado esperado**:
- Documento con campos:
  - `@timestamp`
  - `message`
  - `container.name: "juice-shop"`
  - `host.name`

#### 4.10 Verificar metadata de contenedor
```bash
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "size": 1,
    "query": { "match_all": {} },
    "_source": ["container", "host", "message"]
  }'
```
**Resultado esperado**:
- `container.name` presente
- `container.id` presente
- `host.name` presente

### Checklist de Éxito - Paso 4
- [ ] Filebeat corriendo sin errores
- [ ] Conectado a Elasticsearch
- [ ] Leyendo logs de Docker
- [ ] Índices filebeat-* creados
- [ ] Documentos con metadata completa
- [ ] Logs en tiempo real funcionando
- [ ] Screenshots capturados (mínimo 5)
- [ ] Documentación completada

### Troubleshooting Paso 4

**Problema**: Filebeat no encuentra logs
```bash
# Verificar montaje de volumen
docker exec filebeat ls -la /var/lib/docker/containers
# Debe mostrar directorios
```

**Problema**: Permission denied
```bash
# Verificar que corre como root
docker compose ps
# USER debe ser "root"
```

**Problema**: No se crean índices
```bash
# Ver logs de error
docker compose logs filebeat | grep -i error
# Verificar conectividad
docker exec filebeat curl http://elasticsearch:9200
```

---

## 🎨 PASO 5: Visualización en Kibana

### Pre-requisitos
- [ ] Paso 4 completado exitosamente
- [ ] Logs fluyendo a Elasticsearch
- [ ] Mínimo 50 documentos en índices

### Comandos de Verificación

#### 5.1 Verificar datos disponibles
```bash
curl "http://localhost:9200/filebeat-*/_count?pretty"
```
**Resultado esperado**:
- `count` mayor a 50

#### 5.2 Generar más tráfico si es necesario
```bash
for i in {1..50}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

### Verificaciones en Kibana

#### 5.3 Crear Data View "Todos los Logs"
**Ruta**: Management → Stack Management → Data Views → Create data view

**Configuración**:
- Name: `Todos los Logs`
- Index pattern: `filebeat-*`
- Timestamp field: `@timestamp`

**Verificación**:
- [ ] Data View creado exitosamente
- [ ] Muestra número de campos detectados
- [ ] Campo @timestamp seleccionado

#### 5.4 Crear Data View "Juice Shop Logs"
**Configuración**:
- Name: `Juice Shop Logs`
- Index pattern: `filebeat-juice-shop-*`
- Timestamp field: `@timestamp`

**Verificación**:
- [ ] Data View creado exitosamente

#### 5.5 Probar Discover
**Ruta**: Analytics → Discover

**Verificaciones**:
- [ ] Seleccionar "Todos los Logs"
- [ ] Ver histograma con datos
- [ ] Ver tabla con logs
- [ ] Expandir un log y ver campos

#### 5.6 Probar búsqueda KQL
**Query**: `container.name: "juice-shop"`

**Verificación**:
- [ ] Resultados filtrados correctamente
- [ ] Solo logs de juice-shop visibles
- [ ] Número de hits actualizado

#### 5.7 Agregar columnas útiles
**Columnas a agregar**:
- `container.name`
- `message`

**Verificación**:
- [ ] Columnas agregadas correctamente
- [ ] Datos visibles en tabla

#### 5.8 Crear visualización: Pie Chart
**Ruta**: Analytics → Visualize Library → Create visualization

**Configuración**:
- Tipo: Pie
- Data view: Todos los Logs
- Slice by: container.name.keyword

**Verificación**:
- [ ] Gráfico generado correctamente
- [ ] Muestra distribución por contenedor
- [ ] Guardado con nombre descriptivo

#### 5.9 Crear visualización: Line Chart
**Configuración**:
- Tipo: Line
- Data view: Todos los Logs
- Horizontal axis: @timestamp
- Break down by: container.name.keyword

**Verificación**:
- [ ] Gráfico de líneas generado
- [ ] Muestra evolución temporal
- [ ] Líneas por contenedor visibles

#### 5.10 Crear visualización: Metric
**Configuración**:
- Tipo: Metric
- Data view: Todos los Logs
- Metric: Count

**Verificación**:
- [ ] Número grande visible
- [ ] Muestra total de logs

#### 5.11 Crear Dashboard
**Ruta**: Analytics → Dashboard → Create dashboard

**Pasos**:
1. Click "Add from library"
2. Agregar las 3 visualizaciones creadas
3. Organizar layout
4. Guardar dashboard

**Verificación**:
- [ ] Dashboard creado
- [ ] Todas las visualizaciones agregadas
- [ ] Layout organizado
- [ ] Guardado con nombre descriptivo

#### 5.12 Probar interactividad del Dashboard
**Acciones**:
- Cambiar rango de tiempo
- Click en un segmento del pie chart
- Observar actualización de todas las visualizaciones

**Verificación**:
- [ ] Filtros se aplican a todas las visualizaciones
- [ ] Datos se actualizan correctamente

#### 5.13 Probar Dev Tools con queries avanzadas
**Query 1 - Agregación**:
```json
GET /filebeat-*/_search
{
  "size": 0,
  "aggs": {
    "por_contenedor": {
      "terms": {
        "field": "container.name.keyword"
      }
    }
  }
}
```

**Verificación**:
- [ ] Query ejecutada exitosamente
- [ ] Resultados de agregación visibles

**Query 2 - Búsqueda con filtro**:
```json
GET /filebeat-juice-shop-*/_search
{
  "query": {
    "match": {
      "message": "GET"
    }
  },
  "size": 5
}
```

**Verificación**:
- [ ] Query ejecutada exitosamente
- [ ] Documentos filtrados correctamente

### Checklist de Éxito - Paso 5
- [ ] 2 Data Views creados
- [ ] Discover funcional
- [ ] Búsquedas KQL funcionando
- [ ] Mínimo 3 visualizaciones creadas
- [ ] Dashboard creado y funcional
- [ ] Dev Tools con queries avanzadas
- [ ] Screenshots capturados (mínimo 12)
- [ ] Documentación completada

### Troubleshooting Paso 5

**Problema**: No veo logs en Discover
```bash
# Verificar datos
curl "http://localhost:9200/_cat/indices?v" | grep filebeat
# Ampliar rango de tiempo en Kibana
# Verificar Data View correcto seleccionado
```

**Problema**: "No results match your search criteria"
- Eliminar todos los filtros
- Cambiar rango a "Last 7 days"
- Verificar que hay datos en los índices

**Problema**: Visualización vacía
- Verificar que el campo existe en Discover
- Verificar rango de tiempo
- Generar más tráfico si es necesario

---

## 🛡️ PASO 6: Blue Team

### Pre-requisitos
- [ ] Paso 5 completado exitosamente
- [ ] Sistema completamente funcional
- [ ] Familiaridad con Kibana

### Comandos de Verificación

#### 6.1 Crear script de tráfico legítimo
```bash
mkdir -p scripts
cat > scripts/blue-team-traffic.sh << 'EOF'
#!/bin/bash
ENDPOINTS=(
  "http://localhost:3000"
  "http://localhost:3000/#/login"
  "http://localhost:3000/rest/products/search?q=apple"
)
for url in "${ENDPOINTS[@]}"; do
  curl -s "$url" > /dev/null
  echo "$(date -u) OK $url"
  sleep 5
done
EOF
chmod +x scripts/blue-team-traffic.sh
```

#### 6.2 Probar script
```bash
./scripts/blue-team-traffic.sh
```
**Resultado esperado**:
- 3 requests exitosas
- Timestamps visibles

#### 6.3 Crear regla de detección SQLi en Kibana
**Ruta**: Security → Detect → Detection rules → Create new rule

**Configuración**:
- Name: `Detección SQL Injection`
- Type: Custom query
- Query: `url.original:("*' or 1=1*" or "*union select*") or message:("*' or 1=1*" or "*union select*")`
- Severity: High
- Risk score: 75

**Verificación**:
- [ ] Regla creada exitosamente
- [ ] Estado: Enabled

#### 6.4 Crear regla de detección XSS
**Configuración**:
- Name: `Detección Cross-Site Scripting (XSS)`
- Type: Threshold
- Query: `url.original:*"<script*" or message:*"<script*"`
- Threshold: 1
- Severity: High

**Verificación**:
- [ ] Regla creada exitosamente
- [ ] Estado: Enabled

#### 6.5 Crear regla de detección Burst/Scanning
**Configuración**:
- Name: `Detección de Scanning/Burst`
- Type: Threshold
- Query: `http.response.status_code: (400 or 401 or 403 or 404 or 500)`
- Group by: `source.ip`
- Threshold: >= 20
- Time window: 2 minutes
- Severity: Medium

**Verificación**:
- [ ] Regla creada exitosamente
- [ ] Estado: Enabled

#### 6.6 Simular ataque SQL Injection
```bash
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"
```
**Resultado esperado**:
- Request ejecutada
- Payload visible en logs

#### 6.7 Simular ataque XSS
```bash
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>"
```
**Resultado esperado**:
- Request ejecutada
- Payload visible en logs

#### 6.8 Simular scanning
```bash
for i in {1..30}; do 
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:3000/non-existent-$i"
  sleep 0.5
done
```
**Resultado esperado**:
- 30 requests con código 404
- Logs generados

#### 6.9 Esperar procesamiento de alertas
```bash
# Esperar 5 minutos para que las reglas procesen
sleep 300
```

#### 6.10 Verificar alertas generadas
**Ruta**: Security → Detect → Alerts

**Verificación**:
- [ ] Alerta de SQL Injection visible
- [ ] Alerta de XSS visible
- [ ] Alerta de Scanning visible
- [ ] Timestamps correctos
- [ ] Severidad correcta

#### 6.11 Analizar detalle de alerta
**Pasos**:
1. Click en una alerta
2. Ver detalles completos
3. Verificar payload
4. Verificar campos relevantes

**Verificación**:
- [ ] Payload completo visible
- [ ] IP origen visible
- [ ] Timestamp correcto
- [ ] Campos enriquecidos presentes

#### 6.12 Crear dashboard de detecciones
**Visualizaciones a incluir**:
1. Métrica: Total de detecciones
2. Pie chart: Detecciones por tipo
3. Line chart: Timeline de detecciones
4. Table: Top IPs atacantes

**Verificación**:
- [ ] Dashboard creado
- [ ] Todas las visualizaciones funcionando
- [ ] Datos de alertas visibles

#### 6.13 Buscar logs maliciosos en Discover
**Query**:
```
message: *"' OR 1=1"* OR message: *"<script>"*
```

**Verificación**:
- [ ] Logs maliciosos encontrados
- [ ] Payloads visibles
- [ ] Metadata completa

#### 6.14 Exportar reglas
**Ruta**: Security → Detect → Detection rules → Select all → Export

**Verificación**:
- [ ] Archivo JSON descargado
- [ ] Contiene las 3 reglas

### Checklist de Éxito - Paso 6
- [ ] Script de tráfico legítimo creado
- [ ] 3 reglas de detección configuradas
- [ ] Ataques simulados ejecutados
- [ ] Alertas generadas correctamente
- [ ] Dashboard de detecciones creado
- [ ] Logs maliciosos identificados
- [ ] Reglas exportadas
- [ ] Screenshots capturados (mínimo 12)
- [ ] Documentación completada
- [ ] Informe de incidente redactado

### Troubleshooting Paso 6

**Problema**: No se generan alertas
```bash
# Verificar que las reglas están enabled
# Esperar más tiempo (5-10 minutos)
# Verificar logs en Discover manualmente
# Revisar configuración de la regla
```

**Problema**: Demasiados falsos positivos
- Ajustar threshold de las reglas
- Agregar excepciones para IPs legítimas
- Refinar queries KQL

**Problema**: No veo el menú Security
- Verificar versión de Kibana
- Puede requerir licencia (usar trial)
- Alternativamente usar Watcher o Alerting

---

## 📊 Resumen de Verificación Total

### Checklist Global del Proyecto

#### Infraestructura
- [ ] Docker y Docker Compose instalados
- [ ] Todos los puertos disponibles (3000, 5601, 9200, 9300)
- [ ] Recursos suficientes (4GB RAM mínimo)

#### Servicios
- [ ] Juice Shop corriendo
- [ ] Elasticsearch corriendo y healthy
- [ ] Kibana corriendo y healthy
- [ ] Filebeat corriendo y enviando logs

#### Datos
- [ ] Logs generándose en Juice Shop
- [ ] Logs llegando a Elasticsearch
- [ ] Índices filebeat-* creados
- [ ] Mínimo 100 documentos en índices

#### Visualización
- [ ] 2 Data Views creados
- [ ] Discover funcional
- [ ] 3+ visualizaciones creadas
- [ ] Dashboard principal creado

#### Seguridad
- [ ] 3 reglas de detección configuradas
- [ ] Alertas funcionando
- [ ] Dashboard de detecciones creado
- [ ] Informe de incidente documentado

#### Documentación
- [ ] Screenshots de todos los pasos (mínimo 42)
- [ ] Comandos documentados
- [ ] Problemas y soluciones registrados
- [ ] Reporte final completo

---

## 🎯 Criterios de Evaluación

### Excelente (90-100%)
- Todos los pasos completados exitosamente
- Documentación exhaustiva con screenshots de calidad
- Problemas resueltos de forma autónoma
- Análisis profundo de logs y detecciones
- Dashboard profesional y bien organizado

### Bueno (80-89%)
- Todos los pasos completados
- Documentación completa con screenshots adecuados
- Algunos problemas resueltos con ayuda
- Análisis básico de logs
- Dashboard funcional

### Satisfactorio (70-79%)
- Mayoría de pasos completados
- Documentación básica con screenshots mínimos
- Problemas resueltos con asistencia significativa
- Análisis superficial
- Dashboard básico

### Insuficiente (<70%)
- Pasos incompletos
- Documentación insuficiente
- No pudo resolver problemas básicos
- Sin análisis de logs
- Sin dashboard

---

## 📝 Plantilla de Informe Final

```markdown
# Proyecto 2 - Sistema de Logging con ELK Stack

## Información del Estudiante
- Nombre: [Tu nombre]
- Carnet: [Tu carnet]
- Fecha: [Fecha de entrega]

## Resumen Ejecutivo
[Breve descripción del proyecto completado]

## Paso 1: Juice Shop Básico
[Documentación completa con screenshots]

## Paso 2: Elasticsearch
[Documentación completa con screenshots]

## Paso 3: Kibana
[Documentación completa con screenshots]

## Paso 4: Filebeat
[Documentación completa con screenshots]

## Paso 5: Visualización en Kibana
[Documentación completa con screenshots]

## Paso 6: Blue Team
[Documentación completa con screenshots]

## Problemas Encontrados y Soluciones
[Lista detallada]

## Conceptos Aprendidos
[Lista de conceptos técnicos]

## Conclusiones
[Reflexión final]

## Anexos
- Screenshots organizados
- Comandos ejecutados
- Configuraciones personalizadas
- Reglas de detección exportadas
```

---

**¡Éxito en tu proyecto!** 🚀✨
