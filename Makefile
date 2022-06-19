# Helpers for Docker

.PHONY: all build clean imageclean console websh dbsh db dbec dbroot

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
