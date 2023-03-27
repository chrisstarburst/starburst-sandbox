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


##### LIST BIAC ROLES
echo "LIST BIAC ROLES"
API_PATH=/api/v1/biac/roles
curl_biac_get $API_PATH
echo""

##### CREATE ROLE FOR dataproducts_service 
echo "CREATE ROLE FOR dataproducts_service"
API_PATH=/api/v1/biac/roles
BODY=('{"name" : "dataproducts_service", "description" : "This is a role which you should only be assigned to the service account set for the data-product.starburst-user property."}')
curl_biac_set $API_PATH $BODY
echo ""

##### CREATE ROLE FOR dataproducts_admins
echo "CREATE ROLE FOR dataproducts_admins"
API_PATH=/api/v1/biac/roles
BODY=('{"name" : "dataproducts_admins", "description" : "This is a role which you should only be assigned to the service account set for the data-product.starburst-user property."}')
curl_biac_set $API_PATH $BODY
echo ""

sleep 5

##### GET dataproducts_service ID
echo "LIST BIAC ROLES"
API_PATH=/api/v1/biac/roles
DATAPRODUCTS_SERVICE_ID=`curl_biac_get $API_PATH | jq '.result[] | select(.name == "dataproducts_service") | .id'`
DATAPRODUCTS_ADMIN_ID=`curl_biac_get $API_PATH | jq '.result[] | select(.name == "dataproducts_admins") | .id'`
echo $DATAPRODUCTS_SERVICE_ID
echo $DATAPRODUCTS_ADMIN_ID






##### GET ROLE ASSIGNMENTS for dataproducts_service
echo "CREATE ROLE ASSIGNMENTS for dataproducts_service"
CURRENT_ROLE=$DATAPRODUCTS_SERVICE_ID
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/assignments
curl_biac_get $API_PATH
echo ""

##### GET ROLE ASSIGNMENTS for dataproducts_admin
echo "CREATE ROLE ASSIGNMENTS for dataproducts_admin"
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/assignments
curl_biac_get $API_PATH
echo ""

##### ASSIGN dataproducts_service USER TO ROLE
echo "ASSIGN dataproducts_service USER TO ROLE dataproducts_service"
API_PATH=/api/v1/biac/subjects/users/dataproducts_service/assignments
BODY='{
    "roleId": '$DATAPRODUCTS_SERVICE_ID',
    "roleAdmin": false
}'
curl_biac_set $API_PATH $BODY
echo""


##### ASSIGN dataproducts_service USER TO ROLE dataproducts_admin
echo "ASSIGN dataproducts_service USER TO ROLE dataproducts_admin"
API_PATH=/api/v1/biac/subjects/users/dataproducts_service/assignments
BODY='{
    "roleId": '$DATAPRODUCTS_ADMIN_ID',
    "roleAdmin": false
}'
curl_biac_set $API_PATH $BODY
echo ""

#### ASSIGN admin USER TO ROLE 
API_PATH=/api/v1/biac/subjects/users/admin/assignments
BODY='{
    "roleId": '$DATAPRODUCTS_ADMIN_ID',
    "roleAdmin": false
}'
curl_biac_set $API_PATH $BODY



##### GET GRANTS FOR ROLE dataproducts_service
echo "GET GRANTS FOR ROLE dataproducts_service"
CURRENT_ROLE=$DATAPRODUCTS_SERVICE_ID
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_get $API_PATH
echo ""


##### GET GRANTS FOR ROLE dataproducts_admin
echo "GET GRANTS FOR ROLE dataproducts_admin"
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_get $API_PATH 
echo ""



### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_SERVICE_ID
BODY='{
            "effect": "ALLOW",
            "action": "IMPERSONATE",
            "entity": {
                "category": "USERS",
                "allEntities": false,
                "entityKey": "*"
            }
}'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_SERVICE_ID
BODY='{
            "effect": "ALLOW",
            "action": "IMPERSONATE",
            "entity": {
                "category": "USERS",
                "allEntities": false,
                "entityKey": "admin"
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY





### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "SHOW",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "INSERT",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "DELETE",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "UPDATE",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "REFRESH",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "ALTER",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "DROP",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "SELECT",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
}'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW_WITH_GRANT_OPTION",
            "action": "CREATE",
            "entity": {
                "category": "TABLES",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW",
            "action": "PUBLISH",
            "entity": {
                "category": "DATA_PRODUCTS",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW",
            "action": "ALTER",
            "entity": {
                "category": "DATA_PRODUCTS",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW",
            "action": "DROP",
            "entity": {
                "category": "DATA_PRODUCTS",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW",
            "action": "CREATE",
            "entity": {
                "category": "DATA_PRODUCTS",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY

### SET GRANTS FOR ROLE dataproducts_admin
CURRENT_ROLE=$DATAPRODUCTS_ADMIN_ID
BODY='{
            "effect": "ALLOW",
            "action": "SHOW",
            "entity": {
                "category": "DATA_PRODUCTS",
                "allEntities": true
            }
        }'
API_PATH=/api/v1/biac/roles/${CURRENT_ROLE}/grants
curl_biac_set $API_PATH $BODY
