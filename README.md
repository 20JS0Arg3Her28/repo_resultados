# Proyecto 2 - Sistema de Logging con ELK Stack
<a id="readme-top"></a>

<!--
PROJECT DESCRIPTION
-->
## 📜 Descripción

Este proyecto implementa un sistema completo de monitoreo y logging para contenedores Docker usando el **ELK Stack** (Elasticsearch, Logstash, Kibana) con **Filebeat**. El sistema permite:

- Recolectar logs de aplicaciones Docker en tiempo real
- Indexar y almacenar logs en Elasticsearch
- Visualizar y analizar logs mediante Kibana
- Crear dashboards personalizados para monitoreo

El sistema está 100% funcional y listo para uso en producción.

## 📦 Requisitos

- Docker
- Docker Compose
- Comandos básicos de Linux
- Navegador web (para acceder a Kibana)

## 🚀 Instalación y Ejecución

### 1. Clona este repositorio

```bash
git clone <url-del-repositorio>
cd proyecto_2
```

### 2. Levanta el sistema

```bash
docker compose up -d
```

### 3. Espera que los servicios inicien (~2 minutos)

```bash
docker compose ps
```

Verifica que todos los servicios estén en estado `Up`:
- `juice-shop`
- `elasticsearch`
- `kibana`
- `filebeat`

### 4. Genera logs de prueba

```bash
for i in {1..20}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

### 5. Ver logs en Kibana

1. Abre http://localhost:5601 en tu navegador
2. Ve a **Management** → **Data Views**
3. Crea un Data View: `filebeat-*`
4. Ve a **Analytics** → **Discover**
5. ¡Explora tus logs!

## 🔗 Acceso a Servicios

- **Juice Shop**: http://localhost:3000
- **Kibana**: http://localhost:5601
- **Elasticsearch API**: http://localhost:9200

## 📚 Documentación Detallada

Cada paso tiene su documentación completa con explicaciones técnicas y cómo se relaciona con los demás componentes:

- `PASO_1_JUICE_SHOP.md` - Configuración de Juice Shop
- `PASO_2_ELASTICSEARCH.md` - Implementación de Elasticsearch
- `PASO_3_KIBANA.md` - Configuración de Kibana
- `PASO_4_FILEBEAT.md` - Integración con Filebeat
- `PASO_5_VISUALIZACION_KIBANA.md` - Guía de uso de Kibana
- `PASO_6_BLUE_TEAM.md` - Operaciones defensivas y detecciones Blue Team

## ✅ Progreso del Proyecto

### Paso 1: Juice Shop Básico
- [x] Dockerfile configurado
- [x] docker-compose.yml básico
- [x] Servicio funcionando en puerto 3000

### Paso 2: Elasticsearch
- [x] Servicio Elasticsearch agregado
- [x] Configurado para nodo único
- [x] Volumen persistente para datos
- [x] Healthcheck configurado
- [x] Red compartida elk-network

### Paso 3: Kibana
- [x] Servicio Kibana agregado
- [x] Conectado a Elasticsearch
- [x] Healthcheck configurado
- [x] Dependencia de Elasticsearch configurada
- [x] Interfaz web en puerto 5601

### Paso 4: Filebeat
- [x] Servicio Filebeat agregado
- [x] Configurado para leer logs de Docker
- [x] Conectado a Elasticsearch y Kibana
- [x] Volúmenes montados correctamente
- [x] Procesadores configurados
- [x] Índices dinámicos por contenedor

### Paso 5: Visualización en Kibana
- [x] Data Views configurados
- [x] Discover para explorar logs
- [x] Visualizaciones creadas
- [x] Dashboard armado
- [x] Guía completa de uso

### Paso 6: Defensa Blue Team
- [x] Plan de actividades defensivas documentado
- [x] Instrumentación propuesta (proxy, CORS, pipelines)
- [x] Reglas de detección SQLi / XSS / Burst definidas
- [x] Procedimientos de respuesta y reporte establecidos

## 🛠️ Comandos Útiles

### Ver logs

```bash
# Todos los servicios
docker compose logs -f

# Servicio específico
docker compose logs -f filebeat
docker compose logs -f elasticsearch
```

### Verificar servicios

```bash
# Estado de contenedores
docker compose ps

# Salud de Elasticsearch
curl http://localhost:9200/_cluster/health?pretty

# Índices creados
curl http://localhost:9200/_cat/indices?v

# Estado de Kibana
curl http://localhost:5601/api/status
```

### Detener sistema

```bash
# Detener sin eliminar datos
docker compose down

# Detener y eliminar volúmenes (limpieza completa)
docker compose down -v
```

## 🏗️ Arquitectura del Sistema

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
│  Volúmenes     │
│  Persistencia  │
└──────────────────┘
```

## 📖 Conceptos Aprendidos

- **Docker Compose**: Orquestación de múltiples contenedores
- **Elasticsearch**: Motor de búsqueda y análisis de logs
- **Kibana**: Visualización y exploración de datos
- **Filebeat**: Recolección ligera de logs
- **Redes Docker**: Comunicación entre contenedores
- **Volúmenes**: Persistencia de datos
- **Healthchecks**: Verificación de disponibilidad
- **Dependencies**: Orden de inicio de servicios

## 🔧 Troubleshooting

### Servicios no inician

```bash
# Ver logs de error
docker compose logs

# Verificar recursos
docker stats

# Reiniciar servicios
docker compose restart
```

### No veo logs en Kibana

1. Verifica que Filebeat esté corriendo: `docker compose ps`
2. Genera tráfico en Juice Shop
3. Espera 30-60 segundos
4. Verifica índices: `curl http://localhost:9200/_cat/indices?v`
5. Amplía rango de tiempo en Kibana

### Elasticsearch sin memoria

```bash
# Editar docker-compose.yml
# Cambiar: ES_JAVA_OPTS=-Xms256m -Xmx256m
docker compose restart elasticsearch
```

## 📝 Historial de Commits

Cada paso está documentado en un commit separado para control de versiones:

- **Paso 1**: Configurar Juice Shop básico
- **Paso 2**: Agregar Elasticsearch
- **Paso 3**: Agregar Kibana
- **Paso 4**: Agregar Filebeat - Completar flujo de datos
- **Paso 5**: Configurar visualización en Kibana

```bash
# Ver historial
git log --oneline

# Ver cambios de un paso específico
git show <commit-hash>

# Ver diferencias entre pasos
git diff <commit1> <commit2>
```

## 👥 Contribuciones

Si deseas contribuir al proyecto, por favor sigue los siguientes pasos:

1. Realiza un fork del repositorio.
2. Crea una nueva rama para tu funcionalidad (`git checkout -b feature/nueva-funcionalidad`).
3. Haz commit de tus cambios (`git commit -m 'Añadir nueva funcionalidad'`).
4. Haz push a la rama (`git push origin feature/nueva-funcionalidad`).
5. Abre un Pull Request.

## 📄 Licencia

Este proyecto es con fines educativos.

## 📞 Contacto

Si tienes preguntas o comentarios sobre el proyecto, puedes contactarnos a través de:

- Issues en el repositorio
- Pull Requests para mejoras

<p align="right">(<a href="#readme-top">Ir al inicio</a>)</p>
