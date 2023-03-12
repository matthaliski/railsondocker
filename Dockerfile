FROM ruby:3.1.3

LABEL maintainer="matt@haliski.com"

# Ensure node.js 19 is available for apt-get
RUN curl -sL https://deb.nodesource.com/setup_19.x | bash -

# First, make sure to run update and install in a one-liner to avoid
# using older cached versions.
# Second, it's convention to list the installs one per line and alphabetical.
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libvips \
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

# Get JavaScript up and running.
RUN npm install --global yarn
#RUN yarn build --watch
#RUN yarn build:css --watch


# Start rails and bind to 0.0.0.0
CMD ["bin/rails", "s", "-b", "0.0.0.0"]
