# https://www.fastapitutorial.com/blog/database-connection-fastapi/

# FastAPI Connecting to a Database

Super, So, far we have done a lot. Now, its time to add persistence. We are going to connect a database to our app. I am opting for PostgreSQL. I would suggest you to try out Postgres as it is a production-grade db. If you already have it, well and good, If not, download Postgres and PgAdmin(for monitoring Postgres). In case you just want to play and learn on your local computer, You may skip downloading Postgres. We can use SQLite, It is a file system based, easy-to-use database and is supported by python.

We will be using an ORM called sqlalchemy, ORM is a mapper which helps translate our database table records to a class object. To understand the benefit of it, I will actually tell, what happens if we don't use ORM. Most of the time, I have the responsibility of backend development in Django but sometimes I am given the responsibility of assignment verification for hiring. There was one student say 'John wick', he had made a wonderful UI and the assignment was working all fine but as a backend developer, I wanted to test his backend logic and test some corner cases, I started to install his project but there was a problem. He had used raw MySQL, and my machine did not have MySQL installed. In case he had used an ORM e.g. Django ORM, the ORM would handle the responsibility of translating DB queries to different databases. Thats why I am stressing for an ORM.

Ok let's add the following lines in requirements.txt: and run pip install -r requirements.txt

`
fastapi
uvicorn

#for template
jinja2

#for static files
aiofiles

#for database   #new
sqlalchemy         
psycopg2-binary

#for loading environment variables  #new
python-dotenv
`