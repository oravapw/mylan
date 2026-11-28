# syntax=docker/dockerfile:1
# check=error=true

# development image

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=4.0.10

FROM docker.io/library/ruby:$RUBY_VERSION-alpine AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    postgresql18-client tzdata bash jemalloc curl vips && \
    rm -rf /var/cache/apk/* 

# Set environment variables and enable jemalloc for reduced memory usage and latency.
ENV BUNDLE_PATH="/usr/local/bundle" \
    LD_PRELOAD="/usr/lib/libjemalloc.so.2" \
    LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    git build-base postgresql18-dev tzdata jemalloc yaml-dev && \
    rm -rf /var/cache/apk/* 

# Install application gems
COPY Gemfile Gemfile.lock ./

RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Final stage for app image
FROM base

# Run and own only the runtime files as a non-root user for security
RUN addgroup --gid 1000 rails && \
    adduser -D -g 'Rails pseudouser' -u 1000 -G rails rails && \
    chown -R rails:rails /rails
USER 1000:1000

# Copy built artifacts
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
