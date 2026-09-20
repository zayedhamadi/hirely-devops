#!/usr/bin/env bash
# Test rapide : les 3 entrees passent-elles par l'Ingress ?
NODE_IP="192.168.100.14"
PORT="30873"

check() {
  local host="$1" path="$2" code
  code=$(curl -sk -m 30 -o /dev/null -w "%{http_code}" \
    --resolve "$host:$PORT:$NODE_IP" "https://$host:$PORT$path")
  case "$code" in
    200|301|302|401|403|404) echo "OK    $host$path -> $code" ;;
    *)                       echo "PANNE $host$path -> $code" ;;
  esac
}

# Envoie un corps vide : user-service doit repondre par une erreur de validation,
# ce qui prouve que Ingress -> gateway -> user-service fonctionne.
check_api() {
  local out code body
  out=$(curl -sk -m 30 -X POST -H "Content-Type: application/json" -d '{}' \
    -w "\n%{http_code}" \
    --resolve "api.hirely.local:$PORT:$NODE_IP" "https://api.hirely.local:$PORT/auth/login")
  code="${out##*$'\n'}"
  body="${out%$'\n'*}"
  if [[ "$code" =~ ^(400|401|403|415|422)$ ]] || [[ "$body" == *MethodArgumentNotValidException* ]]; then
    echo "OK    api.hirely.local/auth/login -> $code (user-service atteint)"
  else
    echo "PANNE api.hirely.local/auth/login -> $code"
  fi
}

check app.hirely.local  /
check auth.hirely.local /realms/employee-realm/.well-known/openid-configuration
check_api
