curl -X POST -H "Content-Type: application/json" -d @login.json http://192.180.4.2:8002/api/auth/login > token.txt
token=$(cat token.txt | jq -r '.token')