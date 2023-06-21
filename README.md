# README

Mylan is a VTES tournament organization helper, covering registration
both beforehand (work in progress) and on site, and generating input
for Archon when all players are registered. Actual tournament score
tracking is done via Archon as normal, this app is intended for
generating the initial filled-in Archon spreadsheet as easily as
possible.

This was originally a specialized one-off app for managing EC2020
registration and tournaments, but is now being changed into a more
general tool.  Access control is currenty a single username + password
pair, all tournament judges will use the same access credentials. I
may add proper user accounts later, we'll see.

I don't expect other people to find much use for this source code at
the moment, but in case you want to try it out for whatever reason,
read on.

Builts with Rails 7, with support for local develoment with Docker
Compose (with either mysql running in Docker or an external mysql
running on localhost) and production deploy with Capistrano. By
default developent database data is stored in a named Docker data
volume, app code is mounted from current dir for easy development.

## Quick setup for development

This assumes you want to use the Docker-embedded mysql version, which
is the easiest way to get started.

1. "cp docker-compose-int-mysql.yml docker-compose.yml"

1. Run "rails credentials:edit --environment development". This will
display the development credentials settings, because here we actually
include the secret key (config/credentials/development.key) in source
control. All those credentials are for private sandboxed Docker
development environment, so it is more convenient this way. Keep this
editor window open for reference.

2. If you want to deploy to production, you'll need to set up
production credentials. Remove config/credentials/production.yml.enc
and run "rails credentials:edit --environment production". This will
produce a new credentials file, with newly generated secret key
base. Copy over the configuration from the development configuration
(except secret_key_base), and change credentials to something suitable
for production. You can skip this step if only running in development
mode. Production deployment via Capistrano is included here, but I am
not going to be covering that here.

3. "bundle install; yarn install"

4. Run "make build", this will build & load the Docker images.

5. Run "docker compose up", this should start up the web and db
containers. Mariadb will create a new empty database on first run.

6. Once Docker Compose has started up everything, run "make dbroot"
and then run the following SQL (this sets up according to development
credentials as shown in step 1).

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

8. Run "./bin/dev" on another terminal to get on-the-fly compilation
of CSS and Javascript when those change.

9. Connect to localhost:3000, where you should see the app login
screen. Type in login credentials as shown in step 1, and you should
see the main overview tab.
