## HOTWIRE_CHAT

### Description:
Simple chat with Hotwire. Implemented in Ruby 3.2.2, using Rails 7.0.5 and PostgreSQL 13.
In this version of the application:
- The user can only create an account. There is no possibility to edit or delete a user.
- There is no Authorization. Each user can create a room and send a message to any room or send a private message to any user, including themselves.
- There is also a feature that allows sending one message to multiple chats (rooms and/or users) simultaneously.

### Launching:
Install docker and docker-compose. Download or clone repo. From project folder run commands (in some cases, it is necessary to repeat the last command):

    $ cp .env.example .env
    $ docker-compose up --build
    $ docker-compose up

Currently, the database does not have an external port. If necessary, please add it to the docker-compose.

Also, to run the project on a port other than 3000, change it in the .env file.

### License:
MIT – see ```LICENSE```
