#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
#bundle exec honeybadger deploy -e production -r https://github.com/matthaliski/matthaliski.com -s $(printenv RENDER_GIT_COMMIT) -u "matt"
