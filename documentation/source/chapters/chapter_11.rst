11. Dockerize the application and database
=========================================
no links

# Dockerize the application and database

# additional configuration - move everything to docker

Create Dockerfile to define the application image

In the home directory create two files: Dockerfile and docker-compose.yaml.

``
#  Start from the official Python base image.
FROM python:3.9

# Set the current working directory to /app.
# This is where we'll put the requirements.txt file and the app directory.
WORKDIR /app

# Copy the file with the requirements to the /app directory.
# Copy only the file with the requirements first, not the rest of the code.
# As this file doesn't change often, Docker will detect it and use the cache for this step, enabling the cache for the next step too.

COPY ./requirements.txt /app/requirements.txt

# Install the package dependencies in the requirements file.
# The --no-cache-dir option tells pip to not save the downloaded packages locally, as that is only if pip was going to be run again to install the same packages, but that's not the case when working with containers.
# The --upgrade option tells pip to upgrade the packages if they are already installed.
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Copy the ./app directory inside the /app directory.
# As this has all the code which is what changes most frequently the Docker cache won't be used for this or any following steps easily.
# So, it's important to put this near the end of the Dockerfile, to optimize the container image build times.

# Deploymnet: COPY ./app /code/app
# Development: don't copy, but mount to container for development <- this option, see docker-compes.yaml>

# Set the command to run the uvicorn server.
# CMD takes a list of strings, each of these strings is what you would type in the command line separated by spaces.
# This command will be run from the current working directory, the same /code directory you set above with WORKDIR /code.
# Because the program will be started at /code and inside of it is the directory ./app with your code, Uvicorn will be able to see and import app from app.main.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80","--reload"]
``

The Docker-compose file:

``
version: '3.8'
services:
  db:
    container_name: database
    image: postgres
    restart: always
    environment:
      POSTGRES_USER: mdegier
      POSTGRES_PASSWORD: mdegier
      POSTGRES_DB: test_db
      PGDATA: /var/lib/postgresql/data
    networks: 
      - backend
    volumes:
        - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
      
  pgadmin:
    container_name: dbadmin
    image: dpage/pgadmin4
    restart: always
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: root
    ports:
      - "8082:80"
    networks: 
      - backend
    volumes:
      - pgadmin-data:/var/lib/pgadmin

  app:
    build: .      
    container_name: appjobs
    ports: 
       - "8000:80"
    networks: 
      - backend
    volumes: 
       - ./:/app
    depends_on:
      - db

networks:
  backend:

volumes:
  db-data:
      name: postgress_db_data
  pgadmin-data:
      name: pg_db_admindata
#  $ docker volume ls
#  DRIVER    VOLUME NAME
#  local     pg_db_admindata
#  local     postgress_db_data
#  $
``

Start the creationof the application image and docker files:

``
docker-compose up -d --build
``

This will do the following:
- downlaod the required docker images for postgres, pgadmin and python
-  build the application image base upon the pyton image as specified in the Dockerfile
-  Docker must have something to do, otherwise the docker-app will stop. The last entry in the Dockerfile is a run command to start uvicorn. We are using the --reload option to make the application restart itself when there is a change in the code.
-  The application folder is mounted to the docker container 
-  There is a backend network to connect everuthing together and only the exposed ports are reachable from outside.

To see what happening in the app use the following:

``
docker log appjobs -f
``

Access the application from browser:
http://127.0.0.1:8000/
Access db from pgAdmin:
http://127.0.0.1:8082/
With parameters: 
- host-name: db (will be resolved by docker)
- port: 5432 (default)
- username and password: as specified in Docker-compose file
- datebase: as specified in the Docker-compose file

Also modify the .env to use the postgres hostname instead of ip address

``
POSTGRES_USER=mdegier
POSTGRES_PASSWORD=mdegier
POSTGRES_SERVER=db   # use hostname instead of 127.0.0.1 or localhost
POSTGRES_PORT=5432
POSTGRES_DB=test_db
``

to stop everything:

``
$ docker-compose down
Stopping appjobs  ... done
Stopping dbadmin  ... done
Stopping database ... done
Removing appjobs  ... done
Removing dbadmin  ... done
Removing database ... done
Removing network jobs_app_backend
$
``


Last thing-> save to git !!!!!!!!