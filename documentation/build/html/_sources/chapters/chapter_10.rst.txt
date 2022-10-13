10. Creating Schemas in Fastapi
==============================
https://www.fastapitutorial.com/blog/schemas-in-fastapi/



Remember the request-response cycle in the previous post? Ok, let's revise, A schema is used to validate data we receive as well as to reformat the data that we want to send to the client/browser. Suppose, we want to receive a JSON like {'username':'testuser','email':'testuser@nofoobar.com','password':'testing'} but there is no way we ca trust  our users. Our users may send anything they want and we don't want to store it without verifying. e.g. {'username':'testuser','email':'1234','password':'testing'} Notice here email is 1234, in such cases, we want to notify our users that we can't store such shit ! For this, we can go the hard way but we have Pydantic for our rescue. We create pydantic classes that verify the types and these classes are called Schemas. Let's jump into it and see it in action. Before that let's create files and folders to hold schemas.

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
│   │   ├── base.cpython-38.pyc
│   │   ├── base_class.cpython-38.pyc
│   │   └── session.cpython-38.pyc
│   ├── base.py
│   ├── base_class.py
│   ├── models
│   │   ├── __pycache__
│   │   │   ├── jobs.cpython-38.pyc
│   │   │   └── users.cpython-38.pyc
│   │   ├── jobs.py
│   │   └── users.py
│   └── session.py
├── documentation
│   ├── chapter_1.md
│   ├── chapter_10.md
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
├── schemas
│   ├── jobs.py
│   └── users.py
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

19 directories, 37 files
(venvjobsapp) mdegier@N-20HJPF17PGRN:/mnt/c/Users/mdegier/Documents/docker_lab/fastapi/jobs_app$ 
`

Now, it's time to create the pydantic classes i.e. schemas. Let's start with users schemas. Type in the following code in **schemas > users.py**

`
from typing import Optional
from pydantic import BaseModel,EmailStr


#properties required during user creation
class UserCreate(BaseModel):
    username: str
    email : EmailStr
    password : str
`

Let's understand this dark magic! We are inheriting BaseModel from pydantic. It empowers fastapi to suggest validation errors to users. In this case, whenever we want to create a user, we will receive data in JSON format where the username will be verified to be a string, the email will be verified to be in proper mail format and the password will be validated to be a string.

Because we are trying to use EmailStr from pydantic we need to install this service first. Let's add pydantic[email] to our requirements.txt file and install all requirements by pip install -r requirements.txt.

`
#for loading environment variables
python-dotenv

#for email validation            #new
pydantic[email] 
`

Schemas will be clearer when we will use schemas in our routes.

See next will be to understand the schema's, but first the dependencies


