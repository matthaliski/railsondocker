ARG RUBY_VERSION=3.1.3
FROM ruby:$RUBY_VERSION

LABEL maintainer="matt@haliski.com"

# Ensure node.js 19 is available for apt-get
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -

# First, make sure to run update and install in a one-liner to avoid
# using older cached versions.
# Second, it's convention to list the installs one per line and alphabetical.
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libvips \
  nodejs \
  vim && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Copy the Gemfile and Gemfile.lock over first (and separately) from the other files to
# eliminate triggering a cache-invalidation and reinstalling all gems. Doing
# this creates a separate layer.
COPY Gemfile* /usr/src/app/
WORKDIR /usr/src/app
RUN bundle install

# Copy the rest of the project files into the image
COPY . /usr/src/app/

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Get JavaScript up and running.
RUN npm install --global yarn
RUN yarn install

# Docker entrypoint does final house cleaning
ENTRYPOINT ["./docker-entrypoint.sh"]

# Start rails and bind to 0.0.0.0. This array notation is known as the Exec form
# and is needed so that our Rails server is started as the first process in the
# container (PID 1) and correctly receives Unix signals such as the signal to terminate.
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
