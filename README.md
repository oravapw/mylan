# README

Mylan is a VTES tournament organization helper, covering player registration
both beforehand and on site, and generating randomized input for Archon when all
players are registered. Actual tournament score tracking is done via
Archon as normal, this app is intended to cover everything before that.

This was originally a specialized one-off app for managing EC2020
registration and tournaments, but has later been expanded into a more general-use
tournament organizer tool. The app currently only has one (shared) user account, and
is intended for a small local group of tournament organizers. For example,
here in Finland I run an instance on my server and all local Princes
have access to it.

The app is written with Ruby on Rails, and requires a MySQL database. 
Local development is via Docker Compose which runs Rails and MySQL in
containers, production deploy is via a configurable Docker image 
which can be deployed in various ways (see below).

Feel free to try this out, and let me know if you run into bugs
or have some improvement ideas. I'm "Orava" on the official VTES Discord,
and email to orava@iki.fi also works.

-Petri "Orava" Wessman

## Quick setup for development with Docker

Here I'm assuming you're on MacOS or Linux, I have no idea how any of this would work on Windows.

You'll need to have Docker installed, a local copy of Ruby matching the 
current code version (3.3.6 as of this writing), npm/yarn, and various Unix-style dev tools
(make, etc).

1. "bundle install; yarn install"

2. Run "make build", this will build & load the development Docker images.

3. Run "docker compose up", this should start up the web and db
containers. Web will fail because databases are missing, ignore that.

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
connect to the web container and run "rake db:migrate" there.

6. Shut down the docker compose instance.

7. Run "./bin/dev". This (re)starts docker compose along with
on-the-fly compilation of CSS and Javascript when those change.

8. Connect to localhost:3000, where you should see the app login
screen. Type in login credentials (see below), and you should see the
main overview tab.

After this, start coding. The app is live-mounted into the Docker container,
so any file changes will be reflected in the running app immediately.
If you make any changes that affect the Docker build (changes to `Gemfile`, for example),
you'll need to generate a new image with `make`.

### Note on databases

Mylan uses MySQL partly for historical reasons -- the original app needed to also access
another database which was already on MySQL. That said, MySQL is good enough for this, 
and there are no current plans to swich database engines.

However, if you want to run it on something else (PostgreSQL, for example) 
and are willing to tinker a bit, it should be fairly straightforward. 
All database access in the app is via ActiveRecord and there is no
hard-coded SQL. You'll need to change the following:

- replace the `mysql2` gem in `Gemfile` with the appropriate driver
- modify `config/database.yml`
- (optional) modify the db-oriented helper targets in the `Makefile`

This has not been tested, so there may be "gotchas" lurking in there.

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

The last 3 are for Rails 8+ db-backed facilities which Mylan does not currently 
use but are there for future-proofing. The databases need to exist, but they will
remain empty for now.

### Docker Compose

As an example, I use something like this to run the app in production. 
The app talks to a MySQL instance running on localhost, but another
option would be to also run MySQL as a Docker image.

```
services:

  mylan:
    image: petriwessman/mylan:1.0.0
    environment:
      DB_HOST: docker.localhost
      DB_USER: (username)
      DB_PASSWORD: (password)
      LOGIN_USERNAME: (username)
      LOGIN_PASSWORD: (password)
      TIME_ZONE: Helsinki
      SMTP_ADDRESS: (my email server)
      EMAIL_FROM: noreply@orava.org
      SECRET_KEY_BASE: (my secret key)
      RAILS_RELATIVE_URL_ROOT: /mylan
    ports:
      - "3000:3000"
    extra_hosts:
      - "docker.localhost:172.17.0.1"
```

This is for mounting the app at `my.server.net/mylan`, and needs the front-end 
proxy (Apache, Nginx, whatever) to proxy & reverse-proxy 
`/mylan http://localhost:3000/mylan` (i.e. pass the relative url root to
the container).

If mounting at server root, you would just remove `RAILS_RELATIVE_URL_ROOT` 
from the config and proxy everything to `http://localhost:3000`.

### Building your own production images

The `Makefile` has some helpers.

`make image` builds a production image tagged with the version found
in file VERSION plus "latest".

`DOCKERHUB=your-dockerhub-account make push` pushes the above two images
to your Docker Hub repo.

## Future plans / TODO

There are no guarantees that any of these will actually happen :)

- Support for actual user accounts (and possibly user groups), instead of just one shared "admin" account. This would be quite a bit of work.
- Add some Capybara tests for the UI (yes, this should have been in at the beginning, but wasn't due to the original use case and timetable).
- Update CSS to Bulma 1.x. A drop-in replacement attempt broke everything, so this probably needs a bit of tinkering.
