FROM mongo:latest

MAINTAINER <Shane Pemmelaar> spemmelaar@gmail.com

# If the AUTH env variable is set then the mongod process is started with the --auth flag:
# - AUTH

# If both of the following env variables are supplied an admin user is created with the privileges stored in the admin database:
# - MONGODB_ADMIN_USERNAME
# - MONGODB_ADMIN_PASSWORD

# If the following 3 env variables are supplied an application username/password is created with read write privelliges over 
# the specified database. In addition, the MONGODB_APPLICATION_AUTH_DATABASE may optionally be set so that application user privelliges
# will be set in that specified database. Otherwise, by default it is set in the database for which you are specifying the credentials
# to apply to (MONGODB_APPLICATION_DATABASE):
# - MONGODB_APPLICATION_USERNAME
# - MONGODB_APPLICATION_PASSWORD
# - MONGODB_APPLICATION_DATABASE

EXPOSE 27017 27017

ADD run.sh /run.sh
ADD set_mongodb_password.sh /set_mongodb_password.sh

RUN chmod +x /run.sh
RUN chmod +x /set_mongodb_password.sh

CMD ["/run.sh"]