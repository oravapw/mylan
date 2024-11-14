# syntax=docker/dockerfile:1
# check=error=true

# Development dockerfile, for use with docker compose (mount app from current dir)

# stage 1: build gems

ARG RUBY_VERSION=3.3.6

FROM ruby:$RUBY_VERSION-alpine AS build-base

WORKDIR /rails

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    git build-base mysql-dev tzdata jemalloc && \
    rm -rf /var/cache/apk/* 

COPY Gemfile Gemfile.lock ./

RUN gem update --system && \
    gem install bundler && \
    bundle install
# no need for yarn install, since we are mounting app from user dir anyway

# stage 2: development environment

FROM ruby:$RUBY_VERSION-alpine

WORKDIR /rails

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# just include the stuff we want at runtime
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    mysql-dev tzdata bash jemalloc && \
    rm -rf /var/cache/apk/* 

# copy gems built by first stage
COPY --from=build-base $GEM_HOME $GEM_HOME

RUN gem update --system && \
    gem install bundler

COPY ./bin/docker-entrypoint /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint
ENTRYPOINT ["/usr/bin/docker-entrypoint"]

# don't run as root, build a "rails" user + group and use those
RUN addgroup --gid 1000 rails && \
    adduser -D -g 'Rails pseudouser' -u 1000 -G rails rails && \
    chown -R rails:rails /rails
USER 1000:1000

# default command is Rails server
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
