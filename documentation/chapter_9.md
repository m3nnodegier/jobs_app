https://www.fastapitutorial.com/blog/creating-tables-in-fastapi/

# Creating tables in FastAPI

Before We talk about databases tables and all, I want to share a very simplistic view of FastAPI request-response cycle. A request-response cycle basically means to understand what happens in between, the browser makes a request and FastAPI sends backs a response. It is actually a very popular interview question. During my freshers' job search, I was asked this question around 90% of the time. "Explain the request-response cycle of Django?".
This will also help us where does database connection comes into play and why we need to create and connect with DB tables.

It might so happen that you don't understand Schemas, Routers, Models but don't panic. We will understand in the next posts. I just wanted to bring to your notice that we need to query data from database tables in almost all web apps.
So, let's begin to create database tables. Make sure you have this folder structure. Create the models to hold the class equivalent of DB tables.

`
(venvjobsapp) mdegier@N-20HJPF17PGRN:/mnt/c/Users/mdegier/Documents/docker_lab/fastapi/jobs_app$ tree
.
├── README.txt
├── __pycache__
│   └── main.cpython-38.pyc
├── apis
│   └── general_pages
│       ├── __pycache__
│       │   └── route_homepage.cpython-38.pyc
│       └── route_homepage.py
├── core
│   ├── __pycache__
│   │   └── config.cpython-38.pyc
│   └── config.py
├── db
│   ├── __pycache__
│   │   ├── base_class.cpython-38.pyc
│   │   └── session.cpython-38.pyc
│   ├── base_class.py
│   ├── models
│   │   ├── jobs.py
│   │   └── users.py
│   └── session.py
├── documents
│   ├── chapter_1.md
│   ├── chapter_2.md
│   ├── chapter_3.md
│   ├── chapter_4.md
│   ├── chapter_5.md
│   ├── chapter_6.md
│   ├── chapter_7.md
│   ├── chapter_8.md
│   └── chapter_9.md
├── main.py
├── postgress
│   └── docker-compose.yml
├── requirements.txt
├── static
│   └── images
│       ├── BAO_big.png
│       ├── lenyfavicon.ico
│       └── lenyicon.png
└── templates
    ├── components
    │   └── navbar.html
    ├── general_pages
    │   └── homepage.html
    └── shared
        └── base.html
`

Type in the following code in db > models > jobs.py , type man no cheating, no copy-paste!

`
from sqlalchemy import Column, Integer, String, Boolean,Date, ForeignKey
from sqlalchemy.orm import relationship

from db.base_class import Base


class Job(Base):
    id = Column(Integer,primary_key = True, index=True)
    title = Column(String,nullable= False)
    company = Column(String,nullable=False)
    company_url = Column(String)
    location = Column(String,nullable = False)
    description = Column(String,nullable=False)
    date_posted = Column(Date)
    is_active = Column(Boolean(),default=True)
    owner_id =  Column(Integer,ForeignKey("user.id"))
    owner = relationship("User",back_populates="jobs")
`

Ok, now let's understand what we just did and why:

- Remember in the last post I told you a story that it's we use raw SQL queries like "Select * from Job". It will not work with all the databases. Because each database has a different set of protocols/rules. e.g. in Postgres " double quotes are not recognized and we have to use ' single quotes.
- We have our Base class in 'base_class.py' and we are inheriting it to have a class-based representation of tables. Each property or attribute of this class is translated into a column in the table.
- The 'title' column represents Job title and it can store strings. Its value in the table can't be NULL.
- is_active columns will be used to control if the job post will be visible on the website or not. e.g. Job posts expire in few days so we can make a logic to toggle is_active to False in 2 weeks.
- The job table will have a foreign key to the User table and these foreign keys will be used to identify who is the job poster. This will be used to authorize if a person can update/delete a job post or not.

Now, we will also type in the code to have a User table which will be used to hold users data obviously. Type in the below code in **db > models > users.py**.

`
from sqlalchemy import Column,Integer, String,Boolean, ForeignKey
from sqlalchemy.orm import relationship

from db.base_class import Base


class User(Base):
    id = Column(Integer,primary_key=True,index=True)
    username = Column(String,unique=True,nullable=False)
    email = Column(String,nullable=False,unique=True,index=True)
    hashed_password = Column(String,nullable=False)
    is_active = Column(Boolean(),default=True)
    is_superuser = Column(Boolean(),default=False)
    jobs = relationship("Job",back_populates="owner")
`

Done? Nope, 😅 we still have few configurations left. Lets put the import of all these models in one single file named **'base.py'**. It will be helpful to create all the tables at once in our web app.

`
#db > base.py
from db.base_class import Base
from db.models.jobs import Job 
from db.models.users import User
`

Ok now just one last thing. Remeber we were importing 'Base' in main.py file and creating db tables. Now we won't import Base from **base_class.py** but instead from **base.py**. So, change the import statement in **main.py** to:

`
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from core.config import settings
from apis.general_pages.route_homepage import general_pages_router
from db.session import engine
from db.base import Base      # now import Base from db.base not db.base_class

...


def create_tables():
	print("create_tables")
	Base.metadata.create_all(bind=engine)

......
`

Ok, time to restart the uvicorn server. Now, check your db tables. In case you are using SQLite use a tool named Downloads - DB Browser for SQLite (sqlitebrowser.org). Postgres guys refresh the tables in PgAdminDownload (pgadmin.org) and you should see the tables.

`
(venvjobsapp) mdegier@N-20HJPF17PGRN:/mnt/c/Users/mdegier/Documents/docker_lab/fastapi/jobs_app$ uvicorn main:app --reload
INFO:     Will watch for changes in these directories: ['/mnt/c/Users/mdegier/Documents/docker_lab/fastapi/jobs_app']
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process [15195] using StatReload
create_tables
INFO:     Started server process [15197]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
`