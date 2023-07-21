## HOTWIRE_CHAT

### Description:
Simple chat with Hotwire. Implemented in Ruby 3.2.2, using Rails 7.0.5 and PostgreSQL 13.
In this version of the application:
- Еhe user can only create an account. There is no possibility to edit or delete a user.
- There is no Authorization. Each user can create a room and send a message to any room or send a private message to any user, including themselves.
- There is also a feature that allows sending one message to multiple chats (rooms and/or users) simultaneously.

### Launching:
Download or clone repo. Install docker and docker-compose.

    $ docker-compose up
### License:
MIT – see ```LICENSE```
