FROM ruby:3.1.3

LABEL maintainer="matt@haliski.com"

# First, make sure to run update and install in a one-liner to avoid
# using older cached versions.
# Second, it's convention to list the installs one per line and alphabetical.
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim

# Copy the Gemfile and Gemfile.lock over first (and separately) from the other files to
# eliminate triggering a cache-invalidation and reinstalling all gems. Doing
# this creates a separate layer.
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install

# Copy the rest of the project files into the image
COPY . /usr/src/app/

# Start rails and bind to 0.0.0.0
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
