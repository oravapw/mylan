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

## Quick setup for development

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
mode.

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
