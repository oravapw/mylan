# README

This is a quick and dirty app to help with VTES EC2022 tournament
player management.

This is currently a specialized one-off app, but may grow into a more
general tool later. Access control is a single username + password
pair, all tournament judges will use the same access credentials.

I don't expect other people to find much use for this at the moment,
but in case you want to try it out for whatever reason, read on.

Builts with Rails 7, with support for local develoment with Docker
Compose and production deploy with Capistrano. Developent database
data is stored in a named Docker data volume, app code is mounted from
current dir for easy development.

Most credentials are in Rails encrypted credentials store, the copy
included here (config/credentials.yml.enc) is my own setup (without
config/master.key of course), you will need to remove it and provide
your own (see below).

## Quick setup for development

1. Remove config/credentials.yml.enc, run "rails credentials:edit"

2. Update the credentials to conform with
config/credentials.yml.example, keeping your own Rails-generated secret
key and adding the database details with whatever passwords you want
to use. For development, just using the default user and password of
"mylan" should be fine.

3. "bundle install; yarn install"

4. Run "make build", this will build & load the Docker images.

5. Run "docker compose up", this should start up the web and db
containers. Mariadb will create a new empty database on first run.

6. Once Docker Compose has started up everything, run "make dbroot"
and then run the following SQL:

```
CREATE DATABASE ecdata_dev;
CREATE DATABASE mylan_dev;
CREATE DATABASE mylan_test;
CREATE USER mylan@'%' IDENTIFIED BY 'mylan';
GRANT ALL ON *.* TO mylan@'%';
```

7. Run "make migrate". If everything is set up correctly, this should
connect to the web container and run "rake db:migrate" there,
connecting to the database in the "db" container.

8. Connect to localhost:3000, where you should see the app main page.

9. Run "./bin/dev" on another terminal to get on-the-fly compilation
of CSS and Javascript when those change.
