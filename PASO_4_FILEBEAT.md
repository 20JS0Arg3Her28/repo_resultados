# Paso 4: Agregar Filebeat - El Conector Crítico
<a id="readme-top"></a>

<!--
PROJECT DESCRIPTION
-->
## 📜 Descripción

Implementar Filebeat como recolector de logs que conecta Juice Shop con Elasticsearch, completando el flujo de datos del sistema ELK.

**Filebeat** es un "shipper" (transportador) ligero de logs, parte de la familia Beats de Elastic.

### Características principales:
1. **Ligero**: Consume pocos recursos (~10-50MB RAM)
2. **Confiable**: No pierde datos si Elasticsearch cae
3. **Específico para logs**: Optimizado para leer archivos de texto
4. **Integrado**: Diseñado para trabajar con Elasticsearch

### Familia Beats:
- **Filebeat**: Logs de archivos
- **Metricbeat**: Métricas del sistema (CPU, RAM)
- **Packetbeat**: Tráfico de red
- **Heartbeat**: Monitoreo de disponibilidad
- **Auditbeat**: Auditoría de seguridad

### ¿Por qué necesitamos Filebeat?

**Sin Filebeat** (Juice Shop y Elasticsearch desconectados):
```
PASO 1: Juice Shop          PASO 2: Elasticsearch       PASO 3: Kibana
┌──────────────┐              ┌──────────────┐           ┌──────────────┐
│ Juice Shop   │              │              │           │              │
│              │              │ Elasticsearch├───────────┤   Kibana     │
│ Logs en      │      ❌      │              │  query    │              │
│ archivos     │   NO HAY     │ Vacío        │           │ Sin datos    │
│              │   CONEXIÓN   │              │           │ para mostrar │
└──────────────┘              └──────────────┘           └──────────────┘
```

**Con Filebeat** (Flujo completo):
```
PASO 1              PASO 4 (NUEVO)        PASO 2              PASO 3
┌──────────┐        ┌──────────┐        ┌──────────┐        ┌──────────┐
│  Juice   │        │          │        │          │        │          │
│  Shop    ├────────┤ Filebeat ├────────┤Elastics- ├────────┤  Kibana  │
│          │  logs  │          │  JSON  │  earch   │ query  │          │
│ Genera   │        │ Lee      │        │ Almacena │        │ Muestra  │
│ logs     │        │ Procesa  │        │ Indexa   │        │ Visualiza│
└──────────┘        └──────────┘        └──────────┘        └──────────┘
    │                    │                    │                   │
    │                    │                    │                   │
    │                    │                    │                   │
Archivos            Monitorea            Índices             Usuario
.log en             archivos             con datos           ve logs
contenedor          Docker               estructurados       en tiempo
                                                             real
```

## 🔗 Relación con pasos anteriores

### El problema que resolvemos:

Hasta ahora tenemos:
- ✅ **Paso 1**: Juice Shop genera logs
- ✅ **Paso 2**: Elasticsearch puede almacenar logs
- ✅ **Paso 3**: Kibana puede visualizar logs
- ❌ **Problema**: No hay conexión entre Juice Shop y Elasticsearch

### ¿Cómo funciona Filebeat?

**Arquitectura interna**:
```
┌─────────────────────────────────────────────────────────────────┐
│                    FILEBEAT                                     │
│                                                                 │
│  ┌────────────┐      ┌──────────────┐                         │
│  │   Inputs   ├──────┤  Processors  │                         │
│  │            │      │              │                         │
│  │ - Container│      │ - Parse JSON │                         │
│  │ - Log      │      │ - Add fields │                         │
│  │ - Syslog   │      │ - Filter     │                         │
│  └────────────┘      └──────────────┘                         │
│                             │                                   │
│                             │                                   │
│                      ┌──────────────┐                         │
│                      │   Output     │                         │
│                      │              │                         │
│                      │ Elasticsearch│                         │
│                      │ Logstash     │                         │
│                      │ Kafka        │                         │
│                      └──────────────┘                         │
└─────────────────────────────────────────────────────────────────┘
```

### Proceso paso a paso:

1. **Input lee archivos**:
   ```
   /var/lib/docker/containers/abc123.../abc123...-json.log
   ```

2. **Parser extrae información**:
   ```json
   {
     "log": "GET /api/Products 200 45ms\n",
     "stream": "stdout",
     "time": "2025-11-04T10:30:00Z"
   }
   ```

3. **Processors enriquecen**:
   ```json
   {
     "message": "GET /api/Products 200 45ms",
     "@timestamp": "2025-11-04T10:30:00Z",
     "container": {
       "name": "juice-shop",
       "id": "abc123..."
     },
     "host": {
       "name": "docker-host"
     }
   }
   ```

4. **Output envía a Elasticsearch**:
   ```
   POST http://elasticsearch:9200/filebeat-logs/_doc
   ```

## 📦 Requisitos

- Docker
- Docker Compose
- Elasticsearch funcionando (Paso 2)
- Kibana funcionando (Paso 3)
- Acceso a archivos de logs de Docker

## 📋 Componentes Implementados

### 1. Servicio en docker-compose.yml

```yaml
filebeat:
  image: docker.elastic.co/beats/filebeat:8.11.0
  container_name: filebeat
  user: root
  volumes:
    - ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
    - /var/lib/docker/containers:/var/lib/docker/containers:ro
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - filebeat-data:/usr/share/filebeat/data
  environment:
    - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    - KIBANA_HOST=http://kibana:5601
  networks:
    - elk-network
  depends_on:
    elasticsearch:
      condition: service_healthy
  restart: unless-stopped
  command: filebeat -e -strict.perms=false
```

#### Explicación línea por línea:

**`user: root`**
- Necesita leer archivos de Docker en `/var/lib/docker/containers`
- Estos archivos pertenecen a root
- Sin root: "Permission denied"
- ⚠️ **Nota de seguridad**: En producción, usar permisos más restrictivos

**`volumes` - Los 4 montajes críticos**:

1. **Configuración de Filebeat**:
```yaml
- ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
```
- Monta nuestro archivo de configuración
- `:ro` = read-only (solo lectura)
- Filebeat lee este archivo al iniciar

2. **Logs de Docker**:
```yaml
- /var/lib/docker/containers:/var/lib/docker/containers:ro
```
**¿Qué hay ahí?**:
```
/var/lib/docker/containers/
├── abc123.../
│   └── abc123...-json.log  ← Logs de juice-shop
├── def456.../
│   └── def456...-json.log  ← Logs de elasticsearch
└── ghi789.../
    └── ghi789...-json.log  ← Logs de kibana
```

**Formato de los logs**:
```json
{"log":"Server listening on port 3000\n","stream":"stdout","time":"2025-11-04T10:30:00.123Z"}
{"log":"GET /api/Products 200\n","stream":"stdout","time":"2025-11-04T10:30:05.456Z"}
```

3. **Socket de Docker**:
```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```
**¿Para qué?**:
- API de Docker
- Filebeat consulta metadatos de contenedores:
  - Nombre del contenedor
  - Labels
  - IDs
  - Estado

**Ejemplo de uso**:
```bash
# Filebeat pregunta: "¿Qué contenedor tiene ID abc123?"
# Docker responde: "juice-shop"
# Filebeat agrega: container.name = "juice-shop"
```

4. **Datos de Filebeat**:
```yaml
- filebeat-data:/usr/share/filebeat/data
```
**¿Qué almacena?**:
- **Registry**: Qué archivos ya leyó y hasta dónde
- **Estado**: Posición actual en cada archivo
- **Metadata**: Información de tracking

**¿Por qué es importante?**:
- Evita duplicados
- Continúa donde quedó si se reinicia
- No pierde datos

**Ejemplo de registry**:
```json
{
  "/var/lib/docker/containers/abc123.../abc123...-json.log": {
    "offset": 12345,
    "timestamp": "2025-11-04T10:30:00Z"
  }
}
```

**`environment`**:
```yaml
- ELASTICSEARCH_HOSTS=http://elasticsearch:9200
- KIBANA_HOST=http://kibana:5601
```
- Sobrescribe valores en filebeat.yml
- Permite configuración flexible
- Usa nombres de servicio Docker

**`depends_on`**:
```yaml
depends_on:
  elasticsearch:
    condition: service_healthy
```
**Orden de inicio**:
```
1. Elasticsearch inicia
2. Elasticsearch healthcheck pasa ✓
3. Filebeat inicia
4. Filebeat conecta inmediatamente
```

**`command`**:
```yaml
command: filebeat -e -strict.perms=false
```
- `-e`: Logs a stderr (los vemos con `docker compose logs`)
- `-strict.perms=false`: Ignora permisos de filebeat.yml

### 2. Archivo filebeat.yml

```yaml
filebeat.inputs:
  - type: container
    enabled: true
    paths:
      - '/var/lib/docker/containers/*/*.log'
    processors:
      - add_docker_metadata:
          host: "unix:///var/run/docker.sock"
      - decode_json_fields:
          fields: ["message"]
          target: "json"
          overwrite_keys: true

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~

output.elasticsearch:
  hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
  indices:
    - index: "filebeat-juice-shop-%{+yyyy.MM.dd}"
      when.contains:
        container.name: "juice-shop"
    - index: "filebeat-docker-%{+yyyy.MM.dd}"

setup.kibana:
  host: "${KIBANA_HOST:kibana:5601}"

setup.dashboards.enabled: true

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```

#### Explicación sección por sección:

**`filebeat.inputs`** - ¿Qué leerá?:

```yaml
- type: container
```
- Input especializado para contenedores Docker
- Entiende el formato JSON de Docker
- Maneja rotación de logs automáticamente

```yaml
paths:
  - '/var/lib/docker/containers/*/*.log'
```
- `*/*`: Todos los contenedores, todos los logs
- Wildcard permite detectar nuevos contenedores automáticamente

**`processors`** - ¿Cómo procesar?:

1. **add_docker_metadata**:
```yaml
- add_docker_metadata:
    host: "unix:///var/run/docker.sock"
```

**Antes**:
```json
{
  "message": "GET /api/Products 200"
}
```

**Después**:
```json
{
  "message": "GET /api/Products 200",
  "container": {
    "id": "abc123",
    "name": "juice-shop",
    "image": {
      "name": "bkimminich/juice-shop"
    }
  }
}
```

2. **decode_json_fields**:
```yaml
- decode_json_fields:
    fields: ["message"]
    target: "json"
    overwrite_keys: true
```

**Antes**:
```json
{
  "message": "{\"level\":\"info\",\"msg\":\"Server started\"}"
}
```

**Después**:
```json
{
  "message": "{\"level\":\"info\",\"msg\":\"Server started\"}",
  "json": {
    "level": "info",
    "msg": "Server started"
  }
}
```

3. **add_host_metadata**:
```yaml
- add_host_metadata:
```

Agrega:
```json
{
  "host": {
    "name": "docker-host",
    "os": {
      "platform": "darwin",
      "version": "25.0.0"
    },
    "ip": ["192.168.1.100"]
  }
}
```

**`output.elasticsearch`** - ¿Dónde enviar?:

```yaml
hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
```
- `${VAR:default}`: Lee variable de entorno o usa default
- Permite configuración flexible

**Índices dinámicos**:
```yaml
indices:
  - index: "filebeat-juice-shop-%{+yyyy.MM.dd}"
    when.contains:
      container.name: "juice-shop"
  - index: "filebeat-docker-%{+yyyy.MM.dd}"
```

**¿Qué hace?**:
- Si el log es de "juice-shop" → `filebeat-juice-shop-2025.11.04`
- Si es de otro contenedor → `filebeat-docker-2025.11.04`
- `%{+yyyy.MM.dd}`: Fecha actual

**Ventajas**:
- Logs separados por aplicación
- Índices diarios (fácil de limpiar logs viejos)
- Búsquedas más rápidas (menos datos por índice)

**`setup.kibana`** - Configuración de Kibana:

```yaml
setup.kibana:
  host: "${KIBANA_HOST:kibana:5601}"

setup.dashboards.enabled: true
```

**¿Qué hace?**:
- Filebeat carga dashboards predefinidos en Kibana
- Crea visualizaciones automáticas
- Configura Data Views

**Dashboards incluidos**:
- Docker overview
- Container metrics
- Log analysis

## 🚀 Instalación y Ejecución

### 1. Levantar todos los servicios
```bash
docker compose up -d
```

### 2. Verificar que Filebeat inició correctamente
```bash
docker compose logs filebeat | grep -i "elasticsearch\|kibana\|pipeline"
```

**Mensajes esperados**:
```
filebeat  | "Elasticsearch url: http://elasticsearch:9200"
filebeat  | "Kibana url: http://kibana:5601"
filebeat  | "Pipeline is connecting"
filebeat  | "Connection to backoff(elasticsearch(http://elasticsearch:9200)) established"
```

### 3. Generar logs en Juice Shop
```bash
# Hacer 10 requests
for i in {1..10}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

### 4. Esperar procesamiento
```bash
# Esperar 30 segundos para que Filebeat procese
sleep 30
```

### 5. Verificar índices en Elasticsearch
```bash
curl 'http://localhost:9200/_cat/indices?v'
```

**Salida esperada**:
```
health status index                          docs.count
yellow open   filebeat-juice-shop-2025.11.04     10
yellow open   filebeat-docker-2025.11.04         50
```

### 6. Ver un log específico
```bash
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"
```

**Respuesta esperada**:
```json
{
  "hits": {
    "hits": [
      {
        "_source": {
          "@timestamp": "2025-11-04T10:30:00Z",
          "message": "GET / 200",
          "container": {
            "name": "juice-shop",
            "id": "abc123"
          },
          "host": {
            "name": "docker-host"
          }
        }
      }
    ]
  }
}
```

### 7. Verificar en Kibana

1. Abre http://localhost:5601
2. Ve a **Management** → **Stack Management** → **Data Views**
3. Deberías ver:
   - `filebeat-*` (creado automáticamente)
4. Ve a **Analytics** → **Discover**
5. Selecciona `filebeat-*`
6. Filtra: `container.name: "juice-shop"`
7. ¡Deberías ver tus logs!

## 🔄 Flujo Completo de un Log

### Paso a paso detallado:

```
1. Usuario accede a Juice Shop
   http://localhost:3000
   ↓
2. Juice Shop procesa request y genera log
   console.log("GET /api/Products 200 45ms")
   ↓
3. Docker captura stdout y lo escribe en archivo
   /var/lib/docker/containers/abc123.../abc123...-json.log
   {"log":"GET /api/Products 200 45ms\n","stream":"stdout","time":"2025-11-04T10:30:00Z"}
   ↓
4. Filebeat detecta nuevo contenido en archivo
   (monitorea con inotify/fsnotify)
   ↓
5. Filebeat lee la línea nueva
   ↓
6. Filebeat parsea JSON de Docker
   Extrae: log, stream, time
   ↓
7. Filebeat consulta Docker API
   "¿Qué contenedor es abc123?"
   Docker responde: "juice-shop"
   ↓
8. Filebeat agrega metadata
   {
     "message": "GET /api/Products 200 45ms",
     "@timestamp": "2025-11-04T10:30:00Z",
     "container": {
       "name": "juice-shop",
       "id": "abc123"
     },
     "host": {...}
   }
   ↓
9. Filebeat determina índice
   container.name = "juice-shop"
   → índice: "filebeat-juice-shop-2025.11.04"
   ↓
10. Filebeat envía a Elasticsearch
    POST http://elasticsearch:9200/filebeat-juice-shop-2025.11.04/_doc
    ↓
11. Elasticsearch indexa el documento
    Analiza texto, crea índice invertido
    ↓
12. Elasticsearch confirma a Filebeat
    {"result": "created", "_id": "xyz789"}
    ↓
13. Filebeat actualiza registry
    "Leyó hasta posición 12345 del archivo abc123...-json.log"
    ↓
14. Usuario abre Kibana
    http://localhost:5601
    ↓
15. Kibana consulta Elasticsearch
    GET /filebeat-*/_search
    ↓
16. Elasticsearch retorna resultados
    ↓
17. Kibana muestra log en pantalla
    → Usuario ve: "GET /api/Products 200 45ms"
```

**Tiempo total**: ~1-2 segundos (near real-time)

## 🏗️ Arquitectura Completa Final

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        TU MÁQUINA                                           │
│                                                                             │
│  Navegador ←→ http://localhost:3000 (Juice Shop)                          │
│  Navegador ←→ http://localhost:5601 (Kibana)                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTP
                              │
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DOCKER - elk-network                                     │
│                                                                             │
│  ┌──────────────────────┐                                                  │
│  │  Juice Shop          │                                                  │
│  │  Puerto 3000         │                                                  │
│  │                      │                                                  │
│  │ 1. Genera logs       │                                                  │
│  └──────────────────────┘                                                  │
│           │                                                                 │
│           │ stdout/stderr                                                   │
│           │                                                                 │
│  ┌──────────────────────────────────────────────┐                         │
│  │  Docker Engine                                │                         │
│  │  /var/lib/docker/containers/                  │                         │
│  │  ├── abc123.../abc123...-json.log             │                         │
│  │  2. Escribe logs en archivos                  │                         │
│  └──────────────────────────────────────────────┘                         │
│           │                                                                 │
│           │ lee archivos                                                    │
│           │                                                                 │
│  ┌──────────────────────┐         ┌──────────────────────┐              │
│  │   Filebeat           │────────▶│ Elasticsearch        │              │
│  │                      │         │ Puerto 9200          │              │
│  │ 3. Lee logs          │  HTTP   │                      │              │
│  │ 4. Procesa           │  POST   │ 6. Indexa            │              │
│  │ 5. Enriquece         │  (JSON) │ 7. Almacena          │              │
│  └──────────────────────┘         └──────────────────────┘              │
│                                              │                             │
│                                              │ query                       │
│                                    ┌──────────────────────┐              │
│                                    │   Kibana             │              │
│                                    │   Puerto 5601        │              │
│                                    │                      │              │
│                                    │ 8. Consulta          │              │
│                                    │ 9. Visualiza         │              │
│                                    └──────────────────────┘              │
│                                              │                             │
│  ┌──────────────────────┐                                                   │
│  │  Volumen             │                                                   │
│  │  elasticsearch-      │                                                   │
│  │  data                │                                                   │
│  │                      │                                                   │
│  │ Persistencia         │                                                   │
│  └──────────────────────┘                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 💡 Conceptos Clave

### 1. **Registry de Filebeat**
- Archivo que trackea qué se ha leído
- Ubicación: `/usr/share/filebeat/data/registry`
- Evita duplicados
- Permite reanudar después de reinicio

### 2. **Backpressure**
- Si Elasticsearch está lento, Filebeat espera
- No pierde datos
- Buffer interno para almacenar temporalmente

### 3. **At-least-once delivery**
- Garantiza que cada log llega al menos una vez
- Puede haber duplicados en casos raros
- Elasticsearch maneja duplicados con `_id`

### 4. **Input types**
- `container`: Para logs de Docker
- `log`: Para archivos normales
- `syslog`: Para syslog
- `stdin`: Para entrada estándar

### 5. **Processors**
- Transforman datos antes de enviarlos
- Ejemplos: parse JSON, add fields, filter
- Se ejecutan en orden secuencial

### 6. **Índices dinámicos**
- Crea índices basados en condiciones
- Útil para separar logs por aplicación
- Facilita mantenimiento y búsquedas

## ➡️ Siguiente Paso

**Estado actual**:
- ✅ Juice Shop genera logs
- ✅ Filebeat lee y procesa logs
- ✅ Elasticsearch almacena logs
- ✅ Kibana puede visualizar logs
- ⚠️ **SIGUIENTE**: Configurar visualizaciones en Kibana

**Próximo paso**: Ver `PASO_5_VISUALIZACION_KIBANA.md`

El sistema ELK está completo y funcional. Ahora puedes crear dashboards, gráficos y visualizaciones personalizadas para analizar los logs recolectados.

## 🔧 Troubleshooting

### Problema: Filebeat no encuentra logs
```bash
# Verificar que el volumen está montado
docker exec filebeat ls -la /var/lib/docker/containers

# Debería mostrar directorios
```

### Problema: Permission denied
```bash
# Verificar que corre como root
docker compose ps

# USER debería ser "root"
```

### Problema: No se crean índices
```bash
# Ver logs de Filebeat
docker compose logs filebeat | grep -i error

# Verificar conectividad a Elasticsearch
docker exec filebeat curl http://elasticsearch:9200
```

### Problema: Logs duplicados
- Normal en reinicios
- Elasticsearch deduplica automáticamente
- No es un problema crítico

### Problema: Filebeat no inicia
```bash
# Verificar logs completos
docker compose logs filebeat

# Verificar que Elasticsearch está healthy
docker compose ps elasticsearch
```

### Problema: No veo logs en Kibana
```bash
# Verificar que los índices existen
curl 'http://localhost:9200/_cat/indices?v'

# Verificar que Filebeat está enviando datos
docker compose logs filebeat | grep -i "publish"
```

## ✅ Resumen

### Logrado
- [x] Filebeat corriendo y conectado
- [x] Leyendo logs de todos los contenedores Docker
- [x] Procesando y enriqueciendo logs
- [x] Enviando a Elasticsearch correctamente
- [x] Índices creados automáticamente

### Verificado
- [x] Logs de Juice Shop en Elasticsearch
- [x] Índices con formato correcto
- [x] Metadata de contenedor agregada
- [x] Visible en Kibana

### Entendido
- [x] Flujo completo de un log
- [x] Cómo Filebeat lee archivos de Docker
- [x] Procesamiento y enriquecimiento
- [x] Comunicación entre todos los componentes
- [x] Arquitectura completa del sistema ELK

### Sistema Completo
```
Juice Shop → Docker → Filebeat → Elasticsearch → Kibana → Usuario
    ✓         ✓         ✓            ✓             ✓        ✓
```

<p align="right">(<a href="#readme-top">Ir al inicio</a>)</p>
