# README

Mylan is a VTES tournament organization helper, covering player registration
both beforehand and on site, and generating randomized input for Archon when all
players are registered. Actual tournament score tracking is done via
Archon as normal, this app is intended to cover everything before that.

This was originally a specialized one-off app for managing the Finnish EC2020
registration and tournaments, but has later been expanded into a more general-use
tournament organizer tool. The app currently only has one (shared) user account, and
is intended for a small local group of tournament organizers. For example,
here in Finland I run an instance on my server and all local Princes
have access to it.

The app is written with Ruby on Rails, and requires a PostgreSQL database. 
Local development is via Docker Compose which runs Rails and PostgreSQL in
containers, production deploy is via a configurable Docker image 
which can be deployed in various ways (see below).

Feel free to try this out, and let me know if you run into bugs
or have some improvement ideas. I'm "Orava" on the official VTES Discord,
and email to orava@iki.fi also works.

-Petri "Orava" Wessman

## Quick setup for development with Docker

Here I'm assuming you're on MacOS or Linux, I have no idea how any of this would work on Windows.

You'll need to have Docker installed and running, a local copy of Ruby matching the 
current code version (4.0.10 as of this writing), npm/yarn, and various Unix-style dev tools
(make, etc).

1. "bundle install; yarn install"

2. Run "make build", this will build & load the development Docker images.

3. Run "docker compose up", this should start up the web and db
containers. Web will fail because databases are missing, ignore that.

4. Once Docker Compose has started up everything, run "make dbroot"
and then run the following SQL (this sets up according to development
credentials as shown in step 1).

```
CREATE ROLE mylan PASSWORD 'mylan' NOSUPERUSER CREATEDB INHERIT LOGIN;
CREATE DATABASE mylan_dev OWNER mylan;
CREATE DATABASE mylan_test OWNER mylan;
GRANT ALL PRIVILEGES ON DATABASE mylan_test, mylan_dev TO mylan;
```

5. Shut down the docker compose instance.

6. Run "./bin/dev". This (re)starts docker compose along with
on-the-fly compilation of CSS and Javascript when those change.

7. Connect to localhost:3000, where you should see the app login
screen. Type in login credentials (see below), and you should see the
main overview tab.

After this, start coding. The app is live-mounted into the Docker container,
so any file changes will be reflected in the running app immediately.
If you make any changes that affect the Docker build (changes to `Gemfile`, for example),
you'll need to generate a new image with `make`.

## Database

From version 1.1.0 onwards, Mylan uses PostgreSQL (older versions use MySQL). Changing the
code to use something else is fairly straightforward:

- replace the `pg` gem in `Gemfile` with the appropriate driver
- modify `config/database.yml`
- change the `like` method in `app/controllers/application_controller.rb` to generate a case-insensitive LIKE statement suitable for the database.
- (optional) modify the db-oriented helper targets in the `Makefile`

If there is need for it, I can maintain a separate "mysql" branch, but I'll only do that if someone actually needs it. Let me know.

### Database migration

If you have been running older (MySQL) Mylan and want to move the data to PostgreSQL, here's how you do that fairly easily:

1. With version 1.0.5 or 1.0.6 running, run this command in a separate terminal. This assumes mylan runs as "mylan" in the container, modify if not. This exports the current (MySQL) database in JSON format into the local file `export.json`. 

> `docker compose exec mylan ./bin/rails runner script/json_export.rb >export.json`

2. Shut down the older Mylan (and MySQL), start up PostgreSQL and initialize the databases (`mylan`, `mylan_cache`, `mylan_queue`, `mylan_cable`), and then also start up the latest version of Mylan. Make sure Mylan starts up normally and creates the (empty) database tables `tournaments`, `players`, and `tournament_players`.

3. Copy the data export JSON to the Mylan container.
 > `docker compose cp export.json mylan:.`
 
4. Import the JSON into the PostgreSQL database. Mylan should be operational with the old data intact after this.
> `docker compose exec mylan ./bin/rails runner script/json_import.rb export.json`

## Configuration

Configuration is via environment variables. In development, the file 
`env-template` is copied to `.env.development` (not saved to Git),
modify that to suit your preferences.

In production, these variables will need to be set via your Docker deploy
mechanism (via `environment:` in `docker-compose.yml`, for example).

The variables supported are:

- `LOGIN_USERNAME` - user account username (required)
- `LOGIN_PASSWORD` - user account username (required)
- `DB_HOST` - database host (required)
- `DB_USER` - database user name (required)
- `DB_PASSWORD` - database password (required)
- `TIME_ZONE` - Ruby name of local timezone, see rake time:zones for list (optional, but timestamps will be shown in UTC if not set)
- `SMTP_ADDRESS` - outgoing mail server host (optional, if not set email sending will be disabled)
- `EMAIL_FROM` - email address to show as sender of messages (optional)
- `RAILS_RELATIVE_URL_ROOT` - subpath app will be mounted under (required unless mounting at host root)
- `SECRET_KEY_BASE` - Rails secret key, generate with `rails secret` (required for production images)
- `SOLID_QUEUE_IN_PUMA` - set this (to something) to have Puma also
  start up Solid Queue, needed for background email sends in
  production. If you don't set this, you'll have to start up Solid
  Queue some other way.

In addition to the above, all configuration keys supported
by `config.action_mailer.smtp_settings` (see
[documentation](https://guides.rubyonrails.org/configuring.html#configuring-action-mailer))
are supported as follows: for any variable beginning with `SMTP_`, that portion is
removed and the rest is converted to lowercase. As an example,
key `SMTP_PORT` would set the `port` mailer setting.

## Deployment

Production deployment is via Docker, via whatever facility you have available.
I use a simple Docker Compose setup myself, but there are lots of options. 

### Using pre-built images

The simplest option is to simply pull a pre-built image from
[my DockerHub repository](https://hub.docker.com/r/petriwessman/mylan).

### Database setup

In production mode, Mylan requires the following databases to exist:

- `mylan`
- `mylan_cache`
- `mylan_queue`
- `mylan_cable`

The last 3 are for Rails 8+ db-backed facilities. Only `mylan_queue` is used at the moment (for email sending via Solid Queue), but all databases need to exist.

### Docker Compose

As an example, I use something like this to run the app in production. 

```
services:

  mylan:
    image: petriwessman/mylan:(version)
    restart: unless-stopped
    environment:
      DB_HOST: pg
      DB_USER: (username)
      DB_PASSWORD: (password)
      LOGIN_USERNAME: (username)
      LOGIN_PASSWORD: (password)
      TIME_ZONE: Helsinki
      SMTP_ADDRESS: (SMTP provider outgoing server)
      SMTP_PORT: (SMTP port number)
      SMTP_USER_NAME: (SMTP provider user name)
      SMTP_PASSWORD: (SMTP provider password)
      EMAIL_FROM: (my "from" address)
      SECRET_KEY_BASE: (my secret key)
      RAILS_RELATIVE_URL_ROOT: /mylan
      SOLID_QUEUE_IN_PUMA: yes
    ports:
      - "3000:3000"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/mylan/up"]
      interval: 30s
      timeout: 10s
      retries: 3
    depends_on:
      pg:
        condition: service_healthy

  pg:
    image: postgres:18-alpine
    restart: unless-stopped
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: (master password)
      PGDATA: /var/lib/postgresql/data/18/pgdata
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 10s
      timeout: 5

volumes:
  pgdata:
```

This is for mounting the app at `my.server.net/mylan`, and needs the front-end 
proxy (Apache, Nginx, whatever) to proxy & reverse-proxy 
`/mylan http://localhost:3000/mylan` (i.e. pass the relative url root to
the container).

If mounting at server root, you would just remove `RAILS_RELATIVE_URL_ROOT` 
from the config and proxy everything to `http://localhost:3000`.

## Future plans / TODO

There are no guarantees that any of these will actually happen.

- Support for actual user accounts (and possibly user groups), instead of just one shared "admin" account. This would be quite a bit of work.
- Update CSS to Bulma 1.x. A drop-in replacement attempt broke everything, so this probably needs a bit of tinkering.
