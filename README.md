# README

This is a quick and dirty app to help with VTES EC2022 tournament management. This is currently a specialized one-off app,
but may grow into a more general tool later.

Rails 7, with support for local develoment with Docker Compose and
production deploy with Capistrano. Database data is stored in named
Docker data volume, app data is mounted from current dir for easy
development.

Most credentials are in Rails encrypted credentials store, the copy
included here (config/credentials.yml.enc) is my own setup (without
config/master.key of course), you will need to remove it and provide
your own (see below).

## Quick setup for development

1. Remove config/credentials.yml.enc, run "rails credentials:edit"

2. Update the credentials to conform with
config/credentials.yml.example, keeping your Rails-generated secret
key and adding the database details with whatever passwords you want
to use. For development, just using the default user and password of
"mylan" should be fine.

3. Run "make build", this will build & load the Docker images.

4. Run "docker compose up"

5. Once Docker Compose has started up everything, run "make dbroot"
with the following SQL:

```
CREATE DATABASE ecdata_dev;
CREATE DATABASE mylan_dev;
CREATE DATABASE mylan_test;
CREATE USER mylan@'%' IDENTIFIED BY 'mylan';
GRANT ALL ON *.* TO mylan@'%';
```
6. Run "make migrate"

7. Connect to localhost:3000
