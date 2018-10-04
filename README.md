# docker-mongo-auth
A Docker Image for MongoDB which makes it easy to create an Admin, a Database and a Database User when the container is first launched.

# Customization and Operation
There are a number of environment variables which you can specify to customize the usernames, passwords, databases and authentication
databases for creating database users.

When creating an admin user (with privileges to create users on other databases) the appropriate username and password environment 
variables must be specified. The admin user privileges will be stored in the admin database.

When creating a database user (which is not an admin user) the appropriate username, password and database environment variables must 
be specified. In addition you may optionally specify the authentication database for the user using the MONGODB_APPLICATION_AUTH_DATABASE 
environment variable if you do not want their credentials to be populated in the database you are specifying the credentials for.

You may create a database user without choosing to create an admin user if you wish to do so. This may be a suitable decision for 
running the database in production.

The 'AUTH' environment variable may be set to 'yes' if you require the mongod process to be started with the --auth flag.

# List of configurable environment variables
- AUTH
- MONGODB_ADMIN_AUTH_DATABASE
- MONGODB_ADMIN_USERNAME
- MONGODB_ADMIN_PASSWORD
- MONGODB_APPLICATION_USERNAME
- MONGODB_APPLICATION_PASSWORD
- MONGODB_APPLICATION_DATABASE
- MONGODB_APPLICATION_AUTH_DATABASE

# Usage Examples
- With Dockerfile
  ```
  // Auth Configuration.
  // You may also choose to set MONGODB_ADMIN_AUTH_DATABASE if you want the root user authenticated on a different db to 'admin'

  // ... more configuration
  ENV AUTH yes
  ENV MONGODB_ADMIN_USERNAME adminpw
  ENV MONGODB_ADMIN_PASSWORD password
  ENV MONGODB_APPLICATION_USERNAME your_username
  ENV MONGODB_APPLICATION_PASSWORD your_password
  ENV MONGODB_APPLICATION_DATABASE your_db
  // ... more configuration
  ```

- With docker-compose.yml
  ```
  // ... more configuration
  services:
    db:
      image: scrillzy/mongo-auth:latest
      environment:
        - AUTH=yes
        - MONGODB_ADMIN_USERNAME=admin
        - MONGODB_ADMIN_PASSWORD=admin123
        - MONGODB_APPLICATION_DATABASE=sample
        - MONGODB_APPLICATION_USERNAME=scrillzy
        - MONGODB_APPLICATION_DATABASE=admin123
      ports:
        - "27017:27017"
  // ... more configuration
  ```

- With command line
  ```
  docker run -it \
    -e AUTH=yes \
    -e MONGODB_ADMIN_USERNAME=admin \
    -e MONGODB_ADMIN_PASSWORD=adminpass \
    -e MONGODB_APPLICATION_DATABASE=mytestdatabase \
    -e MONGODB_APPLICATION_USERNAME=testuser \
    -e MONGODB_APPLICATION_PASSWORD=testpass \
    -p 27017:27017 scrillzy/mongo-auth:latest
  ```
