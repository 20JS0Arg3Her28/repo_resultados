# Guía de Documentación con Screenshots

## 📸 Objetivo

Esta guía te ayudará a capturar screenshots profesionales de cada paso del proyecto para tu reporte final.

## 🛠️ Herramientas Recomendadas

### macOS
- **Screenshots**: `Cmd + Shift + 4` (área seleccionada) o `Cmd + Shift + 3` (pantalla completa)
- **Terminal**: iTerm2 con tema claro para mejor legibilidad
- **Navegador**: Chrome o Firefox con DevTools

### Linux
- **Screenshots**: `gnome-screenshot` o `flameshot`
- **Terminal**: Terminator o GNOME Terminal
- **Navegador**: Chrome o Firefox

### Windows
- **Screenshots**: `Win + Shift + S` o Snipping Tool
- **Terminal**: Windows Terminal
- **Navegador**: Chrome o Edge

## 📋 Checklist de Screenshots por Paso

### 📦 PASO 1: Juice Shop Básico

#### Screenshot 1.1: Verificar servicios
```bash
docker compose ps
```
**Qué capturar**: Terminal mostrando el contenedor juice-shop en estado "Up"

**Elementos importantes**:
- Nombre del contenedor
- Estado (Up)
- Puerto mapeado (3000:3000)

#### Screenshot 1.2: Interfaz de Juice Shop
**URL**: http://localhost:3000

**Qué capturar**: Navegador mostrando la página principal de Juice Shop

**Elementos importantes**:
- Barra de navegación
- Productos visibles
- URL en la barra de direcciones

#### Screenshot 1.3: Probar conectividad
```bash
curl http://localhost:3000
```
**Qué capturar**: Terminal mostrando respuesta HTML

**Elementos importantes**:
- Comando ejecutado
- Primeras líneas del HTML recibido

#### Screenshot 1.4: Ver logs del contenedor
```bash
docker compose logs juice-shop | tail -20
```
**Qué capturar**: Terminal mostrando logs de inicio

**Elementos importantes**:
- Mensaje "Server listening on port 3000"
- Timestamp de los logs

---

### 🔍 PASO 2: Elasticsearch

#### Screenshot 2.1: Servicios corriendo
```bash
docker compose ps
```
**Qué capturar**: Terminal mostrando juice-shop y elasticsearch

**Elementos importantes**:
- Ambos contenedores en estado "Up"
- Estado de salud (healthy) de elasticsearch

#### Screenshot 2.2: Salud del cluster
```bash
curl http://localhost:9200/_cluster/health?pretty
```
**Qué capturar**: Terminal mostrando JSON de salud

**Elementos importantes**:
- `"status": "green"` o "yellow"
- `"number_of_nodes": 1`

#### Screenshot 2.3: Información del nodo
```bash
curl http://localhost:9200
```
**Qué capturar**: Terminal mostrando información de Elasticsearch

**Elementos importantes**:
- Versión (8.11.0)
- Nombre del cluster
- Tagline: "You Know, for Search"

#### Screenshot 2.4: Crear documento de prueba
```bash
curl -X POST "http://localhost:9200/test-index/_doc" \
  -H 'Content-Type: application/json' \
  -d '{"message": "Test log", "timestamp": "2025-11-04T10:00:00Z"}'
```
**Qué capturar**: Terminal mostrando respuesta con `"result": "created"`

#### Screenshot 2.5: Ver índices
```bash
curl "http://localhost:9200/_cat/indices?v"
```
**Qué capturar**: Terminal mostrando lista de índices

**Elementos importantes**:
- Índice "test-index" creado
- Número de documentos

---

### 📊 PASO 3: Kibana

#### Screenshot 3.1: Todos los servicios
```bash
docker compose ps
```
**Qué capturar**: Terminal mostrando juice-shop, elasticsearch y kibana

**Elementos importantes**:
- Los 3 contenedores en estado "Up"
- Kibana en estado "healthy"

#### Screenshot 3.2: Pantalla de bienvenida de Kibana
**URL**: http://localhost:5601

**Qué capturar**: Navegador mostrando pantalla inicial de Kibana

**Elementos importantes**:
- Logo de Kibana
- Opciones de inicio
- URL completa

#### Screenshot 3.3: Dev Tools - Query básica
**Ruta**: Menu → Management → Dev Tools

**Query**:
```
GET /
```

**Qué capturar**: Navegador mostrando Dev Tools con query y respuesta

**Elementos importantes**:
- Panel de query a la izquierda
- Respuesta JSON a la derecha
- Información de Elasticsearch

#### Screenshot 3.4: Estado de Kibana
```bash
curl http://localhost:5601/api/status | jq .
```
**Qué capturar**: Terminal mostrando estado de Kibana

**Elementos importantes**:
- `"state": "green"`
- Conexión a Elasticsearch

---

### 📡 PASO 4: Filebeat

#### Screenshot 4.1: Todos los servicios incluyendo Filebeat
```bash
docker compose ps
```
**Qué capturar**: Terminal mostrando los 4 contenedores

**Elementos importantes**:
- Filebeat corriendo
- Todos en estado "Up"

#### Screenshot 4.2: Logs de Filebeat conectándose
```bash
docker compose logs filebeat | grep -i "elasticsearch\|connection"
```
**Qué capturar**: Terminal mostrando conexión exitosa

**Elementos importantes**:
- "Connection to backoff(elasticsearch) established"
- "Pipeline is connecting"

#### Screenshot 4.3: Generar tráfico
```bash
for i in {1..10}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i completada"
  sleep 1
done
```
**Qué capturar**: Terminal mostrando ejecución del loop

#### Screenshot 4.4: Verificar índices de Filebeat
```bash
curl "http://localhost:9200/_cat/indices?v" | grep filebeat
```
**Qué capturar**: Terminal mostrando índices filebeat-*

**Elementos importantes**:
- filebeat-juice-shop-YYYY.MM.DD
- filebeat-docker-YYYY.MM.DD
- Número de documentos

#### Screenshot 4.5: Ver un log capturado
```bash
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"
```
**Qué capturar**: Terminal mostrando documento JSON completo

**Elementos importantes**:
- Campo `@timestamp`
- Campo `message`
- Campo `container.name`

---

### 🎨 PASO 5: Visualización en Kibana

#### Screenshot 5.1: Crear Data View
**Ruta**: Management → Stack Management → Data Views → Create data view

**Qué capturar**: Formulario de creación de Data View

**Configuración visible**:
- Name: "Todos los Logs"
- Index pattern: "filebeat-*"
- Timestamp field: "@timestamp"

#### Screenshot 5.2: Data View creado exitosamente
**Qué capturar**: Pantalla mostrando el Data View creado con lista de campos

**Elementos importantes**:
- Nombre del Data View
- Número de campos detectados
- Lista de campos principales

#### Screenshot 5.3: Discover - Vista inicial
**Ruta**: Analytics → Discover

**Qué capturar**: Interfaz de Discover mostrando logs

**Elementos importantes**:
- Selector de Data View
- Rango de tiempo
- Histograma de logs
- Tabla de logs

#### Screenshot 5.4: Discover - Búsqueda con KQL
**Query**: `container.name: "juice-shop"`

**Qué capturar**: Discover con filtro aplicado

**Elementos importantes**:
- Query en la barra de búsqueda
- Resultados filtrados
- Número de hits

#### Screenshot 5.5: Discover - Log expandido
**Qué capturar**: Un log expandido mostrando todos los campos

**Elementos importantes**:
- Campos estructurados
- Valores de cada campo
- Botones de filtro

#### Screenshot 5.6: Crear visualización - Pie Chart
**Ruta**: Analytics → Visualize Library → Create visualization

**Tipo**: Pie

**Qué capturar**: Editor de visualización con configuración

**Configuración visible**:
- Data view seleccionado
- Campo: container.name.keyword
- Gráfico generado

#### Screenshot 5.7: Crear visualización - Line Chart
**Tipo**: Line

**Qué capturar**: Gráfico de líneas mostrando logs en el tiempo

**Elementos importantes**:
- Eje X: @timestamp
- Eje Y: Count
- Líneas por contenedor

#### Screenshot 5.8: Visualize Library
**Qué capturar**: Biblioteca mostrando todas las visualizaciones creadas

**Elementos importantes**:
- Lista de visualizaciones
- Tipos de visualización
- Fechas de creación

#### Screenshot 5.9: Crear Dashboard
**Ruta**: Analytics → Dashboard → Create dashboard

**Qué capturar**: Dashboard vacío con botón "Add from library"

#### Screenshot 5.10: Dashboard completo
**Qué capturar**: Dashboard con todas las visualizaciones agregadas

**Elementos importantes**:
- Múltiples visualizaciones
- Layout organizado
- Selector de tiempo
- Título del dashboard

#### Screenshot 5.11: Dev Tools - Query avanzada
**Query**:
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

**Qué capturar**: Dev Tools con query de agregación y resultados

---

### 🛡️ PASO 6: Blue Team

#### Screenshot 6.1: Script de tráfico legítimo
```bash
cat scripts/blue-team-traffic.sh
```
**Qué capturar**: Terminal mostrando el script

#### Screenshot 6.2: Ejecución del script
```bash
./scripts/blue-team-traffic.sh
```
**Qué capturar**: Terminal mostrando ejecución con timestamps

#### Screenshot 6.3: Crear regla de detección SQLi
**Ruta**: Security → Detect → Detection rules → Create new rule

**Qué capturar**: Formulario de creación de regla

**Elementos importantes**:
- Nombre de la regla
- KQL query
- Configuración de severidad

#### Screenshot 6.4: Reglas de detección creadas
**Qué capturar**: Lista de todas las reglas configuradas

**Elementos importantes**:
- Regla SQLi
- Regla XSS
- Regla Burst/Scanning
- Estado (enabled)

#### Screenshot 6.5: Simular ataque SQLi
```bash
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"
```
**Qué capturar**: Terminal mostrando ejecución del ataque

#### Screenshot 6.6: Simular ataque XSS
```bash
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>"
```
**Qué capturar**: Terminal mostrando ejecución del ataque

#### Screenshot 6.7: Simular scanning
```bash
for i in {1..30}; do 
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:3000/non-existent-$i"
done
```
**Qué capturar**: Terminal mostrando códigos de respuesta

#### Screenshot 6.8: Alertas disparadas
**Ruta**: Security → Detect → Alerts

**Qué capturar**: Lista de alertas generadas

**Elementos importantes**:
- Nombre de la regla
- Timestamp
- Severidad
- IP origen

#### Screenshot 6.9: Detalle de alerta
**Qué capturar**: Vista detallada de una alerta

**Elementos importantes**:
- Payload completo
- Campos relevantes
- Timeline
- Acciones recomendadas

#### Screenshot 6.10: Dashboard de detecciones
**Qué capturar**: Dashboard personalizado mostrando:
- Total de detecciones
- Detecciones por tipo
- Timeline de ataques
- Top IPs atacantes

#### Screenshot 6.11: Discover - Logs maliciosos
**Query**: `message: *"' OR 1=1"* OR message: *"<script>"*`

**Qué capturar**: Logs filtrados mostrando payloads maliciosos

#### Screenshot 6.12: Análisis de incidente
**Qué capturar**: Documento de análisis en Discover mostrando:
- Payload del ataque
- IP origen
- Timestamp
- Container afectado

---

## 📝 Mejores Prácticas para Screenshots

### 1. Preparación
- **Limpia tu terminal**: Ejecuta `clear` antes de capturar
- **Usa fuente legible**: Tamaño 12-14pt mínimo
- **Tema claro**: Mejor contraste para impresión
- **Ventana completa**: Captura toda la información relevante

### 2. Durante la Captura
- **Incluye contexto**: Muestra el comando y su output
- **Resalta información clave**: Usa flechas o cuadros en post-edición
- **Captura errores también**: Documenta problemas y soluciones
- **Timestamp visible**: Incluye fecha/hora cuando sea relevante

### 3. Organización
```
screenshots/
├── paso-1-juice-shop/
│   ├── 01-docker-compose-ps.png
│   ├── 02-interfaz-web.png
│   ├── 03-curl-test.png
│   └── 04-logs.png
├── paso-2-elasticsearch/
│   ├── 01-servicios.png
│   ├── 02-cluster-health.png
│   └── ...
└── paso-6-blue-team/
    ├── 01-script-trafico.png
    ├── 02-reglas-deteccion.png
    └── ...
```

### 4. Nomenclatura
- **Formato**: `XX-descripcion-corta.png`
- **Ejemplo**: `01-docker-compose-ps.png`
- **Consistencia**: Usa el mismo formato en todos los pasos

### 5. Post-Procesamiento
- **Redimensiona**: 1920x1080 o 1280x720
- **Formato**: PNG para terminal, JPG para navegador
- **Anotaciones**: Usa herramientas como:
  - macOS: Preview, Skitch
  - Linux: GIMP, Shutter
  - Windows: Paint, Greenshot

## 📄 Plantilla de Documentación

Para cada screenshot en tu reporte:

```markdown
### Screenshot X.Y: [Título Descriptivo]

**Comando ejecutado**:
```bash
[comando]
```

**Descripción**:
[Qué muestra este screenshot y por qué es importante]

**Elementos clave**:
- [Elemento 1]
- [Elemento 2]
- [Elemento 3]

**Verificación**:
- [ ] [Criterio de éxito 1]
- [ ] [Criterio de éxito 2]

![Screenshot](./screenshots/paso-X/YY-descripcion.png)
```

## ✅ Checklist Final

Antes de entregar tu reporte, verifica:

- [ ] Todos los pasos tienen al menos 4 screenshots
- [ ] Los screenshots son legibles (texto claro)
- [ ] Cada screenshot tiene descripción
- [ ] Los comandos son reproducibles
- [ ] Los errores están documentados
- [ ] Las soluciones están explicadas
- [ ] Los archivos están organizados
- [ ] Los nombres son consistentes
- [ ] El reporte es profesional
- [ ] La narrativa es clara

## 🎯 Cantidad Mínima de Screenshots

| Paso | Screenshots Mínimos | Screenshots Recomendados |
|------|---------------------|--------------------------|
| Paso 1 | 4 | 6 |
| Paso 2 | 5 | 8 |
| Paso 3 | 4 | 6 |
| Paso 4 | 5 | 8 |
| Paso 5 | 12 | 15 |
| Paso 6 | 12 | 15 |
| **TOTAL** | **42** | **58** |

## 💡 Tips Adicionales

1. **Captura en tiempo real**: Toma screenshots mientras ejecutas, no después
2. **Documenta errores**: Los problemas y soluciones son valiosos
3. **Sé consistente**: Usa el mismo formato en todo el proyecto
4. **Agrega contexto**: Explica qué estás viendo y por qué importa
5. **Revisa antes de entregar**: Asegúrate de que todo sea legible

## 🆘 Problemas Comunes

### Screenshot borroso
- **Causa**: Resolución baja o redimensionamiento
- **Solución**: Captura en resolución nativa, no redimensiones

### Texto ilegible
- **Causa**: Fuente muy pequeña
- **Solución**: Aumenta tamaño de fuente a 14pt mínimo

### Información sensible visible
- **Causa**: IPs, tokens, contraseñas en pantalla
- **Solución**: Pixela o redacta información sensible

### Falta de contexto
- **Causa**: Screenshot muy recortado
- **Solución**: Incluye barra de direcciones, prompt de terminal

---

**¡Buena suerte con tu documentación!** 📸✨
