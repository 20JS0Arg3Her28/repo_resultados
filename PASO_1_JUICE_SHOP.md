# Paso 1: Configurar Juice Shop Básico
<a id="readme-top"></a>

<!--
PROJECT DESCRIPTION
-->
## 📜 Descripción

Este paso configura y ejecuta **OWASP Juice Shop** como aplicación base que generará logs para monitorear en el sistema ELK Stack.

**OWASP Juice Shop** es una aplicación web intencionalmente vulnerable creada por OWASP (Open Web Application Security Project).

### Características
- Aplicación de e-commerce moderna (Node.js + Angular)
- Contiene vulnerabilidades de seguridad conocidas
- Diseñada para aprendizaje y práctica de seguridad
- Genera logs de actividad HTTP

### ¿Por qué la usamos?
- **Genera tráfico real**: Cada interacción genera logs
- **Fácil de usar**: Interfaz web intuitiva
- **Predecible**: Sabemos qué tipo de logs producirá
- **Educativa**: Podemos ver cómo se registran diferentes tipos de requests

## 📦 Requisitos

- Docker
- Docker Compose
- Navegador web o curl (para pruebas)

## 🚀 Instalación y Ejecución

### 1. Verificar archivos necesarios

Asegúrate de tener los siguientes archivos en tu proyecto:

- `Dockerfile`
- `docker-compose.yml`

### 2. Levantar el servicio

```bash
docker compose up -d
```

**Qué hace este comando**:
- `up`: Crea e inicia los contenedores
- `-d`: Modo detached (background)

### 3. Verificar que está corriendo

```bash
docker compose ps
```

**Salida esperada**:
```
NAME         IMAGE                   STATUS         PORTS
juice-shop   proyecto_2-juice-shop   Up X seconds   0.0.0.0:3000->3000/tcp
```

### 4. Probar la aplicación

```bash
# Opción 1: Desde terminal
curl http://localhost:3000

# Opción 2: Desde navegador
# Abre: http://localhost:3000
```

**Qué deberías ver**:
- En terminal: HTML de la página principal
- En navegador: Interfaz de la tienda online

### 5. Ver logs del contenedor

```bash
docker compose logs juice-shop
```

**Qué verás**:
```
juice-shop  | Server listening on port 3000
juice-shop  | info: All dependencies in ./package.json are satisfied
```

### 6. Generar tráfico para crear logs

```bash
# Hacer 10 requests
for i in {1..10}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i completada"
  sleep 1
done
```

## 📋 Componentes Implementados

### Dockerfile

```dockerfile
FROM bkimminich/juice-shop:latest
EXPOSE 3000
```

**Explicación**:
- `FROM`: Usa la imagen oficial pre-construida de Juice Shop
- `EXPOSE 3000`: Declara que el contenedor escucha en el puerto 3000

**¿Por qué usar la imagen oficial?**
- Ya tiene todas las dependencias
- Configuración optimizada
- Actualizaciones regulares
- Menor tiempo de construcción

### docker-compose.yml

```yaml
services:
  juice-shop:
    build: .
    container_name: juice-shop
    ports:
      - "3000:3000"
    restart: unless-stopped
    environment:
      - NODE_ENV=production
```

**Explicación línea por línea**:
- `build: .`: Construye la imagen desde el Dockerfile local
- `container_name`: Nombre fijo para el contenedor (facilita identificación)
- `ports: "3000:3000"`: Mapea puerto del contenedor al host
  - Formato: `HOST:CONTAINER`
  - Permite acceder desde http://localhost:3000
- `restart: unless-stopped`: Reinicia automáticamente si falla
- `NODE_ENV=production`: Configura Node.js en modo producción

## 📊 Tipos de Logs que Genera

| **Tipo de Log** | **Ejemplo** | **Descripción** |
|-----------------|-------------|-----------------|
| Logs de inicio | `Server listening on port 3000` | Indica que el servidor está listo |
| Logs HTTP | `GET /api/Products 200 45ms` | Requests HTTP con método, ruta, status y tiempo |
| Logs de errores | `Error: Database connection failed` | Errores de aplicación o conexión |

### Formato de logs
- **Timestamp**: Cuándo ocurrió
- **Nivel**: INFO, WARN, ERROR
- **Método HTTP**: GET, POST, PUT, DELETE
- **Ruta**: /api/Products
- **Status**: 200, 404, 500
- **Tiempo**: Duración de la request

## 🔧 Comandos Útiles

### Ver logs
```bash
# Logs del servicio
docker compose logs juice-shop

# Logs en tiempo real (follow)
docker compose logs -f juice-shop
```

### Verificar estado
```bash
# Estado de contenedores
docker compose ps

# Probar aplicación
curl http://localhost:3000
```

### Detener servicio
```bash
# Detener sin eliminar contenedor
docker compose stop juice-shop

# Detener y eliminar contenedor
docker compose down
```

## 🏗️ Arquitectura Actual

```
||||||||||||||||||||
||   Tu Máquina    ||
||  localhost:3000 ||
||||||||||||||||||||
         ||
         || HTTP
         ||
||||||||||||||||||||
||  Docker         ||
||  juice-shop     ||
||  Puerto 3000    ||
||||||||||||||||||||
```

## 💡 Conceptos Clave

### Docker Compose
- Herramienta para definir aplicaciones multi-contenedor
- Usa archivo YAML para configuración
- Simplifica comandos de Docker

### Contenedor vs Imagen
- **Imagen**: Template (plantilla) inmutable
- **Contenedor**: Instancia en ejecución de una imagen

### Port Mapping
- Permite acceder a servicios del contenedor desde el host
- Formato: `host_port:container_port`
- Sin esto, el servicio solo sería accesible dentro de Docker

## 🔍 Troubleshooting

### Contenedor no inicia
```bash
# Ver logs de error
docker compose logs juice-shop

# Verificar recursos
docker stats juice-shop

# Reiniciar servicio
docker compose restart juice-shop
```

### Puerto 3000 ya en uso
```bash
# Ver qué usa el puerto
lsof -i :3000

# Cambiar puerto en docker-compose.yml
ports:
  - "3001:3000"  # Cambiar 3000 por 3001 en el host
```

### No veo logs
```bash
# Verificar que el contenedor está corriendo
docker compose ps

# Ver logs en tiempo real
docker compose logs -f juice-shop

# Generar tráfico primero
curl http://localhost:3000
```

## 📝 Tips para Verificar el Funcionamiento

1. **Verifica el estado del contenedor**
   - Usa `docker compose ps` para verificar que el contenedor está en estado "Up"
   - Debe mostrar el puerto mapeado correctamente

2. **Prueba la conectividad**
   - Desde el navegador: http://localhost:3000
   - Desde terminal: `curl http://localhost:3000`
   - Debes recibir una respuesta HTTP válida

3. **Revisa los logs en tiempo real**
   - Usa `docker compose logs -f juice-shop` para ver logs en vivo
   - Genera tráfico navegando por la aplicación o usando curl
   - Debes ver logs de requests HTTP

4. **Verifica la generación de logs**
   - Cada request debe generar una entrada en los logs
   - Los logs deben incluir información como método HTTP, ruta y status code

## ➡️ Siguiente Paso

Una vez que Juice Shop está funcionando correctamente, el siguiente paso será agregar **Elasticsearch** para comenzar a almacenar y analizar estos logs.

Ver: `PASO_2_ELASTICSEARCH.md`

## ✅ Resumen

### Logrado
- [x] Dockerfile configurado
- [x] docker-compose.yml básico
- [x] Servicio funcionando en puerto 3000
- [x] Accesible desde http://localhost:3000
- [x] Generando logs de actividad

### Verificado
- [x] Contenedor en estado "Up"
- [x] Aplicación responde a HTTP requests
- [x] Logs visibles con `docker compose logs`

<p align="right">(<a href="#readme-top">Ir al inicio</a>)</p>
