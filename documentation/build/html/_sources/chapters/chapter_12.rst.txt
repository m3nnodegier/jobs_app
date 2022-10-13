12. Understanding Dependencies in FastAPI
=========================================

https://www.fastapitutorial.com/blog/dependencies-in-fastapi/

Dependency injection is a beautiful concept. I won't torture you with big words, let's understand it with a simple example. You should be knowing that we use a test database to run our unit test and a production/development database. Can you imagine what would happen if we use the same database everywhere? Yes, our database will become a mess in few weeks! It would be filled up with useless emails like - test@example.com, mycutetest@test.com, and so on!

When we will be creating our logic to create a user, we would need to decouple our database settings and not hardcode it. During test, we would want a different database and during development/production our DB would be completely different and this can be achieved by using dependency injection. For this we would create a dependency called 'get_db' this would guide our database connection. During unit testing, we would override this 'get_db' dependency and we would get connected to some other test database. Now, I think you should have understood it to some extent. Now let's type in the below code in **db > session.py**

