# Switch off Ruby's output buffering because it doesn't play nicely with
# Docker Compose.
$stdout.sync = true

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
