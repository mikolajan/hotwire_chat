## HOTWIRE_CHAT

### Description:
Simple chat with Hotwire. Implemented in Ruby 3.2.2, using Rails 7.0.5 and PostgreSQL 13.
In this version of the application:
- Еhe user can only create an account. There is no possibility to edit or delete a user.
- There is no Authorization. Each user can create a room and send a message to any room or send a private message to any user, including themselves.
- There is also a feature that allows sending one message to multiple chats (rooms and/or users) simultaneously.

### Launching:
Install docker and docker-compose. Download or clone repo. From project folder run commands:

    $ cp .env.example .env
Add postgress data to .env file

    $ docker-compose up

After start containers run commands to run migrations and build assets:

    $ docker-compose exec app bundle exec rails db:migrate
    $ docker-compose exec app yarn build
    $ docker-compose exec app yarn build:css
### License:
MIT – see ```LICENSE```
