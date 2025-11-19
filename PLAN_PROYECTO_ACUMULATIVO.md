# Plan del Proyecto Acumulativo - Sistema ELK Stack

## 🎯 Visión General

Este proyecto está diseñado como un **proyecto acumulativo** donde los estudiantes avanzan paso a paso, construyendo gradualmente un sistema completo de logging con ELK Stack. Cada paso se implementa en una rama Git separada, permitiendo a los estudiantes:

1. **Entender cada componente individualmente**
2. **Ver la evolución del sistema**
3. **Documentar con screenshots en cada etapa**
4. **Resolver problemas de forma incremental**
5. **Tener puntos de control claros**

## 📚 Documentos del Proyecto

### Documentos de Guía
1. **ESTRATEGIA_RAMAS.md** - Estructura de ramas y flujo de trabajo
2. **GUIA_DOCUMENTACION.md** - Cómo capturar screenshots profesionales
3. **PLAN_PRUEBAS.md** - Checklist de verificación por cada paso
4. **PLAN_PROYECTO_ACUMULATIVO.md** (este documento) - Visión general

### Documentos Técnicos por Paso
1. **PASO_1_JUICE_SHOP.md** - Configuración de Juice Shop
2. **PASO_2_ELASTICSEARCH.md** - Implementación de Elasticsearch
3. **PASO_3_KIBANA.md** - Configuración de Kibana
4. **PASO_4_FILEBEAT.md** - Integración con Filebeat
5. **PASO_5_VISUALIZACION_KIBANA.md** - Configuración de visualizaciones
6. **PASO_6_BLUE_TEAM.md** - Operaciones defensivas

## 🌳 Estructura de Ramas Git

```
main (proyecto completo)
│
├── paso-1-juice-shop
│   ├── Dockerfile
│   ├── docker-compose.yml (solo juice-shop)
│   └── PASO_1_JUICE_SHOP.md
│
├── paso-2-elasticsearch
│   ├── Dockerfile
│   ├── docker-compose.yml (juice-shop + elasticsearch)
│   ├── PASO_1_JUICE_SHOP.md
│   └── PASO_2_ELASTICSEARCH.md
│
├── paso-3-kibana
│   ├── Dockerfile
│   ├── docker-compose.yml (+ kibana)
│   ├── PASO_1_JUICE_SHOP.md
│   ├── PASO_2_ELASTICSEARCH.md
│   └── PASO_3_KIBANA.md
│
├── paso-4-filebeat
│   ├── Dockerfile
│   ├── docker-compose.yml (+ filebeat)
│   ├── filebeat.yml
│   ├── PASO_1_JUICE_SHOP.md
│   ├── PASO_2_ELASTICSEARCH.md
│   ├── PASO_3_KIBANA.md
│   └── PASO_4_FILEBEAT.md
│
├── paso-5-visualizacion
│   ├── (todos los archivos anteriores)
│   └── PASO_5_VISUALIZACION_KIBANA.md
│
└── paso-6-blue-team
    ├── (todos los archivos anteriores)
    ├── scripts/blue-team-traffic.sh
    └── PASO_6_BLUE_TEAM.md
```

## 🚀 Flujo de Trabajo para Estudiantes

### Inicio del Proyecto

```bash
# Clonar el repositorio
git clone <url-del-repositorio>
cd proyecto_2

# Ver todas las ramas disponibles
git branch -a

# Leer la documentación general
cat ESTRATEGIA_RAMAS.md
cat GUIA_DOCUMENTACION.md
cat PLAN_PRUEBAS.md
```

### Paso 1: Juice Shop Básico

```bash
# Cambiar a la rama del paso 1
git checkout paso-1-juice-shop

# Leer la documentación
cat PASO_1_JUICE_SHOP.md

# Ejecutar comandos del PLAN_PRUEBAS.md
docker compose up -d
docker compose ps

# Capturar screenshots según GUIA_DOCUMENTACION.md
# Documentar en tu reporte

# Verificar éxito antes de continuar
# Usar checklist del PLAN_PRUEBAS.md

# Limpiar antes de pasar al siguiente paso
docker compose down -v
```

### Paso 2: Agregar Elasticsearch

```bash
# Cambiar a la rama del paso 2
git checkout paso-2-elasticsearch

# Ver qué cambió
git diff paso-1-juice-shop paso-2-elasticsearch

# Leer la documentación
cat PASO_2_ELASTICSEARCH.md

# Ejecutar comandos
docker compose up -d
# ... seguir PLAN_PRUEBAS.md

# Capturar screenshots
# Documentar en tu reporte

# Limpiar antes de continuar
docker compose down -v
```

### Paso 3: Agregar Kibana

```bash
git checkout paso-3-kibana
git diff paso-2-elasticsearch paso-3-kibana
cat PASO_3_KIBANA.md
# ... seguir el proceso
```

### Paso 4: Agregar Filebeat

```bash
git checkout paso-4-filebeat
git diff paso-3-kibana paso-4-filebeat
cat PASO_4_FILEBEAT.md
# ... seguir el proceso
```

### Paso 5: Configurar Visualización

```bash
git checkout paso-5-visualizacion
cat PASO_5_VISUALIZACION_KIBANA.md
# ... seguir el proceso
# NO hacer docker compose down -v (mantener datos)
```

### Paso 6: Blue Team

```bash
git checkout paso-6-blue-team
cat PASO_6_BLUE_TEAM.md
# ... seguir el proceso
```

## 📸 Estrategia de Documentación

### Por Cada Paso

1. **Antes de empezar**
   - Leer documentación del paso
   - Entender qué se va a lograr
   - Preparar herramientas de captura

2. **Durante la ejecución**
   - Ejecutar comandos uno por uno
   - Capturar screenshot de cada comando importante
   - Documentar errores si los hay
   - Anotar observaciones

3. **Después de completar**
   - Verificar con checklist del PLAN_PRUEBAS.md
   - Organizar screenshots
   - Redactar sección del reporte
   - Confirmar éxito antes de continuar

### Organización de Screenshots

```
mi-proyecto-elk/
├── documentacion/
│   ├── reporte-final.md
│   └── screenshots/
│       ├── paso-1/
│       │   ├── 01-docker-compose-ps.png
│       │   ├── 02-interfaz-web.png
│       │   └── ...
│       ├── paso-2/
│       │   ├── 01-servicios.png
│       │   └── ...
│       ├── paso-3/
│       ├── paso-4/
│       ├── paso-5/
│       └── paso-6/
└── proyecto_2/ (repositorio clonado)
```

## ⏱️ Planificación de Tiempo

### Sesión 1 (2 horas)
- **Paso 1**: Juice Shop (30 min)
- **Paso 2**: Elasticsearch (45 min)
- **Paso 3**: Kibana (45 min)

### Sesión 2 (2 horas)
- **Paso 4**: Filebeat (1 hora)
- **Paso 5**: Visualización (1 hora - inicio)

### Sesión 3 (2 horas)
- **Paso 5**: Visualización (1 hora - completar)
- **Paso 6**: Blue Team (1 hora - inicio)

### Sesión 4 (2 horas)
- **Paso 6**: Blue Team (completar)
- **Documentación final** (1 hora)

**Total estimado**: 8 horas

## 🎯 Objetivos de Aprendizaje por Paso

### Paso 1: Juice Shop
- Entender Docker y Docker Compose
- Configurar contenedores básicos
- Mapeo de puertos
- Logs de contenedores

### Paso 2: Elasticsearch
- Motor de búsqueda y análisis
- Índices y documentos
- API RESTful
- Persistencia de datos

### Paso 3: Kibana
- Interfaz de visualización
- Conexión entre servicios
- Redes Docker
- Dependencias entre servicios

### Paso 4: Filebeat
- Recolección de logs
- Procesamiento de datos
- Enriquecimiento de metadata
- Flujo completo de datos

### Paso 5: Visualización
- Data Views y patrones
- KQL (Kibana Query Language)
- Creación de visualizaciones
- Dashboards interactivos

### Paso 6: Blue Team
- Detección de amenazas
- Reglas de seguridad
- Análisis de incidentes
- Respuesta a incidentes

## 📊 Entregables

### Reporte Final (formato Markdown o PDF)

#### Estructura Requerida

```markdown
# Proyecto 2 - Sistema de Logging con ELK Stack

## 1. Portada
- Nombre del estudiante
- Carnet
- Fecha
- Curso

## 2. Índice

## 3. Resumen Ejecutivo
- Descripción general del proyecto
- Objetivos logrados
- Tecnologías utilizadas

## 4. Paso 1: Juice Shop Básico
- Objetivo del paso
- Comandos ejecutados
- Screenshots (mínimo 4)
- Problemas encontrados y soluciones
- Conceptos aprendidos

## 5. Paso 2: Elasticsearch
- (misma estructura)

## 6. Paso 3: Kibana
- (misma estructura)

## 7. Paso 4: Filebeat
- (misma estructura)

## 8. Paso 5: Visualización en Kibana
- (misma estructura)
- Screenshots de visualizaciones (mínimo 12)

## 9. Paso 6: Blue Team
- (misma estructura)
- Informe de incidente simulado
- Screenshots de detecciones (mínimo 12)

## 10. Análisis Técnico
- Arquitectura completa del sistema
- Flujo de datos detallado
- Decisiones de diseño

## 11. Problemas y Soluciones
- Lista consolidada de todos los problemas
- Cómo se resolvieron
- Lecciones aprendidas

## 12. Conceptos Aprendidos
- Lista completa de conceptos técnicos
- Explicación de cada uno

## 13. Conclusiones
- Reflexión personal
- Aplicaciones prácticas
- Mejoras futuras

## 14. Referencias
- Documentación oficial
- Recursos utilizados

## 15. Anexos
- Comandos completos ejecutados
- Configuraciones personalizadas
- Reglas de detección exportadas
- Dashboard exportado
```

### Archivos Adicionales a Entregar

1. **screenshots/** - Carpeta con todas las capturas organizadas
2. **comandos.txt** - Lista de todos los comandos ejecutados
3. **reglas-deteccion.json** - Reglas exportadas de Kibana
4. **dashboard-export.ndjson** - Dashboard exportado de Kibana

## 🏆 Criterios de Evaluación

### Completitud (30%)
- [ ] Todos los 6 pasos completados
- [ ] Todos los servicios funcionando
- [ ] Todas las verificaciones pasadas

### Documentación (30%)
- [ ] Reporte completo y bien estructurado
- [ ] Mínimo 42 screenshots de calidad
- [ ] Comandos documentados con outputs
- [ ] Problemas y soluciones explicados

### Comprensión Técnica (25%)
- [ ] Explicación clara de conceptos
- [ ] Análisis de arquitectura
- [ ] Entendimiento del flujo de datos
- [ ] Decisiones de diseño justificadas

### Seguridad (15%)
- [ ] Reglas de detección configuradas
- [ ] Alertas funcionando
- [ ] Análisis de incidentes
- [ ] Informe de respuesta

## 🆘 Recursos de Soporte

### Documentación Oficial
- [Docker](https://docs.docker.com/)
- [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Kibana](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)

### Troubleshooting
- Cada PASO_X.md incluye sección de troubleshooting
- PLAN_PRUEBAS.md tiene soluciones a problemas comunes
- README.md tiene comandos útiles

### Comandos de Ayuda Rápida

```bash
# Ver estado de servicios
docker compose ps

# Ver logs de un servicio
docker compose logs <servicio>

# Reiniciar un servicio
docker compose restart <servicio>

# Limpiar todo
docker compose down -v

# Ver recursos usados
docker stats

# Verificar conectividad
curl http://localhost:<puerto>
```

## 📝 Notas Importantes

### ⚠️ Advertencias

1. **No mezclar ramas**: Trabaja en una rama a la vez
2. **Limpia entre pasos**: Ejecuta `docker compose down -v` antes de cambiar de rama (excepto entre paso 5 y 6)
3. **Verifica antes de continuar**: Usa los checklists del PLAN_PRUEBAS.md
4. **Documenta en tiempo real**: No dejes la documentación para el final
5. **Guarda screenshots originales**: No los edites hasta tener el original guardado

### 💡 Tips de Éxito

1. **Lee toda la documentación primero**: Entiende el panorama completo
2. **Sigue el orden**: No saltes pasos
3. **Verifica cada comando**: No copies y pegues sin entender
4. **Documenta errores**: Son parte del aprendizaje
5. **Pide ayuda temprano**: No te atasques por horas
6. **Organiza tus archivos**: Usa la estructura sugerida
7. **Revisa antes de entregar**: Usa el checklist final

### 🎓 Aprendizaje Esperado

Al completar este proyecto, deberías poder:

1. **Explicar** cómo funciona el stack ELK
2. **Configurar** un sistema de logging desde cero
3. **Crear** visualizaciones y dashboards en Kibana
4. **Detectar** amenazas usando reglas de seguridad
5. **Analizar** logs para investigar incidentes
6. **Documentar** proyectos técnicos profesionalmente
7. **Resolver** problemas de forma autónoma
8. **Trabajar** con Docker y contenedores

## 🚀 Próximos Pasos

Una vez completado este proyecto, puedes:

1. **Expandir el sistema**:
   - Agregar Metricbeat para métricas
   - Implementar Logstash para procesamiento avanzado
   - Configurar APM para tracing

2. **Mejorar la seguridad**:
   - Habilitar autenticación en Elasticsearch
   - Configurar TLS/SSL
   - Implementar RBAC (Role-Based Access Control)

3. **Optimizar**:
   - Configurar ILM (Index Lifecycle Management)
   - Implementar snapshots automáticos
   - Ajustar performance

4. **Integrar**:
   - Conectar con otras aplicaciones
   - Enviar alertas a Slack/Email
   - Crear reportes automáticos

## 📞 Contacto y Soporte

Si tienes preguntas o problemas:

1. **Revisa la documentación** del paso correspondiente
2. **Consulta el PLAN_PRUEBAS.md** para troubleshooting
3. **Busca en la documentación oficial** de cada herramienta
4. **Pregunta al instructor** en horario de clase
5. **Colabora con compañeros** (sin copiar código)

---

**¡Éxito en tu proyecto!** 🎉

Recuerda: Este es un proyecto de aprendizaje. Los errores son oportunidades para entender mejor el sistema. Documenta todo, pregunta cuando tengas dudas, y disfruta el proceso de construcción de un sistema profesional de logging.

**Fecha de creación**: 2025-11-10
**Versión**: 1.0
