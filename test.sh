TRINO_ENDPOINT="http://localhost:8080"
USER="admin"
PASSWORD=
TOKEN=`echo "${USER}:${PASSWORD}" | base64`
#echo $TOKEN


##### BIAC GET FUNCTION
curl_biac_get() {
API_PATH=$API_PATH
   curl -s -u "${USER}:${PASSWORD}" --location \
     -X GET "${TRINO_ENDPOINT}$API_PATH" \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' | python3 -mjson.tool
}

##### BIAC SET FUNCTION
curl_biac_set() {

API_PATH=$API_PATH
BODY=$BODY

   curl -s -u "${USER}:${PASSWORD}" --location \
     -X POST "${TRINO_ENDPOINT}${API_PATH}" \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \
     -d "${BODY}" | python3 -mjson.tool
}


##### GET dataproducts_service ID
echo "LIST BIAC ROLES"
API_PATH=/api/v1/biac/roles
DATAPRODUCTS_SERVICE_ID=`curl_biac_get $API_PATH | jq '.result[] | select(.name == "dataproducts_service") | .id'`
DATAPRODUCTS_ADMIN_ID=`curl_biac_get $API_PATH | jq '.result[] | select(.name == "dataproducts_admins") | .id'`
echo $DATAPRODUCTS_SERVICE_ID
echo $DATAPRODUCTS_ADMIN_ID
