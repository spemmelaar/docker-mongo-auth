#!/bin/bash

CREATE_ADMIN_USER=true
CREATE_APPLICATION_USER=true

# Wait for MongoDB to boot
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup..."
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

# Check if an admin user andn admin password need to be set.
if [ -z "$MONGODB_ADMIN_USERNAME" ]; then
    CREATE_ADMIN_USER=false
fi

if [ -z "$MONGODB_ADMIN_PASSWORD" ]; then
    CREATE_ADMIN_USER=false
fi

# Check if an application user and application password need to be set for an application db.
if [ -z "$MONGODB_APPLICATION_USERNAME" ]; then
    CREATE_APPLICATION_USER=false
fi

if [ -z "$MONGODB_APPLICATION_PASSWORD" ]; then
    CREATE_APPLICATION_USER=false
fi

if [ -z "$MONGODB_APPLICATION_DATABASE" ]; then
    CREATE_APPLICATION_USER=false
fi

if [  "$CREATE_ADMIN_USER" = false  ]; then
# If no admin user is to be set create a temporary admin user in order to create other database users, before deleting it later in the script.
    echo "=> Root user will not be created."
    MONGODB_ADMIN_USERNAME=admin
    MONGODB_ADMIN_PASSWORD=$(openssl rand -base64 48)
else
    echo "=> Creating admin user with a password in MongoDB"
fi

mongo admin --eval "db.createUser({user: '$MONGODB_ADMIN_USERNAME', pwd: '$MONGODB_ADMIN_PASSWORD', roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ] });"

sleep 2

if [ "$CREATE_APPLICATION_USER" = true ]; then

    if [ -z "$MONGODB_APPLICATION_AUTH_DATABASE" ]; then
        MONGODB_APPLICATION_AUTH_DATABASE=${MONGODB_APPLICATION_DATABASE}
    fi

    echo "=> Creating the application user with a password in MongoDB on database ${MONGODB_APPLICATION_AUTH_DATABASE}"
    mongo admin -u $MONGODB_ADMIN_USERNAME -p $MONGODB_ADMIN_PASSWORD << EOF
    use $MONGODB_APPLICATION_AUTH_DATABASE
    db.createUser({user: '$MONGODB_APPLICATION_USERNAME', pwd: '$MONGODB_APPLICATION_PASSWORD', roles: [ { role:'dbOwner', db: '$MONGODB_APPLICATION_DATABASE' }] })
EOF
else
    echo "=> Application database user will not be created."
fi

sleep 2

# Remove the admin user if one has not been declared through the environment variables. 
if [  "$CREATE_ADMIN_USER" = false  ]; then
    mongo admin -u $MONGODB_ADMIN_USERNAME -p $MONGODB_ADMIN_PASSWORD << EOF
db.dropUser("$MONGODB_ADMIN_USERNAME")
EOF
    echo "=> Admin user has now been removed."
fi

touch /data/db/.mongodb_password_set

echo "MongoDB configured successfully. You may now connect to the DB."