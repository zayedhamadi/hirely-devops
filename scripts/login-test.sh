#!/usr/bin/env bash
# Test complet : Ingress -> gateway -> user-service -> Keycloak / MySQL
# L'email et le mot de passe sont demandes a l'ecran, jamais ecrits dans un fichier.
NODE_IP="192.168.100.14"
PORT="30873"

read -rp "Email du compte de test : " EMAIL
read -rsp "Mot de passe (invisible) : " PASSWORD
echo

RESP=$(EMAIL="$EMAIL" PASSWORD="$PASSWORD" python3 -c \
  'import json,os; print(json.dumps({"email":os.environ["EMAIL"],"password":os.environ["PASSWORD"]}))' \
  | curl -sk -m 60 -X POST -H "Content-Type: application/json" --data-binary @- \
    -w "\n%{http_code}" \
    --resolve "api.hirely.local:$PORT:$NODE_IP" "https://api.hirely.local:$PORT/auth/login")
unset PASSWORD

CODE="${RESP##*$'\n'}"
BODY="${RESP%$'\n'*}"

if [[ "$CODE" == "200" ]]; then
  FIELDS=$(echo "$BODY" | python3 -c 'import sys,json; print(", ".join(json.load(sys.stdin).keys()))' 2>/dev/null || echo "reponse non JSON")
  echo "OK    login -> 200 (champs recus : $FIELDS)"
else
  echo "PANNE login -> $CODE"
fi
