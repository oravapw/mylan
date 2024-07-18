# README

Mylan is a VTES tournament organization helper, covering registration
both beforehand and on site, and generating input for Archon when all
players are registered. Actual tournament score tracking is done via
Archon as normal, this app is intended for generating the initial
filled-in Archon spreadsheet as easily as possible.

This was originally a specialized one-off app for managing EC2020
registration and tournaments, but is now being changed into a more
general tool.  Access control is currently a single username + password
pair, all tournament judges will use the same access credentials. I
may add proper user accounts later, we'll see.

I don't expect other people to find much use for this source code at
the moment, but in case you want to try it out for whatever reason,
read on.

Built with Rails 7, with support for local development with Docker
Compose (with mysql also running in Docker) and production deploy with
Capistrano. Default development database data is stored in a named
Docker data volume, app code is mounted from current dir for easy
development.

## Quick setup for development with Docker

1. "bundle install; yarn install"

2. Run "make build", this will build & load the Docker images.

3. Run "docker compose up", this should start up the web and db
containers. Mariadb will create a new empty database on first run.

4. Once Docker Compose has started up everything, run "make dbroot"
and then run the following SQL (this sets up according to development
credentials as shown in step 1).

```
CREATE DATABASE mylan_dev;
CREATE DATABASE mylan_test;
CREATE USER mylan@'%' IDENTIFIED BY 'mylan';
GRANT ALL ON *.* TO mylan@'%';
```

5. Run "make migrate". If everything is set up correctly, this should
connect to the web container and run "rake db:migrate" there,
connecting to the database in the "db" container.

6. Shut down the docker compose instance.

7. Run "./bin/dev". This (re)starts docker compose along with
on-the-fly compilation of CSS and Javascript when those change.

8. Connect to localhost:3000, where you should see the app login
screen. Type in login credentials (see below), and you should see the
main overview tab.

## Credentials management

To see credentials, run "rails credentials:edit --environment
development". This will display the development credentials settings,
because here we actually include the secret key
(config/credentials/development.key) in source control. All those
credentials are for private sandboxed Docker development environment,
so it is more convenient this way. Keep this editor window open for
reference.

If you want to deploy to production, you'll need to set up production
credentials. Remove config/credentials/production.yml.enc and run
"rails credentials:edit --environment production". This will produce a
new credentials file, with newly generated secret key base. Copy over
the configuration from the development configuration (except
secret_key_base), and change credentials to something suitable for
production. You can skip this step if only running in development
mode. Production deployment setup via Capistrano is included in the
source, but I am not going to be documenting that here.

## Future plans / TODO

This app, like most, is a work in progress. Things I may
implement/change when I have time include:

- support for actual user accounts (and possibly user groups), instead of just one shared "admin" account.
- move away from Rails credential storage to .env (more convenient in most situations imho)
- figure out a production setup with docker (compose), Capistrano can be a bit fragile
- update to latest Rails (7.1.x as of this writing)
- add some Capybara tests for the UI (yes, this should have been in at the beginning, but wasn't due to the original use case and timetable)
- add button to (re)send registration email to a player (on tournament player list view)
