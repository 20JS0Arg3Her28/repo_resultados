# Plantilla de Documentación - Proyecto ELK Stack

**Nombre del Estudiante**: ___________________________  
**Carnet**: ___________________________  
**Fecha de Inicio**: ___________________________  
**Fecha de Entrega**: ___________________________  

---

## 📋 Índice

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Paso 1: Juice Shop Básico](#paso-1-juice-shop-básico)
3. [Paso 2: Elasticsearch](#paso-2-elasticsearch)
4. [Paso 3: Kibana](#paso-3-kibana)
5. [Paso 4: Filebeat](#paso-4-filebeat)
6. [Paso 5: Visualización en Kibana](#paso-5-visualización-en-kibana)
7. [Paso 6: Blue Team](#paso-6-blue-team)
8. [Actividades Red Team](#actividades-red-team)
9. [Análisis Técnico](#análisis-técnico)
10. [Problemas y Soluciones](#problemas-y-soluciones)
11. [Conceptos Aprendidos](#conceptos-aprendidos)
12. [Conclusiones](#conclusiones)
13. [Referencias](#referencias)
14. [Anexos](#anexos)

---

## Resumen Ejecutivo

### Descripción del Proyecto
Este proyecto implementa un sistema completo de monitoreo y detección de amenazas utilizando el stack ELK (Elasticsearch, Logstash, Kibana) junto con OWASP Juice Shop como aplicación vulnerable para pruebas de seguridad. El sistema captura logs HTTP en tiempo real a través de un proxy Nginx, los procesa con Filebeat, los almacena en Elasticsearch y los visualiza en Kibana.

El objetivo principal es poder simular ataques (Red Team) y detectarlos mediante reglas automatizadas (Blue Team), permitiendo el análisis forense de tráfico malicioso incluyendo SQL Injection, Cross-Site Scripting (XSS) y scanning de directorios.

La arquitectura implementada captura cada request HTTP con su payload completo, incluyendo parámetros de query string donde típicamente se inyectan ataques, permitiendo la detección, análisis y respuesta a incidentes de seguridad en tiempo real.



### Objetivos Cumplidos
- [x] Sistema ELK Stack completamente funcional
- [x] Logs recolectándose en tiempo real
- [ ] Visualizaciones y dashboards creados
- [ ] Reglas de detección configuradas
- [ ] Vulnerabilidades identificadas y documentadas

### Tecnologías Utilizadas
- Docker y Docker Compose
- OWASP Juice Shop
- Elasticsearch 8.11.0
- Kibana 8.11.0
- Filebeat 8.11.0
- [Otras herramientas utilizadas]

### Tiempo Invertido
| Fase | Tiempo Estimado | Tiempo Real |
|------|----------------|-------------|
| Paso 1: Juice Shop | 30 min | 10 min |
| Paso 2: Elasticsearch | 45 min | 20 min |
| Paso 3: Kibana | 45 min | ___ min |
| Paso 4: Filebeat | 1 hora | ___ min |
| Paso 5: Visualización | 1.5 horas | ___ min |
| Paso 6: Blue Team | 2 horas | ___ min |
| Red Team | 3 horas | ___ min |
| Documentación | 2 horas | ___ min |
| **TOTAL** | **~11 horas** | **___ horas** |

---

## Paso 1: Juice Shop Básico

### Objetivo
Configurar y ejecutar OWASP Juice Shop como aplicación base que generará logs para el sistema de monitoreo.

### Rama Git Utilizada
```bash
git checkout paso-1-juice-shop
```

### Comandos Ejecutados

#### 1.1 Levantar el servicio
```bash
docker compose up -d
```

**Output**:
```
[Pegar el output del comando aquí]
```

#### 1.2 Verificar estado
```bash
docker compose ps
```

**Output**:
```
[Pegar el output del comando aquí]
```

#### 1.3 Probar conectividad
```bash
curl -I http://localhost:3000
```

**Output**:
```
[Pegar el output del comando aquí]
```

#### 1.4 Generar logs de prueba
```bash
for i in {1..10}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i completada"
  sleep 1
done
```

**Output**:
```
[Pegar el output del comando aquí]
```

### Screenshots

#### Screenshot 1.1: Docker Compose PS
![Docker Compose PS](./screenshots/paso-1/01-docker-compose-ps.png)

**Descripción**: Muestra el contenedor juice-shop corriendo en estado "Up" con el puerto 3000 mapeado.

**Verificación**:
- [x] Contenedor en estado "Up"
- [x] Puerto 3000:3000 mapeado
- [x] Sin errores visibles

#### Screenshot 1.2: Interfaz Web de Juice Shop
![Interfaz Juice Shop](./screenshots/paso-1/02-interfaz-web.png)

**Descripción**: Página principal de Juice Shop cargada correctamente en el navegador.

**Verificación**:
- [x] Página carga sin errores
- [x] Productos visibles
- [x] URL correcta (localhost:3000)

#### Screenshot 1.3: Curl Test
![Curl Test](./screenshots/paso-1/03-curl-test.png)

**Descripción**: Respuesta HTTP del servidor mostrando código 200 OK.

#### Screenshot 1.4: Logs del Contenedor
![Logs](./screenshots/paso-1/04-logs.png)

**Descripción**: Logs mostrando el mensaje "Server listening on port 3000" y requests HTTP.

### Problemas Encontrados

#### Problema 1: [Descripción del problema]
**Error**: 
```
[Mensaje de error exacto]
```

**Causa**: [Explicación de por qué ocurrió]

**Solución**: 
```bash
[Comandos para resolver]
```

**Resultado**: [Qué pasó después de aplicar la solución]

### Verificación de Éxito

- [x] Contenedor corriendo sin errores
- [x] Puerto 3000 accesible
- [x] Interfaz web funcional
- [x] Logs generándose correctamente
- [x] Screenshots capturados (4)

### Conceptos Aprendidos

1. **Docker Compose**: [Explicación de qué aprendiste]
2. **Port Mapping**: [Explicación]
3. **Container Logs**: [Explicación]

### Tiempo Invertido
- **Estimado**: 30 minutos
- **Real**: ___ minutos

---

## Paso 2: Elasticsearch

### Objetivo
Implementar Elasticsearch como motor de almacenamiento y búsqueda de logs.

### Rama Git Utilizada
```bash
git checkout paso-2-elasticsearch
```

### Cambios Respecto al Paso Anterior
```bash
git diff paso-1-juice-shop paso-2-elasticsearch
```

**Resumen de cambios**:
- Agregado servicio elasticsearch en docker-compose.yml
- Configuración de red elk-network
- Volumen persistente elasticsearch-data
- Healthcheck configurado

### Comandos Ejecutados

#### 2.1 Levantar servicios
```bash
docker compose up -d
```

**Output**:
```
[Pegar output]
```

#### 2.2 Verificar salud del cluster
```bash
curl http://localhost:9200/_cluster/health?pretty
```

**Output**:
```json
[Pegar JSON de respuesta]
```

#### 2.3 Crear documento de prueba
```bash
curl -X POST "http://localhost:9200/test-index/_doc" \
  -H 'Content-Type: application/json' \
  -d '{
    "message": "Test log entry",
    "timestamp": "2025-11-04T10:00:00Z"
  }'
```

**Output**:
```json
[Pegar respuesta]
```

#### 2.4 Verificar índices
```bash
curl "http://localhost:9200/_cat/indices?v"
```

**Output**:
```
[Pegar output]
```

### Screenshots

#### Screenshot 2.1: Servicios Corriendo
![Servicios](./screenshots/paso-2/01-servicios.png)

**Descripción**: Docker compose ps mostrando juice-shop y elasticsearch corriendo.

#### Screenshot 2.2: Cluster Health
![Cluster Health](./screenshots/paso-2/02-cluster-health.png)

**Descripción**: JSON mostrando estado "green" del cluster.

#### Screenshot 2.3: Documento Creado
![Documento](./screenshots/paso-2/03-documento-creado.png)

**Descripción**: Respuesta exitosa de creación de documento.

#### Screenshot 2.4: Índices
![Índices](./screenshots/paso-2/04-indices.png)

**Descripción**: Lista de índices mostrando test-index creado.

#### Screenshot 2.5: [Agregar más según necesites]

### Problemas Encontrados

[Documentar problemas encontrados]

### Verificación de Éxito

- [x] Elasticsearch corriendo y healthy
- [x] Cluster en estado GREEN/YELLOW
- [x] Puerto 9200 respondiendo
- [x] Puede crear documentos
- [x] Puede buscar documentos
- [x] Screenshots capturados (5)

### Conceptos Aprendidos

1. **Elasticsearch**: [Explicación]
2. **Índices y Documentos**: [Explicación]
3. **RESTful API**: [Explicación]
4. **Cluster Health**: [Explicación]

### Tiempo Invertido
- **Estimado**: 45 minutos
- **Real**: ___ minutos

---

## Paso 3: Kibana

### Objetivo
Implementar Kibana como interfaz visual para explorar datos en Elasticsearch.

### Rama Git Utilizada
```bash
git checkout paso-3-kibana
```

### Comandos Ejecutados

[Seguir el mismo formato que los pasos anteriores]

### Screenshots

[Mínimo 4 screenshots]

### Problemas Encontrados

[Documentar]

### Verificación de Éxito

- [ ] Kibana corriendo y healthy
- [ ] Puerto 5601 accesible
- [ ] Interfaz web funcional
- [ ] Conectado a Elasticsearch
- [ ] Dev Tools funcional
- [ ] Screenshots capturados (4)

### Conceptos Aprendidos

[Listar conceptos]

### Tiempo Invertido
- **Estimado**: 45 minutos
- **Real**: ___ minutos

---

## Paso 4: Filebeat

### Objetivo
Implementar Filebeat para recolectar logs de Docker y enviarlos a Elasticsearch.

### Rama Git Utilizada
```bash
git checkout paso-4-filebeat
```

### Comandos Ejecutados

[Documentar todos los comandos]

### Screenshots

[Mínimo 5 screenshots]

### Problemas Encontrados

[Documentar]

### Verificación de Éxito

- [ ] Filebeat corriendo sin errores
- [ ] Conectado a Elasticsearch
- [ ] Leyendo logs de Docker
- [ ] Índices filebeat-* creados
- [ ] Documentos con metadata completa
- [ ] Screenshots capturados (5)

### Conceptos Aprendidos

[Listar conceptos]

### Tiempo Invertido
- **Estimado**: 1 hora
- **Real**: ___ minutos

---

## Paso 5: Visualización en Kibana

### Objetivo
Configurar Data Views, crear visualizaciones y armar dashboards en Kibana.

### Rama Git Utilizada
```bash
git checkout paso-5-visualizacion
```

### Configuraciones Realizadas

#### 5.1 Data Views Creados

**Data View 1: Todos los Logs**
- **Name**: Todos los Logs
- **Index pattern**: filebeat-*
- **Timestamp field**: @timestamp
- **Número de campos**: [número]

**Data View 2: Juice Shop Logs**
- **Name**: Juice Shop Logs
- **Index pattern**: filebeat-juice-shop-*
- **Timestamp field**: @timestamp
- **Número de campos**: [número]

#### 5.2 Visualizaciones Creadas

**Visualización 1: Distribución de Logs por Contenedor**
- **Tipo**: Pie Chart
- **Data view**: Todos los Logs
- **Campo**: container.name.keyword
- **Métrica**: Count

**Visualización 2: Volumen de Logs en el Tiempo**
- **Tipo**: Line Chart
- **Data view**: Todos los Logs
- **Eje X**: @timestamp
- **Eje Y**: Count
- **Break down by**: container.name.keyword

**Visualización 3: Top 10 Mensajes**
- **Tipo**: Table
- **Data view**: Juice Shop Logs
- **Rows**: message.keyword (Top 10)
- **Métrica**: Count

**Visualización 4: Total de Logs**
- **Tipo**: Metric
- **Data view**: Todos los Logs
- **Métrica**: Count

#### 5.3 Dashboard Creado

**Nombre**: Overview de Logs del Sistema

**Visualizaciones incluidas**:
1. Total de Logs (Metric)
2. Distribución por Contenedor (Pie)
3. Volumen en el Tiempo (Line)
4. Top 10 Mensajes (Table)

**Layout**: [Describir organización]

### Búsquedas KQL Utilizadas

```kql
# Búsqueda 1: Solo logs de Juice Shop
container.name: "juice-shop"

# Búsqueda 2: Logs con errores
message: *error* OR message: *ERROR*

# Búsqueda 3: Logs de las últimas 15 minutos
@timestamp >= now-15m
```

### Queries Avanzadas en Dev Tools

```json
// Query 1: Agregación por contenedor
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

// Query 2: Búsqueda con filtro
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

### Screenshots

#### Screenshot 5.1: Creación de Data View
![Data View](./screenshots/paso-5/01-data-view.png)

#### Screenshot 5.2: Discover con Logs
![Discover](./screenshots/paso-5/02-discover.png)

#### Screenshot 5.3: Búsqueda KQL
![KQL](./screenshots/paso-5/03-kql-search.png)

#### Screenshot 5.4: Log Expandido
![Log Detail](./screenshots/paso-5/04-log-detail.png)

#### Screenshot 5.5: Visualización Pie Chart
![Pie Chart](./screenshots/paso-5/05-pie-chart.png)

#### Screenshot 5.6: Visualización Line Chart
![Line Chart](./screenshots/paso-5/06-line-chart.png)

#### Screenshot 5.7: Visualización Table
![Table](./screenshots/paso-5/07-table.png)

#### Screenshot 5.8: Visualización Metric
![Metric](./screenshots/paso-5/08-metric.png)

#### Screenshot 5.9: Visualize Library
![Library](./screenshots/paso-5/09-library.png)

#### Screenshot 5.10: Dashboard Completo
![Dashboard](./screenshots/paso-5/10-dashboard.png)

#### Screenshot 5.11: Dev Tools Query
![Dev Tools](./screenshots/paso-5/11-dev-tools.png)

#### Screenshot 5.12: Dashboard Interactivo
![Interactive](./screenshots/paso-5/12-interactive.png)

### Problemas Encontrados

[Documentar]

### Verificación de Éxito

- [ ] 2 Data Views creados
- [ ] Discover funcional
- [ ] Búsquedas KQL funcionando
- [ ] Mínimo 4 visualizaciones creadas
- [ ] Dashboard creado y funcional
- [ ] Dev Tools con queries avanzadas
- [ ] Screenshots capturados (12)

### Conceptos Aprendidos

[Listar conceptos]

### Tiempo Invertido
- **Estimado**: 1.5 horas
- **Real**: ___ minutos

---

## Paso 6: Blue Team

### Objetivo
Implementar operaciones defensivas: detección de amenazas, reglas de seguridad y respuesta a incidentes.

### Rama Git Utilizada
```bash
git checkout paso-6-blue-team
```

### Actividades Realizadas

#### 6.1 Script de Tráfico Legítimo

**Archivo**: `scripts/blue-team-traffic.sh`

```bash
[Pegar contenido del script]
```

**Ejecución**:
```bash
./scripts/blue-team-traffic.sh
```

**Output**:
```
[Pegar output]
```

#### 6.2 Configuración de Reglas de Detección

**Regla 1: Detección de SQL Injection**

- **Nombre**: Detección SQL Injection
- **Tipo**: Custom query
- **Query KQL**:
```kql
url.original:("*' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or
message:("*' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*")
```
- **Severidad**: High
- **Risk score**: 75
- **Intervalo**: 5 minutos
- **Lookback**: 15 minutos

**Regla 2: Detección de XSS**

- **Nombre**: Detección Cross-Site Scripting (XSS)
- **Tipo**: Threshold
- **Query KQL**:
```kql
url.original:*"<script*" or url.original:*"onerror="* or message:*"<script*"
```
- **Threshold**: >= 1
- **Group by**: source.ip
- **Severidad**: High
- **Risk score**: 70

**Regla 3: Detección de Scanning/Burst**

- **Nombre**: Detección de Scanning/Burst
- **Tipo**: Threshold
- **Query KQL**:
```kql
http.response.status_code: (400 or 401 or 403 or 404 or 500 or 503)
```
- **Threshold**: >= 20
- **Group by**: source.ip
- **Time window**: 2 minutos
- **Severidad**: Medium
- **Risk score**: 50

#### 6.3 Pruebas de Detección

**Prueba 1: SQL Injection**
```bash
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"
```

**Resultado**: [Describir si se detectó]

**Prueba 2: XSS**
```bash
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>"
```

**Resultado**: [Describir si se detectó]

**Prueba 3: Scanning**
```bash
for i in {1..30}; do 
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:3000/non-existent-$i"
  sleep 0.5
done
```

**Resultado**: [Describir si se detectó]

#### 6.4 Dashboard de Detecciones

**Nombre**: Blue Team - Detecciones de Seguridad

**Visualizaciones incluidas**:
1. Total de Detecciones (Metric)
2. Detecciones por Tipo (Pie Chart)
3. Timeline de Detecciones (Line Chart)
4. Top IPs Atacantes (Table)
5. Detecciones por Severidad (Bar Chart)

#### 6.5 Análisis de Incidentes

**Incidente 1: SQL Injection Detectado**

- **Fecha/Hora**: [timestamp]
- **IP Origen**: [IP]
- **Endpoint Atacado**: /rest/products/search
- **Payload**: `' OR 1=1 --`
- **Regla Disparada**: Detección SQL Injection
- **Severidad**: High

**Análisis**:
[Descripción del ataque, qué intentaba hacer, qué datos estaban en riesgo]

**Acciones Tomadas**:
1. [Acción 1]
2. [Acción 2]

**Resultado**:
[Qué pasó después de las acciones]

**Incidente 2: XSS Detectado**

[Seguir mismo formato]

**Incidente 3: Scanning Detectado**

[Seguir mismo formato]

#### 6.6 Falsas Alarmas y Limitaciones

**Falsa Alarma 1**: [Descripción]
- **Causa**: [Por qué se disparó]
- **Solución**: [Cómo se ajustó la regla]

**Limitación 1**: [Descripción]
- **Impacto**: [Qué no se puede detectar]
- **Mitigación**: [Cómo se podría mejorar]

#### 6.7 Instrumentación Adicional

**CORS Configuration**: [Si se configuró, documentar]

**Nginx Proxy**: [Si se agregó, documentar configuración]

**Filebeat Processors**: [Documentar processors personalizados]

**Ingest Pipelines**: [Si se crearon, documentar]

### Screenshots

#### Screenshot 6.1: Script de Tráfico
![Script](./screenshots/paso-6/01-script-trafico.png)

#### Screenshot 6.2: Reglas de Detección
![Reglas](./screenshots/paso-6/02-reglas-deteccion.png)

#### Screenshot 6.3: Regla SQLi Detalle
![SQLi Rule](./screenshots/paso-6/03-regla-sqli.png)

#### Screenshot 6.4: Regla XSS Detalle
![XSS Rule](./screenshots/paso-6/04-regla-xss.png)

#### Screenshot 6.5: Regla Burst Detalle
![Burst Rule](./screenshots/paso-6/05-regla-burst.png)

#### Screenshot 6.6: Ataque SQLi Simulado
![SQLi Attack](./screenshots/paso-6/06-ataque-sqli.png)

#### Screenshot 6.7: Ataque XSS Simulado
![XSS Attack](./screenshots/paso-6/07-ataque-xss.png)

#### Screenshot 6.8: Scanning Simulado
![Scanning](./screenshots/paso-6/08-scanning.png)

#### Screenshot 6.9: Alertas Generadas
![Alerts](./screenshots/paso-6/09-alertas.png)

#### Screenshot 6.10: Detalle de Alerta
![Alert Detail](./screenshots/paso-6/10-detalle-alerta.png)

#### Screenshot 6.11: Dashboard de Detecciones
![Dashboard](./screenshots/paso-6/11-dashboard-detecciones.png)

#### Screenshot 6.12: Logs Maliciosos en Discover
![Malicious Logs](./screenshots/paso-6/12-logs-maliciosos.png)

### Informe de Respuesta

#### Resumen de Detecciones

| Tipo de Ataque | Cantidad | Severidad | IPs Únicas | Mitigado |
|----------------|----------|-----------|------------|----------|
| SQL Injection | [#] | High | [#] | [Sí/No] |
| XSS | [#] | High | [#] | [Sí/No] |
| Scanning | [#] | Medium | [#] | [Sí/No] |

#### Acciones Defensivas Implementadas

1. **Bloqueo de IPs**: [Describir]
2. **Aumento de Logging**: [Describir]
3. **Alertas Configuradas**: [Describir]
4. **WAF Rules**: [Si aplica]

#### Lecciones Aprendidas

1. [Lección 1]
2. [Lección 2]
3. [Lección 3]

### Verificación de Éxito

- [ ] Script de tráfico legítimo creado
- [ ] 3 reglas de detección configuradas
- [ ] Ataques simulados ejecutados
- [ ] Alertas generadas correctamente
- [ ] Dashboard de detecciones creado
- [ ] Logs maliciosos identificados
- [ ] Informe de respuesta completado
- [ ] Screenshots capturados (12)

### Conceptos Aprendidos

[Listar conceptos]

### Tiempo Invertido
- **Estimado**: 2 horas
- **Real**: ___ minutos

---

## Actividades Red Team

### Objetivo
Identificar y explotar vulnerabilidades en Juice Shop para generar tráfico malicioso que el Blue Team pueda detectar.

### Vulnerabilidades Explotadas

#### Vulnerabilidad 1: SQL Injection en Login

**Descripción Técnica**:
[Explicar qué es SQL Injection y cómo funciona]

**Endpoint Vulnerable**: `/rest/user/login`

**Pasos para Reproducir**:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Payload Utilizado**:
```bash
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'\'' OR 1=1--",
    "password": "anything"
  }'
```

**Response Obtenida**:
```json
[Pegar respuesta]
```

**Impacto**:
- **Confidencialidad**: 🔴 CRÍTICO - [Explicar]
- **Integridad**: 🔴 CRÍTICO - [Explicar]
- **Disponibilidad**: 🟡 MEDIO - [Explicar]

**Clasificación**:
- **OWASP Top 10**: A03:2021 - Injection
- **CVSS v3.1**: 9.8 (Critical)
- **Vector**: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H

**Cálculo CVSS**:
- **AV:N** - [Explicar por qué]
- **AC:L** - [Explicar por qué]
- **PR:N** - [Explicar por qué]
- **UI:N** - [Explicar por qué]
- **C:H** - [Explicar por qué]
- **I:H** - [Explicar por qué]
- **A:H** - [Explicar por qué]

**Screenshots**:
![SQLi BurpSuite](./screenshots/red-team/sqli-01-burpsuite.png)
![SQLi Response](./screenshots/red-team/sqli-02-response.png)
![SQLi Token](./screenshots/red-team/sqli-03-token.png)

**Logs Capturados**:
```
[Extracto de logs de Elasticsearch mostrando el ataque]
```

#### Vulnerabilidad 2: Cross-Site Scripting (XSS)

[Seguir el mismo formato detallado]

#### Vulnerabilidad 3: Broken Authentication

[Seguir el mismo formato detallado]

#### Vulnerabilidad 4: Broken Access Control

[Seguir el mismo formato detallado]

### Coordinación con Blue Team

**Fecha de Ataques**: [Fecha y hora]
**Duración**: [Duración]
**IPs Utilizadas**: [Lista de IPs]
**Endpoints Atacados**: [Lista de endpoints]

**Resultados de Detección**:
| Ataque | Detectado por Blue Team | Tiempo de Detección |
|--------|-------------------------|---------------------|
| SQL Injection | [Sí/No] | [Tiempo] |
| XSS | [Sí/No] | [Tiempo] |
| Auth Bypass | [Sí/No] | [Tiempo] |
| Access Control | [Sí/No] | [Tiempo] |

### Verificación de Éxito

- [ ] Mínimo 4 vulnerabilidades explotadas
- [ ] Cada vulnerabilidad con PoC completo
- [ ] CVSS calculado para cada una
- [ ] OWASP Top 10 clasificación
- [ ] Screenshots de evidencia (mínimo 3 por vulnerabilidad)
- [ ] Logs capturados
- [ ] Impacto documentado

---

## Análisis Técnico

### Arquitectura Completa del Sistema

```
[Dibujar o pegar diagrama de arquitectura]
```

**Componentes**:
1. **Juice Shop**: [Explicar rol]
2. **Docker Engine**: [Explicar rol]
3. **Filebeat**: [Explicar rol]
4. **Elasticsearch**: [Explicar rol]
5. **Kibana**: [Explicar rol]

### Flujo de Datos Detallado

```
Usuario → Juice Shop → Docker Logs → Filebeat → Elasticsearch → Kibana → Analista
```

**Paso a paso**:
1. [Explicar paso 1]
2. [Explicar paso 2]
3. [Explicar paso 3]
...

### Decisiones de Diseño

#### Decisión 1: [Título]
**Contexto**: [Por qué se necesitaba tomar una decisión]
**Opciones Consideradas**: [Opción A, B, C]
**Decisión Tomada**: [Cuál se eligió]
**Justificación**: [Por qué se eligió]
**Resultado**: [Cómo funcionó]

#### Decisión 2: [Título]
[Seguir mismo formato]

---

## Problemas y Soluciones

### Problema 1: [Título del Problema]

**Paso en el que ocurrió**: Paso [número]

**Descripción del Problema**:
[Descripción detallada]

**Error Exacto**:
```
[Mensaje de error completo]
```

**Causa Raíz**:
[Explicar por qué ocurrió]

**Intentos de Solución**:
1. **Intento 1**: [Qué se intentó] - Resultado: [Funcionó/No funcionó]
2. **Intento 2**: [Qué se intentó] - Resultado: [Funcionó/No funcionó]

**Solución Final**:
```bash
[Comandos o pasos que resolvieron el problema]
```

**Verificación**:
[Cómo se verificó que el problema se resolvió]

**Lección Aprendida**:
[Qué se aprendió de este problema]

### Problema 2: [Título]
[Seguir mismo formato]

### Problema 3: [Título]
[Seguir mismo formato]

---

## Conceptos Aprendidos

### 1. Docker y Contenedores

**¿Qué es Docker?**
[Explicación en tus propias palabras]

**¿Por qué es útil?**
[Explicación]

**Conceptos clave aprendidos**:
- Contenedores vs Imágenes
- Port mapping
- Volúmenes
- Redes
- Docker Compose

### 2. Elasticsearch

**¿Qué es Elasticsearch?**
[Explicación]

**¿Cómo funciona?**
[Explicación]

**Conceptos clave aprendidos**:
- Índices y documentos
- Queries y búsquedas
- Agregaciones
- RESTful API
- Cluster health

### 3. Kibana

**¿Qué es Kibana?**
[Explicación]

**Conceptos clave aprendidos**:
- Data Views
- Discover
- Visualizaciones
- Dashboards
- KQL (Kibana Query Language)

### 4. Filebeat

**¿Qué es Filebeat?**
[Explicación]

**Conceptos clave aprendidos**:
- Log shipping
- Processors
- Metadata enrichment
- Registry
- Inputs y outputs

### 5. Seguridad

**Conceptos de Blue Team aprendidos**:
- Detección de amenazas
- Reglas de seguridad
- Análisis de logs
- Respuesta a incidentes
- SIEM (Security Information and Event Management)

**Conceptos de Red Team aprendidos**:
- SQL Injection
- Cross-Site Scripting (XSS)
- Broken Authentication
- Broken Access Control
- OWASP Top 10
- CVSS scoring

### 6. Otros Conceptos

[Listar otros conceptos aprendidos]

---

## Conclusiones

### Logros Principales

1. [Logro 1]
2. [Logro 2]
3. [Logro 3]

### Reflexión Personal

[Escribe 2-3 párrafos sobre tu experiencia con el proyecto:
- ¿Qué fue lo más desafiante?
- ¿Qué fue lo más interesante?
- ¿Cómo te ayudará esto en tu carrera?
- ¿Qué harías diferente la próxima vez?]

### Aplicaciones Prácticas

**En el mundo real, este sistema se podría usar para**:
1. [Aplicación 1]
2. [Aplicación 2]
3. [Aplicación 3]

### Mejoras Futuras

**Si tuviera más tiempo, agregaría**:
1. [Mejora 1]
2. [Mejora 2]
3. [Mejora 3]

### Habilidades Desarrolladas

- [ ] Administración de contenedores Docker
- [ ] Configuración de sistemas de logging
- [ ] Análisis de logs de seguridad
- [ ] Creación de visualizaciones de datos
- [ ] Detección de amenazas
- [ ] Explotación de vulnerabilidades (ético)
- [ ] Documentación técnica
- [ ] Troubleshooting y resolución de problemas

---

## Referencias

### Documentación Oficial
1. [Docker Documentation](https://docs.docker.com/)
2. [Elasticsearch Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
3. [Kibana Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
4. [Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
5. [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)

### Recursos de Seguridad
1. [OWASP Top 10 2021](https://owasp.org/Top10/)
2. [CVSS Calculator v3.1](https://www.first.org/cvss/calculator/3.1)
3. [SQL Injection Cheat Sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)
4. [XSS Filter Evasion](https://owasp.org/www-community/xss-filter-evasion-cheatsheet)

### Tutoriales y Guías
[Listar otros recursos que usaste]

---

## Anexos

### Anexo A: Comandos Completos Ejecutados

```bash
# Paso 1: Juice Shop
git checkout paso-1-juice-shop
docker compose up -d
docker compose ps
curl http://localhost:3000
# ... [todos los comandos]

# Paso 2: Elasticsearch
git checkout paso-2-elasticsearch
# ... [todos los comandos]

# [Continuar para todos los pasos]
```

### Anexo B: Archivos de Configuración

#### docker-compose.yml Final
```yaml
[Pegar contenido completo]
```

#### filebeat.yml
```yaml
[Pegar contenido completo]
```

#### Scripts Creados
```bash
# blue-team-traffic.sh
[Pegar contenido]

# red-team-attacks.sh
[Pegar contenido]
```

### Anexo C: Reglas de Detección (JSON)

```json
[Pegar export de reglas de Kibana]
```

### Anexo D: Dashboard Export

```json
[Pegar export del dashboard de Kibana]
```

### Anexo E: Logs de Ejemplo

```json
// Log de SQL Injection
{
  "@timestamp": "2025-11-04T10:30:00Z",
  "message": "GET /rest/products/search?q=' OR 1=1-- 200",
  "container": {
    "name": "juice-shop"
  },
  "threat": {
    "indicator": {
      "type": "sql-injection"
    }
  }
}

// [Más ejemplos de logs]
```

### Anexo F: Screenshots Adicionales

[Cualquier screenshot adicional que no encaje en las secciones anteriores]

---

**Fin del Reporte**

**Fecha de Entrega**: ___________________________  
**Firma**: ___________________________

---

## 📊 Estadísticas del Proyecto

- **Total de Screenshots**: ___ (mínimo 42)
- **Total de Comandos Ejecutados**: ___
- **Total de Vulnerabilidades Explotadas**: ___ (mínimo 4)
- **Total de Reglas de Detección**: ___ (mínimo 3)
- **Total de Visualizaciones Creadas**: ___ (mínimo 4)
- **Total de Dashboards Creados**: ___ (mínimo 2)
- **Páginas del Reporte**: ___
- **Tiempo Total Invertido**: ___ horas

---

## ✅ Checklist Final de Entrega

### Documentación
- [ ] Reporte completo en PDF/Markdown
- [ ] Todos los pasos documentados
- [ ] Screenshots de calidad y legibles
- [ ] Comandos con outputs
- [ ] Problemas y soluciones explicados

### Evidencia
- [ ] Carpeta screenshots/ organizada
- [ ] Mínimo 42 screenshots totales
- [ ] Logs capturados
- [ ] Comandos en archivo .txt

### Red Team
- [ ] Mínimo 4 vulnerabilidades explotadas
- [ ] Cada una con PoC completo
- [ ] CVSS calculado
- [ ] OWASP Top 10 clasificación
- [ ] Screenshots de BurpSuite/ZAP

### Blue Team
- [ ] 3 reglas de detección configuradas
- [ ] Alertas funcionando
- [ ] Dashboard de detecciones
- [ ] Informe de respuesta
- [ ] Reglas exportadas (JSON)

### Análisis
- [ ] Arquitectura documentada
- [ ] Flujo de datos explicado
- [ ] Conceptos aprendidos listados
- [ ] Reflexión personal incluida

### Formato
- [ ] Índice completo
- [ ] Numeración de páginas
- [ ] Referencias citadas
- [ ] Ortografía y gramática revisadas
- [ ] Formato profesional

---

**¡Buena suerte con tu proyecto!** 🚀✨
