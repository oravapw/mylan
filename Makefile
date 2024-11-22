# Helpers for Docker

.PHONY: all build migrate rollback console websh dbsh db dbec dbroot env image push version release

# version tag for production image (do not set with :=, may change during run)
VERSION = $(shell cat VERSION)

# image name
IMAGE := mylan

# Docker Hub account, override this as needed with env variable
DOCKERHUB ?= petriwessman

all: build

# build image(s)
build: env
	docker compose build

# Run Rails migrations
migrate:
	docker compose exec web ./bin/rake db:migrate

# Run Rails migration rollback
rollback:
	docker compose exec web ./bin/rake db:rollback

# Rails console in web container
console:
	docker compose exec web ./bin/rails c

# Shell in web container
websh:
	docker compose exec web /bin/bash

# Shell in db container
dbsh:
	docker compose exec db /bin/bash

# Mysql client connected to dev database
db:
	docker compose exec db mysql -umylan -pmylan mylan_dev

# Mysql client connected to root
dbroot:
	docker compose exec db mysql -uroot -proot

# Build production image (versioned and same as "latest")
image:
	docker build . -t ${DOCKERHUB}/${IMAGE}:${VERSION} -t ${DOCKERHUB}/${IMAGE}:latest -f Dockerfile.production

# Push production images
push:
	docker push ${DOCKERHUB}/${IMAGE}:${VERSION}
	docker push ${DOCKERHUB}/${IMAGE}:latest

# Set new production version
version:
ifndef V
	@echo "usage: V=newversion make ..."
	@exit 1
else ifeq ($(strip ${V}), ${VERSION})
	@echo "version is already ${V}"
	@exit 1
else
	echo ${V} >VERSION
	git commit -a -m "version ${V}"
	git tag "${V}"
	@echo version set to ${V}
endif

# tag new version, build image, push it to Docker Hub
release: version image push

env: .env.development .env.test

.env.development:
	cp env-template .env.development

.env.test:
	cp env-template .env.test
