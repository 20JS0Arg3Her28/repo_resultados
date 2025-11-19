# Estrategia de Ramas para Documentación del Proyecto

## 📋 Objetivo

Crear un proyecto acumulativo donde los estudiantes avancen paso a paso, moviéndose entre ramas Git para construir gradualmente el sistema ELK Stack completo, documentando cada paso con fotografías.

## 🌳 Estructura de Ramas

```
main (rama principal - proyecto completo)
│
├── paso-1-juice-shop (solo Juice Shop básico)
│   └── Archivos: Dockerfile, docker-compose.yml (solo juice-shop)
│
├── paso-2-elasticsearch (agrega Elasticsearch)
│   └── Archivos: paso-1 + elasticsearch en docker-compose.yml
│
├── paso-3-kibana (agrega Kibana)
│   └── Archivos: paso-2 + kibana en docker-compose.yml
│
├── paso-4-filebeat (completa el flujo)
│   └── Archivos: paso-3 + filebeat en docker-compose.yml + filebeat.yml
│
├── paso-5-visualizacion (configuración de Kibana)
│   └── Archivos: paso-4 + guías de configuración
│
└── paso-6-blue-team (operaciones defensivas)
    └── Archivos: paso-5 + scripts y reglas de detección
```

## 🚀 Flujo de Trabajo para Estudiantes

### Paso 1: Juice Shop Básico
```bash
git checkout paso-1-juice-shop
# Leer PASO_1_JUICE_SHOP.md
# Ejecutar comandos
# Capturar screenshots
# Documentar en su reporte
```

### Paso 2: Agregar Elasticsearch
```bash
git checkout paso-2-elasticsearch
# Leer PASO_2_ELASTICSEARCH.md
# Ejecutar comandos
# Capturar screenshots
# Documentar en su reporte
```

### Paso 3: Agregar Kibana
```bash
git checkout paso-3-kibana
# Leer PASO_3_KIBANA.md
# Ejecutar comandos
# Capturar screenshots
# Documentar en su reporte
```

### Paso 4: Agregar Filebeat
```bash
git checkout paso-4-filebeat
# Leer PASO_4_FILEBEAT.md
# Ejecutar comandos
# Capturar screenshots
# Documentar en su reporte
```

### Paso 5: Configurar Visualización
```bash
git checkout paso-5-visualizacion
# Leer PASO_5_VISUALIZACION_KIBANA.md
# Configurar Data Views
# Crear visualizaciones
# Capturar screenshots
# Documentar en su reporte
```

### Paso 6: Blue Team
```bash
git checkout paso-6-blue-team
# Leer PASO_6_BLUE_TEAM.md
# Configurar reglas de detección
# Ejecutar pruebas
# Capturar screenshots
# Documentar en su reporte
```

## 📸 Puntos de Captura de Screenshots por Paso

### Paso 1: Juice Shop
- [ ] Terminal: `docker compose ps` mostrando juice-shop corriendo
- [ ] Navegador: Interfaz de Juice Shop en http://localhost:3000
- [ ] Terminal: Output de `curl http://localhost:3000`
- [ ] Terminal: Logs con `docker compose logs juice-shop`

### Paso 2: Elasticsearch
- [ ] Terminal: `docker compose ps` mostrando elasticsearch + juice-shop
- [ ] Terminal: `curl http://localhost:9200/_cluster/health?pretty`
- [ ] Terminal: Respuesta JSON de Elasticsearch
- [ ] Terminal: `curl http://localhost:9200/_cat/indices?v`

### Paso 3: Kibana
- [ ] Terminal: `docker compose ps` mostrando todos los servicios
- [ ] Navegador: Pantalla de bienvenida de Kibana
- [ ] Navegador: Dev Tools ejecutando query GET /
- [ ] Terminal: `curl http://localhost:5601/api/status`

### Paso 4: Filebeat
- [ ] Terminal: `docker compose ps` mostrando todos los servicios incluyendo filebeat
- [ ] Terminal: Logs de Filebeat conectándose a Elasticsearch
- [ ] Terminal: `curl http://localhost:9200/_cat/indices?v` mostrando índices filebeat-*
- [ ] Terminal: Query mostrando un documento de log

### Paso 5: Visualización en Kibana
- [ ] Navegador: Creación de Data View "Todos los Logs"
- [ ] Navegador: Discover mostrando logs de Juice Shop
- [ ] Navegador: Búsqueda con KQL filtrando por contenedor
- [ ] Navegador: Creación de visualización (Pie Chart)
- [ ] Navegador: Creación de visualización (Line Chart)
- [ ] Navegador: Dashboard completo con todas las visualizaciones
- [ ] Navegador: Dev Tools ejecutando queries personalizadas

### Paso 6: Blue Team
- [ ] Navegador: Reglas de detección creadas en Kibana
- [ ] Terminal: Ejecución de ataques simulados (SQLi, XSS)
- [ ] Navegador: Alertas disparadas en Kibana
- [ ] Navegador: Dashboard de detecciones
- [ ] Terminal: Logs mostrando payloads maliciosos
- [ ] Navegador: Análisis de incidente en Discover

## 🔄 Comandos de Limpieza entre Pasos

Antes de cambiar de rama, los estudiantes deben limpiar el ambiente:

```bash
# Detener y eliminar contenedores, redes y volúmenes
docker compose down -v

# Verificar que todo está limpio
docker compose ps
docker volume ls | grep proyecto

# Cambiar a la siguiente rama
git checkout paso-X-nombre
```

## 📝 Plantilla de Reporte por Paso

Cada estudiante debe documentar:

```markdown
# Paso X: [Nombre del Paso]

## Objetivo
[Descripción de qué se logra en este paso]

## Comandos Ejecutados
```bash
[Comandos con su output]
```

## Screenshots
[Capturas de pantalla numeradas con descripción]

## Problemas Encontrados
[Descripción de errores y cómo se resolvieron]

## Verificación
- [ ] Servicio corriendo correctamente
- [ ] Puertos accesibles
- [ ] Logs sin errores
- [ ] Funcionalidad verificada

## Conceptos Aprendidos
[Lista de conceptos técnicos comprendidos]

## Tiempo Invertido
[Tiempo aproximado en este paso]
```

## 🎯 Entregables Finales

Al completar todos los pasos, los estudiantes deben entregar:

1. **Reporte completo** con todos los pasos documentados
2. **Screenshots organizados** por paso (mínimo 30 capturas)
3. **Archivo de comandos** ejecutados
4. **Análisis de logs** capturados
5. **Dashboard exportado** de Kibana
6. **Reglas de detección** configuradas
7. **Informe de incidente** simulado (Paso 6)

## ⏱️ Tiempo Estimado por Paso

| Paso | Tiempo Estimado | Dificultad |
|------|----------------|------------|
| Paso 1: Juice Shop | 30 minutos | ⭐ Fácil |
| Paso 2: Elasticsearch | 45 minutos | ⭐⭐ Media |
| Paso 3: Kibana | 45 minutos | ⭐⭐ Media |
| Paso 4: Filebeat | 1 hora | ⭐⭐⭐ Media-Alta |
| Paso 5: Visualización | 1.5 horas | ⭐⭐⭐ Media-Alta |
| Paso 6: Blue Team | 2 horas | ⭐⭐⭐⭐ Alta |
| **TOTAL** | **6-7 horas** | |

## 🆘 Soporte y Troubleshooting

Cada archivo PASO_X.md incluye una sección de troubleshooting con:
- Problemas comunes
- Soluciones paso a paso
- Comandos de diagnóstico
- Referencias adicionales

## 📚 Recursos Adicionales

- [Documentación oficial de Docker](https://docs.docker.com/)
- [Documentación de Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Documentación de Kibana](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Documentación de Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
