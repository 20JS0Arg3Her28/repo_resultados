# Paso 5: Configurar Visualización en Kibana
<a id="readme-top"></a>

<!--
PROJECT DESCRIPTION
-->
## 📜 Descripción

Configurar Kibana para visualizar y analizar los logs recolectados, creando Data Views, búsquedas, visualizaciones y dashboards.

**Kibana** es la interfaz de visualización oficial para Elasticsearch. En este paso, configuraremos todas las capacidades de visualización de Kibana para interactuar con los datos almacenados en Elasticsearch.

### Características principales que configuraremos:

1. **Data Views**: Define qué índices de Elasticsearch mostrar
2. **Discover**: Explora logs en tiempo real con búsquedas interactivas
3. **Visualize**: Crea gráficos individuales (barras, líneas, pie charts, tablas)
4. **Dashboard**: Combina múltiples visualizaciones en una vista unificada
5. **Dev Tools**: Consola para queries directas a Elasticsearch

### ¿Por qué es importante este paso?

**Sin configuración** (Kibana básico):
- Kibana está corriendo pero no sabe qué datos mostrar
- No hay visualizaciones creadas
- No hay dashboards para monitoreo
- Difícil analizar logs sin herramientas visuales

**Con configuración completa**:
- Data Views configurados para todos los logs
- Visualizaciones interactivas creadas
- Dashboards profesionales para monitoreo
- Búsquedas guardadas para análisis rápido
- Herramientas de debugging disponibles

## 🔗 Relación con pasos anteriores

### Estado actual del flujo:
```
Juice Shop → Docker → Filebeat → Elasticsearch → Kibana (sin configurar)
```

**Tenemos**:
- ✅ Logs generándose en Juice Shop (Paso 1)
- ✅ Elasticsearch almacenando logs (Paso 2)
- ✅ Kibana corriendo y conectado (Paso 3)
- ✅ Filebeat recolectando y enviando (Paso 4)
- ✅ Elasticsearch almacenando (555+ documentos)

**Nos falta**:
- ❌ Decirle a Kibana qué índices mostrar
- ❌ Crear búsquedas útiles
- ❌ Crear visualizaciones
- ❌ Armar dashboards

### Flujo completo después de este paso:
```
┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Juice Shop  │──▶│   Filebeat   │──▶│ Elasticsearch│──▶│   Kibana     │──▶│   Usuario    │
│              │   │              │   │              │   │              │   │              │
│ Genera logs  │   │ Recolecta    │   │ Almacena     │   │ Visualiza    │   │ Ve dashboards│
│              │   │ Procesa      │   │ Indexa       │   │ Crea gráficos│   │ Analiza      │
└──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘   └──────────────┘
```

## 📦 Requisitos

- Docker
- Docker Compose
- Kibana funcionando (Paso 3)
- Elasticsearch funcionando (Paso 2)
- Filebeat funcionando y enviando datos (Paso 4)
- Navegador web

## 📋 Conceptos de Kibana

### 1. **Data View** (antes Index Pattern)
- Define **QUÉ** datos de Elasticsearch mostrar
- Usa wildcards: `filebeat-*` muestra todos los índices filebeat
- Necesario antes de usar Discover, Visualize o Dashboard
- Reemplaza el concepto antiguo de "Index Pattern"

### 2. **Discover**
- Explorador de logs en tiempo real
- Búsqueda con KQL (Kibana Query Language)
- Filtros interactivos
- Vista de tabla con campos personalizables
- Auto-refresh para monitoreo en tiempo real

### 3. **Visualize**
- Crea gráficos individuales
- Tipos: líneas, barras, pie, mapas, métricas, tablas
- Basados en agregaciones de Elasticsearch
- Reutilizables en múltiples dashboards

### 4. **Dashboard**
- Combina múltiples visualizaciones
- Vista general del sistema
- Interactivo (filtros afectan todas las visualizaciones)
- Permite compartir vistas con otros usuarios

### 5. **Dev Tools**
- Consola para queries directas a Elasticsearch
- Útil para debugging
- Sintaxis JSON
- Ejecuta queries de Elasticsearch directamente

## 🚀 Configuración Paso a Paso

### PARTE 1: Crear Data View

#### 1.1 Acceder a Kibana

```
http://localhost:5601
```

**Primera vez**:
- Puede mostrar pantalla de bienvenida
- Click en "Explore on my own"
- O ir directamente al menú

#### 1.2 Navegar a Data Views

```
☰ Menu → Management → Stack Management → Data Views
```

**Ruta completa**:
1. Click en el ícono de menú (☰) arriba a la izquierda
2. Scroll hasta "Management"
3. Click en "Stack Management"
4. En el menú lateral, bajo "Kibana", click en "Data Views"

#### 1.3 Crear Data View para todos los logs

Click en **"Create data view"**

**Configuración**:
```
Name: Todos los Logs
Index pattern: filebeat-*
Timestamp field: @timestamp
```

**Explicación**:
- `filebeat-*`: Incluye todos los índices que empiecen con "filebeat-"
  - `filebeat-docker-2025.11.04`
  - `filebeat-juice-shop-2025.11.04`
  - `filebeat-docker-2025.11.05` (mañana)
- `@timestamp`: Campo de tiempo para ordenar logs

Click **"Save data view to Kibana"**

#### 1.4 Crear Data View solo para Juice Shop

Click en **"Create data view"** nuevamente

**Configuración**:
```
Name: Juice Shop Logs
Index pattern: filebeat-juice-shop-*
Timestamp field: @timestamp
```

**¿Por qué crear este adicional?**:
- Filtra automáticamente solo logs de Juice Shop
- Búsquedas más rápidas (menos datos)
- Visualizaciones específicas de la aplicación

Click **"Save data view to Kibana"**

### PARTE 2: Explorar Logs en Discover

#### 2.1 Acceder a Discover

```
☰ Menu → Analytics → Discover
```

#### 2.2 Seleccionar Data View

- En la parte superior, verás un dropdown con el Data View actual
- Click y selecciona "Todos los Logs"

#### 2.3 Ajustar rango de tiempo

- Esquina superior derecha: selector de tiempo
- Click en el calendario
- Selecciona "Last 1 hour" o "Last 15 minutes"
- Click "Apply"

**¿Por qué es importante?**:
- Por defecto muestra últimos 15 minutos
- Si no ves logs, amplía el rango
- Logs más antiguos pueden estar en índices de días anteriores

#### 2.4 Ver la tabla de logs

**Columnas por defecto**:
- `@timestamp`: Cuándo ocurrió
- `_source`: Documento completo (JSON)

**Expandir un log**:
1. Click en el símbolo `>` a la izquierda de un log
2. Verás todos los campos:
   - `message`: Mensaje del log
   - `container.name`: Nombre del contenedor
   - `container.id`: ID del contenedor
   - `host.name`: Host donde corre
   - etc.

#### 2.5 Agregar columnas útiles

Click en **"+ Add field"** arriba de la tabla

Agrega estos campos:
1. `container.name`
2. `message`
3. `log.level` (si existe)

**Resultado**: Tabla más legible con información clave

### PARTE 3: Búsquedas con KQL

#### 3.1 Búsqueda básica

En la barra de búsqueda arriba:

**Ver solo logs de Juice Shop**:
```
container.name: "juice-shop"
```

**Ver logs que contienen "error"**:
```
message: *error*
```

**Ver logs de Elasticsearch**:
```
container.name: "elasticsearch"
```

#### 3.2 Búsquedas combinadas

**Errores de Juice Shop**:
```
container.name: "juice-shop" AND message: *error*
```

**Logs de Juice Shop o Kibana**:
```
container.name: ("juice-shop" OR "kibana")
```

**Excluir logs de Filebeat**:
```
NOT container.name: "filebeat"
```

#### 3.3 Búsquedas por tiempo

**Logs de la última hora**:
- Usa el selector de tiempo (no KQL)

**Logs de un día específico**:
```
@timestamp >= "2025-11-04" AND @timestamp < "2025-11-05"
```

#### 3.4 Guardar búsqueda

1. Click en "Save" arriba
2. Nombre: "Errores de Juice Shop"
3. Click "Save"

**Uso posterior**:
- Click en "Open" arriba
- Selecciona tu búsqueda guardada

### PARTE 4: Crear Visualizaciones

#### 4.1 Acceder a Visualize

```
☰ Menu → Analytics → Visualize Library
```

#### 4.2 Crear visualización: Logs por Contenedor

Click **"Create visualization"**

**Tipo**: Pie Chart (gráfico de pastel)

**Configuración**:
1. **Data view**: Selecciona "Todos los Logs"
2. **Time range**: Last 1 hour
3. **Slice by**: 
   - Click en "Add or drag-and-drop a field"
   - Selecciona `container.name.keyword`
4. **Metric**: Count (por defecto)

**Resultado**: Gráfico circular mostrando distribución de logs por contenedor

Click **"Save"**:
- Título: "Distribución de Logs por Contenedor"
- Click "Save and return"

#### 4.3 Crear visualización: Logs en el Tiempo

Click **"Create visualization"**

**Tipo**: Line Chart (gráfico de líneas)

**Configuración**:
1. **Data view**: "Todos los Logs"
2. **Time range**: Last 1 hour
3. **Horizontal axis**: `@timestamp` (automático)
4. **Vertical axis**: Count
5. **Break down by**: `container.name.keyword`

**Resultado**: Líneas de tiempo mostrando volumen de logs por contenedor

Click **"Save"**:
- Título: "Volumen de Logs en el Tiempo"

#### 4.4 Crear visualización: Top Mensajes

Click **"Create visualization"**

**Tipo**: Table (tabla)

**Configuración**:
1. **Data view**: "Juice Shop Logs"
2. **Rows**: 
   - `message.keyword`
   - Top 10 values
3. **Metric**: Count

**Resultado**: Tabla con los 10 mensajes más frecuentes de Juice Shop

Click **"Save"**:
- Título: "Top 10 Mensajes de Juice Shop"

#### 4.5 Crear visualización: Métrica Total

Click **"Create visualization"**

**Tipo**: Metric (número grande)

**Configuración**:
1. **Data view**: "Todos los Logs"
2. **Metric**: Count

**Resultado**: Número grande mostrando total de logs

Click **"Save"**:
- Título: "Total de Logs"

### PARTE 5: Crear Dashboard

#### 5.1 Acceder a Dashboards

```
☰ Menu → Analytics → Dashboard
```

#### 5.2 Crear nuevo dashboard

Click **"Create dashboard"**

#### 5.3 Agregar visualizaciones

Click **"Add from library"**

Selecciona las visualizaciones que creaste:
1. "Total de Logs"
2. "Distribución de Logs por Contenedor"
3. "Volumen de Logs en el Tiempo"
4. "Top 10 Mensajes de Juice Shop"

Click **"Add"**

#### 5.4 Organizar dashboard

**Redimensionar**:
- Arrastra las esquinas de cada visualización

**Mover**:
- Arrastra desde el título

**Sugerencia de layout**:
```
┌─────────────────────────────────────────┐
│  Total de Logs    │  Distribución (Pie) │
├─────────────────────────────────────────┤
│  Volumen en el Tiempo (Line)           │
├─────────────────────────────────────────┤
│  Top 10 Mensajes (Table)               │
└─────────────────────────────────────────┘
```

#### 5.5 Guardar dashboard

Click **"Save"**:
- Título: "Overview de Logs del Sistema"
- Descripción: "Dashboard principal mostrando logs de todos los contenedores"
- Click "Save"

### PARTE 6: Usar Dev Tools

#### 6.1 Acceder a Dev Tools

```
☰ Menu → Management → Dev Tools
```

#### 6.2 Queries útiles

**Ver salud de Elasticsearch**:
```json
GET /_cluster/health
```

**Ver todos los índices**:
```json
GET /_cat/indices?v
```

**Buscar logs de Juice Shop**:
```json
GET /filebeat-juice-shop-*/_search
{
  "query": {
    "match": {
      "message": "GET"
    }
  },
  "size": 10
}
```

**Contar logs por contenedor**:
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

**Logs de las últimas 5 minutos**:
```json
GET /filebeat-*/_search
{
  "query": {
    "range": {
      "@timestamp": {
        "gte": "now-5m"
      }
    }
  }
}
```

## 💡 Casos de Uso Prácticos

### Caso 1: Monitorear errores en tiempo real

**Objetivo**: Ver errores de Juice Shop inmediatamente

**Pasos**:
1. Discover → "Juice Shop Logs"
2. Búsqueda: `message: *error* OR message: *ERROR*`
3. Time range: "Last 15 minutes"
4. Habilitar auto-refresh (arriba a la derecha)
5. Selecciona "10 seconds"

**Resultado**: Tabla que se actualiza cada 10 segundos con nuevos errores

### Caso 2: Analizar tráfico HTTP

**Objetivo**: Ver qué endpoints se están usando

**Pasos**:
1. Discover → "Juice Shop Logs"
2. Búsqueda: `message: *GET* OR message: *POST*`
3. Crear visualización tipo "Data Table"
4. Extraer método y ruta con regex (avanzado)

### Caso 3: Comparar volumen entre contenedores

**Objetivo**: Ver qué contenedor genera más logs

**Pasos**:
1. Visualize → Bar Chart
2. Horizontal axis: `container.name.keyword`
3. Vertical axis: Count
4. Agregar al dashboard

### Caso 4: Alertas (concepto)

**Objetivo**: Notificar cuando hay muchos errores

**Nota**: Requiere configuración avanzada (Watcher/Alerting)

**Concepto**:
```
IF (count of logs with "error" in last 5 minutes) > 10
THEN send notification
```

## 🏗️ Arquitectura Completa con Usuario

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         USUARIO                                        │
│                                                                         │
│  1. Usa Juice Shop → Genera logs                                       │
│  2. Abre Kibana → Ve logs en tiempo real                               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
             │                                 │
             │ HTTP                            │ HTTP
             │                                 │
┌────────────┴──────────┐            ┌────────┴──────────┐
│   Juice Shop          │            │   Kibana           │
│   Puerto 3000        │            │   Puerto 5601      │
│                      │            │                    │
│ Genera logs          │            │ - Discover         │
└──────────────────────┘            │ - Visualize       │
         │                          │ - Dashboard       │
         │ stdout/stderr            │ - Dev Tools       │
         │                          └────────────────────┘
┌────────┴──────────┐                      │
│  Docker Engine    │                      │ Queries
│  Captura logs     │                      │
└───────────────────┘                      │
         │                                  │
         │ Archivos .log                    │
         │                                  │
┌────────┴──────────┐                      │
│   Filebeat        │                      │
│   Recolecta       │                      │
│   Procesa         │                      │
│   Enriquece       │                      │
└───────────────────┘                      │
         │                                  │
         │ HTTP POST (JSON)                 │
         │                                  │
┌────────┴──────────┐                      │
│   Elasticsearch   │◀─────────────────────┘
│   Puerto 9200     │
│                   │
│ - Indexa          │
│ - Almacena        │
│ - Busca           │
│ - Agrega          │
└───────────────────┘
         │
         │
┌────────┴──────────┐
│  Volumen          │
│  Persistencia     │
└───────────────────┘
```

## ✅ Verificación

### Checklist de configuración:

- [ ] Data View "Todos los Logs" creado
- [ ] Data View "Juice Shop Logs" creado
- [ ] Discover muestra logs correctamente
- [ ] Al menos 3 visualizaciones creadas
- [ ] Dashboard creado y funcional
- [ ] Dev Tools probado con queries

### Verificar que todo funciona:

**1. Generar logs**:
```bash
for i in {1..20}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

**2. Ver en Kibana**:
- Discover → Deberías ver nuevos logs apareciendo
- Dashboard → Números deberían aumentar

**3. Probar filtros**:
- Busca: `container.name: "juice-shop"`
- Deberías ver solo logs de Juice Shop

## 🔧 Troubleshooting

### Problema: No veo logs en Discover

**Posibles causas**:
1. **Rango de tiempo incorrecto**
   - Solución: Amplía a "Last 24 hours"
2. **Data View incorrecto**
   - Solución: Verifica que seleccionaste el correcto
3. **No hay datos**
   - Solución: Verifica índices en Dev Tools
   ```
   GET /_cat/indices?v
   ```

### Problema: "No results match your search criteria"

**Solución**:
1. Elimina todos los filtros
2. Cambia rango de tiempo a "Last 7 days"
3. Verifica que el Data View incluye los índices correctos

### Problema: Visualización vacía

**Posibles causas**:
1. **Campo no existe**
   - Solución: Verifica en Discover que el campo existe
2. **Filtro muy restrictivo**
   - Solución: Elimina filtros temporalmente
3. **Datos fuera del rango de tiempo**
   - Solución: Amplía rango de tiempo

### Problema: Dashboard lento

**Soluciones**:
1. Reduce rango de tiempo
2. Usa filtros para limitar datos
3. Reduce número de visualizaciones
4. Usa índices específicos (no `*`)

## 📚 Conceptos Avanzados

### 1. **KQL vs Lucene**
- **KQL**: Más simple, recomendado
  ```
  container.name: "juice-shop"
  ```
- **Lucene**: Más potente, sintaxis compleja
  ```
  container.name:"juice-shop" AND message:/error.*/
  ```

### 2. **Aggregations**
- Operaciones sobre conjuntos de datos
- Ejemplos:
  - Count: Contar documentos
  - Average: Promedio de un campo
  - Terms: Agrupar por valores únicos
  - Date Histogram: Agrupar por tiempo

### 3. **Field Types**
- **keyword**: Texto exacto (para filtros)
- **text**: Texto analizado (para búsqueda full-text)
- **date**: Fechas
- **long**: Números enteros
- **float**: Números decimales

### 4. **Time Series**
- Datos ordenados por tiempo
- Índices diarios (`filebeat-2025.11.04`)
- Facilita:
  - Búsquedas por rango de tiempo
  - Eliminación de datos antiguos
  - Optimización de queries

## 🚀 Próximos Pasos (Opcional)

### Mejoras adicionales:

1. **Alertas**:
   - Configurar Watcher/Alerting
   - Notificaciones por email/Slack
   - Alertas por umbral de errores

2. **Machine Learning**:
   - Detección de anomalías
   - Predicción de tendencias
   - Alertas inteligentes

3. **Seguridad**:
   - Habilitar autenticación
   - Roles y permisos
   - Audit logs

4. **Optimización**:
   - ILM (Index Lifecycle Management)
   - Snapshots automáticos
   - Políticas de retención

5. **Integración**:
   - Métricas con Metricbeat
   - APM para tracing
   - Uptime monitoring

## 📊 Resumen

### ✅ **Logrado**:
- Data Views configurados
- Discover funcional para explorar logs
- Visualizaciones creadas
- Dashboard armado
- Dev Tools probado

### 📖 **Aprendido**:
- Cómo navegar Kibana
- KQL para búsquedas
- Crear visualizaciones
- Armar dashboards
- Usar Dev Tools

### 🔄 **Sistema Completo**:
```
Juice Shop → Docker → Filebeat → Elasticsearch → Kibana → Usuario
```

**El sistema ELK está 100% funcional y configurado** ✅

## 🎯 Resultado Final

Ahora tienes:
- ✅ Logs recolectándose automáticamente
- ✅ Almacenamiento centralizado en Elasticsearch
- ✅ Visualización en tiempo real en Kibana
- ✅ Dashboards para monitoreo
- ✅ Herramientas para análisis y debugging

**¡Tu sistema de logging profesional está completo!** 🎉

<p align="right">(<a href="#readme-top">Ir al inicio</a>)</p>
