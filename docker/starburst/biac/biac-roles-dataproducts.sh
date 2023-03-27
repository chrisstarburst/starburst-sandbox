
#!/bin/bash

TRINO_ENDPOINT=
API_PATH=
USER=admin
PASSWORD=
TOKEN=$(echo "${USER}:'${PASSWORD} | base64)

curl_biac_read() {
   curl -u 'admin:' --location \
     -X GET 'http://localhost:8080/api/v1/biac/roles' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \
}

hello_world



curl -u 'admin:' --location \
     -X GET 'http://localhost:8080/api/v1/biac/roles' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \

# Create Data Products Service Role
curl -u 'admin:' --location \
     -X POST 'http://localhost:8080/api/v1/biac/roles' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \
     -d '{"name" : "dataproducts_service", "description" : "This is a role which you should only be assigned to the service account set for the data-product.starburst-user property."}'

# Create Data Products Admins Role
curl -u 'admin:' --location \
     -X POST 'http://localhost:8080/api/v1/biac/roles' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \
     -d '{"name" : "dataproducts_admins", "description" : "This is a role which you should assign to any users who you want to be able to administer Data Products."}'


curl -u 'admin:' --location \
     -X POST 'http://localhost:8080/api/v1/biac/subjects/users/2/assignments' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' \
     -d '{"roleid" : "1", "roleAdmin" : "true"}'


curl -u 'admin:' --location \
     -X GET 'http://localhost:8080/api/v1/biac/roles?pageToken=&pageSize=&pageSort=' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' 

curl -u 'admin:' --location \
     -X GET 'http://localhost:8080/api/v1/biac/roles/2/assignments' \
     -H 'Accept: application/json' \
     -H 'Content-Type: application/json' \
     -H 'X-Trino-Role: system=ROLE{sysadmin}' 



# Assing Data Product Service Role to data product service account




# Set User Impersonation 

