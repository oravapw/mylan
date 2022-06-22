# Helpers for Docker

.PHONY: all build clean imageclean migrate rollback console websh dbsh db dbec dbroot creddev credprod

all: build

# build image(s)
build:
	docker compose build

# remove stopped Docker containers
clean:
	docker rm `docker ps -q -a`

# remove non-referenced images
imageclean:
	docker image prune -f

# Run Rails migrations
migrate:
	docker compose exec web bundle exec rake db:migrate

# Run Rails migration rollback
rollback:
	docker compose exec web bundle exec rake db:rollback

# Rails console in web container
console:
	docker compose exec web bundle exec rails c

# Shell in web container
websh:
	docker compose exec web /bin/bash

# Shell in db container
dbsh:
	docker compose exec db /bin/bash

# Mysql client connected to dev database
db:
	docker compose exec db mysql -umylan -pmylan mylan_dev

# Mysql client connected to EC data dev database
dbec:
	docker compose exec db mysql -umylan -pmylan ecdata_dev

# Mysql client connected to root
dbroot:
	docker compose exec db mysql -uroot -proot

# Edit/view development secrets
creddev:
	./bin/rails credentials:edit --environment development

# Edit/view production secrets
credprod:
	./bin/rails credentials:edit --environment production
