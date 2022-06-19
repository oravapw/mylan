# Development dockerfile, for use with docker compose (mount app from current dir)

# stage 1: build gems

FROM ruby:3.1.2-alpine AS build-base

ARG APP_DIR=/app

RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    git build-base mysql-dev tzdata && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

COPY Gemfile Gemfile.lock ./

RUN gem update --system && \
    gem install bundler && \
    bundle install
# no need for yarn install, since we are mounting app from user dir anyway

# stage 2: development environment

FROM ruby:3.1.2-alpine

ARG APP_DIR=/app

ARG USER_ID=1000
ARG GROUP_ID=1000

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# just include the stuff we want at runtime
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    mysql-dev tzdata bash && \
    rm -rf /var/cache/apk/* 

WORKDIR $APP_DIR

# copy gems built by first stage
COPY --from=build-base $GEM_HOME $GEM_HOME

RUN gem update --system && \
    gem install bundler

# don't run as root, build a "rails" user + group and use those
RUN addgroup --gid $GROUP_ID rails && \
    adduser -D -g 'Rails pseudouser' -u $USER_ID -G rails rails && \
    chown -R rails:rails $APP_DIR

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

USER $USER_ID

EXPOSE 3000

# default command is Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
