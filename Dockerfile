#  Start from the official Python base image.
FROM python:3.9

# Set the current working directory to /code.
# This is where we'll put the requirements.txt file and the app directory.
WORKDIR /app

# Copy the file with the requirements to the /code directory.
# Copy only the file with the requirements first, not the rest of the code.
# As this file doesn't change often, Docker will detect it and use the cache for this step, enabling the cache for the next step too.

COPY ./requirements.txt /app/requirements.txt

# Install the package dependencies in the requirements file.
# The --no-cache-dir option tells pip to not save the downloaded packages locally, as that is only if pip was going to be run again to install the same packages, but that's not the case when working with containers.
# The --upgrade option tells pip to upgrade the packages if they are already installed.
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Copy the ./app directory inside the /code directory.
# As this has all the code which is what changes most frequently the Docker cache won't be used for this or any following steps easily.
# So, it's important to put this near the end of the Dockerfile, to optimize the container image build times.

# Deploymnet: COPY ./app /code/app
# Development: don't copy, but mount to container for development

# Set the command to run the uvicorn server.
# CMD takes a list of strings, each of these strings is what you would type in the command line separated by spaces.
# This command will be run from the current working directory, the same /code directory you set above with WORKDIR /code.
# Because the program will be started at /code and inside of it is the directory ./app with your code, Uvicorn will be able to see and import app from app.main.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80","--reload"]

# Build Image with: docker build -t fastapimdg:1.0 .
# 1) deployment: start the container with: docker run -d --name fastapitest -p 80:80 fastapimdg:1.0
# 2) Development: docker run -d --name fastapitest -p 80:80 -v $(pwd)/app:/code/app fastapimdg:1.0
#    loging: docker logs fastapitest
