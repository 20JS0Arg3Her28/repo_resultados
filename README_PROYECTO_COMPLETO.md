# 🎓 Proyecto 2 - Sistema de Logging con ELK Stack

## 📚 Documentación Completa del Proyecto

Este repositorio contiene un proyecto educativo completo para aprender a implementar un sistema de logging profesional usando el stack ELK (Elasticsearch, Logstash/Filebeat, Kibana) con OWASP Juice Shop como aplicación de prueba.

---

## 🗂️ Estructura de Documentación

### 📖 Guías Principales

| Documento | Descripción | Para Quién |
|-----------|-------------|------------|
| **README.md** | Visión general y quick start | Todos |
| **PLAN_PROYECTO_ACUMULATIVO.md** | Plan completo del proyecto acumulativo | Instructores y Estudiantes |
| **ESTRATEGIA_RAMAS.md** | Estructura de ramas Git y flujo de trabajo | Estudiantes |
| **GUIA_DOCUMENTACION.md** | Cómo capturar screenshots profesionales | Estudiantes |
| **PLAN_PRUEBAS.md** | Checklist de verificación por paso | Estudiantes |

### 🛡️ Documentación de Actividades

| Documento | Descripción | Rol |
|-----------|-------------|-----|
| **ACTIVIDADES_RED_TEAM.md** | Guía completa de explotación de vulnerabilidades | Red Team |
| **PASO_6_BLUE_TEAM.md** | Guía completa de operaciones defensivas | Blue Team |

### 📝 Plantillas

| Documento | Descripción | Uso |
|-----------|-------------|-----|
| **PLANTILLA_DOCUMENTACION_ESTUDIANTE.md** | Plantilla completa para el reporte final | Estudiantes |

### 🔧 Documentación Técnica por Paso

| Documento | Paso | Contenido |
|-----------|------|-----------|
| **PASO_1_JUICE_SHOP.md** | 1 | Configuración de Juice Shop básico |
| **PASO_2_ELASTICSEARCH.md** | 2 | Implementación de Elasticsearch |
| **PASO_3_KIBANA.md** | 3 | Configuración de Kibana |
| **PASO_4_FILEBEAT.md** | 4 | Integración con Filebeat |
| **PASO_5_VISUALIZACION_KIBANA.md** | 5 | Visualizaciones y dashboards |
| **PASO_6_BLUE_TEAM.md** | 6 | Operaciones defensivas |

---

## 🌳 Ramas del Proyecto

El proyecto está organizado en ramas Git para facilitar el aprendizaje incremental:

```
main (proyecto completo)
├── paso-1-juice-shop (solo Juice Shop)
├── paso-2-elasticsearch (+ Elasticsearch)
├── paso-3-kibana (+ Kibana)
├── paso-4-filebeat (+ Filebeat - sistema completo)
├── paso-5-visualizacion (+ configuración de Kibana)
└── paso-6-blue-team (+ scripts y reglas de seguridad)
```

### Cómo Usar las Ramas

```bash
# Ver todas las ramas
git branch -a

# Cambiar a una rama específica
git checkout paso-1-juice-shop

# Ver qué cambió entre pasos
git diff paso-1-juice-shop paso-2-elasticsearch

# Limpiar antes de cambiar de rama
docker compose down -v
```

---

## 🚀 Quick Start

### Para Estudiantes

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd proyecto_2
   ```

2. **Leer la documentación de planificación**
   ```bash
   cat PLAN_PROYECTO_ACUMULATIVO.md
   cat ESTRATEGIA_RAMAS.md
   ```

3. **Empezar con el Paso 1**
   ```bash
   git checkout paso-1-juice-shop
   cat PASO_1_JUICE_SHOP.md
   ```

4. **Seguir el flujo**
   - Leer documentación del paso
   - Ejecutar comandos del PLAN_PRUEBAS.md
   - Capturar screenshots según GUIA_DOCUMENTACION.md
   - Documentar en PLANTILLA_DOCUMENTACION_ESTUDIANTE.md
   - Verificar éxito con checklist
   - Limpiar y pasar al siguiente paso

### Para Instructores

1. **Revisar el plan completo**
   ```bash
   cat PLAN_PROYECTO_ACUMULATIVO.md
   ```

2. **Verificar estructura de ramas**
   ```bash
   git branch -a
   git log --all --graph --oneline
   ```

3. **Probar cada paso**
   ```bash
   # Para cada rama
   git checkout paso-X-nombre
   docker compose up -d
   # Verificar funcionalidad
   docker compose down -v
   ```

---

## 📊 Resumen del Proyecto

### Objetivos de Aprendizaje

1. **Infraestructura**
   - Docker y Docker Compose
   - Contenedores y orquestación
   - Redes y volúmenes

2. **ELK Stack**
   - Elasticsearch: almacenamiento y búsqueda
   - Kibana: visualización y análisis
   - Filebeat: recolección de logs

3. **Seguridad**
   - Detección de amenazas (Blue Team)
   - Explotación de vulnerabilidades (Red Team)
   - OWASP Top 10
   - CVSS scoring

4. **Habilidades Profesionales**
   - Documentación técnica
   - Troubleshooting
   - Análisis de logs
   - Respuesta a incidentes

### Entregables

| Entregable | Descripción | Formato |
|------------|-------------|---------|
| **Reporte Final** | Documentación completa de todos los pasos | PDF/Markdown |
| **Screenshots** | Mínimo 42 capturas organizadas | PNG/JPG |
| **Comandos** | Lista de todos los comandos ejecutados | TXT |
| **Reglas de Detección** | Export de reglas de Kibana | JSON |
| **Dashboard** | Export de dashboard | NDJSON |
| **PoCs Red Team** | Proof of Concepts de vulnerabilidades | Markdown |
| **Informe Blue Team** | Análisis de detecciones y respuesta | Markdown |

### Tiempo Estimado

| Fase | Tiempo |
|------|--------|
| Paso 1: Juice Shop | 30 min |
| Paso 2: Elasticsearch | 45 min |
| Paso 3: Kibana | 45 min |
| Paso 4: Filebeat | 1 hora |
| Paso 5: Visualización | 1.5 horas |
| Paso 6: Blue Team | 2 horas |
| Actividades Red Team | 3 horas |
| Documentación | 2 horas |
| **TOTAL** | **~11 horas** |

---

## 📸 Screenshots Requeridos

### Por Paso

| Paso | Mínimo | Recomendado |
|------|--------|-------------|
| Paso 1 | 4 | 6 |
| Paso 2 | 5 | 8 |
| Paso 3 | 4 | 6 |
| Paso 4 | 5 | 8 |
| Paso 5 | 12 | 15 |
| Paso 6 | 12 | 15 |
| **TOTAL** | **42** | **58** |

### Puntos Clave de Captura

Consultar **GUIA_DOCUMENTACION.md** para lista detallada de qué capturar en cada paso.

---

## ✅ Criterios de Evaluación

### Completitud (30%)
- Todos los 6 pasos completados
- Todos los servicios funcionando
- Todas las verificaciones pasadas

### Documentación (30%)
- Reporte completo y bien estructurado
- Screenshots de calidad (mínimo 42)
- Comandos documentados con outputs
- Problemas y soluciones explicados

### Comprensión Técnica (25%)
- Explicación clara de conceptos
- Análisis de arquitectura
- Entendimiento del flujo de datos
- Decisiones de diseño justificadas

### Seguridad (15%)
- **Red Team**: 4 vulnerabilidades explotadas con PoC
- **Blue Team**: 3 reglas de detección configuradas
- Análisis de incidentes
- Informe de respuesta

---

## 🛠️ Requisitos Técnicos

### Software Necesario

- **Docker**: Versión 20.10+
- **Docker Compose**: Versión 2.0+
- **Git**: Versión 2.30+
- **curl**: Para pruebas de API
- **jq**: Para formatear JSON (opcional)

### Recursos de Sistema

- **RAM**: Mínimo 4GB, recomendado 8GB
- **Disco**: Mínimo 10GB libres
- **CPU**: 2 cores mínimo
- **Puertos**: 3000, 5601, 9200, 9300 disponibles

### Herramientas Opcionales

- **BurpSuite Community** o **OWASP ZAP**: Para Red Team
- **Postman**: Para pruebas de API
- **Visual Studio Code**: Para editar archivos

---

## 🔗 Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                         USUARIO                                 │
│                                                                 │
│  1. Usa Juice Shop → Genera logs                               │
│  2. Abre Kibana → Ve logs en tiempo real                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
             │                                 │
             │ HTTP                            │ HTTP
             │                                 │
┌──────────────────┐            ┌──────────────────────┐
│   Juice Shop     │            │   Kibana             │
│   Puerto 3000    │            │   Puerto 5601        │
└──────────────────┘            └──────────────────────┘
           │                                   │
           │ stdout/stderr                     │ Queries
           │                                   │
┌──────────────────┐                           │
│  Docker Engine   │                           │
│  Captura logs    │                           │
└──────────────────┘                           │
           │                                   │
           │ Archivos .log                     │
           │                                   │
┌──────────────────┐                           │
│   Filebeat       │                           │
│   Recolecta      │                           │
│   Procesa        │                           │
└──────────────────┘                           │
           │                                   │
           │ HTTP POST (JSON)                  │
           │                                   │
┌──────────────────┐                           │
│   Elasticsearch  │◄──────────────────────────┘
│   Puerto 9200    │
│   Indexa y       │
│   Almacena       │
└──────────────────┘
           │
           │
┌──────────────────┐
│  Volúmenes       │
│  Persistencia    │
└──────────────────┘
```

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [Docker Documentation](https://docs.docker.com/)
- [Elasticsearch Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Kibana Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)

### Seguridad

- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [CVSS v3.1 Calculator](https://www.first.org/cvss/calculator/3.1)
- [SQL Injection Cheat Sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)
- [XSS Filter Evasion](https://owasp.org/www-community/xss-filter-evasion-cheatsheet)

### Tutoriales

- [Elastic Stack Getting Started](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-stack.html)
- [Docker Compose Tutorial](https://docs.docker.com/compose/gettingstarted/)
- [Juice Shop Pwning Guide](https://pwning.owasp-juice.shop/)

---

## 🆘 Soporte

### Troubleshooting

Cada documento PASO_X.md incluye una sección de troubleshooting con problemas comunes y soluciones.

Para problemas generales, consultar:
- **PLAN_PRUEBAS.md**: Troubleshooting por paso
- **README.md**: Comandos útiles
- Logs de Docker: `docker compose logs <servicio>`

### Comandos Útiles

```bash
# Ver estado de servicios
docker compose ps

# Ver logs
docker compose logs -f <servicio>

# Reiniciar servicio
docker compose restart <servicio>

# Limpiar todo
docker compose down -v

# Ver recursos
docker stats

# Verificar conectividad
curl http://localhost:<puerto>

# Ver índices de Elasticsearch
curl http://localhost:9200/_cat/indices?v

# Ver salud de Elasticsearch
curl http://localhost:9200/_cluster/health?pretty
```

---

## 👥 Contribuciones

Este es un proyecto educativo. Si encuentras errores o mejoras:

1. Crea un issue describiendo el problema/mejora
2. Si tienes una solución, crea un pull request
3. Asegúrate de probar los cambios en todas las ramas afectadas

---

## 📄 Licencia

Este proyecto es con fines educativos.

---

## 📞 Contacto

Para preguntas sobre el proyecto:
- Revisar la documentación correspondiente
- Consultar con el instructor
- Colaborar con compañeros (sin copiar)

---

## 🎯 Próximos Pasos

### Después de Completar el Proyecto

1. **Expandir el sistema**:
   - Agregar Metricbeat para métricas
   - Implementar Logstash para procesamiento avanzado
   - Configurar APM para tracing

2. **Mejorar la seguridad**:
   - Habilitar autenticación en Elasticsearch
   - Configurar TLS/SSL
   - Implementar RBAC

3. **Optimizar**:
   - Configurar ILM (Index Lifecycle Management)
   - Implementar snapshots automáticos
   - Ajustar performance

4. **Integrar**:
   - Conectar con otras aplicaciones
   - Enviar alertas a Slack/Email
   - Crear reportes automáticos

---

## 📊 Estadísticas del Proyecto

- **Documentos creados**: 13
- **Ramas Git**: 6 + main
- **Pasos del proyecto**: 6
- **Screenshots mínimos**: 42
- **Vulnerabilidades a explotar**: 4
- **Reglas de detección**: 3
- **Tiempo estimado**: 11 horas
- **Líneas de documentación**: ~5000+

---

**¡Éxito en tu proyecto!** 🚀✨

**Recuerda**: Este es un proyecto de aprendizaje. Los errores son oportunidades para entender mejor el sistema. Documenta todo, pregunta cuando tengas dudas, y disfruta el proceso de construcción de un sistema profesional de logging.

---

**Última actualización**: 2025-11-10  
**Versión**: 1.0
