# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rails'
require 'selenium/webdriver'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument("--headless")
  chrome_options.add_argument("--disable-gpu")
  chrome_options.add_argument("--no-sandbox")

  # Slower, but you get to see what is happening if you connect via VNC
  Capybara.register_driver :selenium_chrome_in_container do |app|
    Capybara::Selenium::Driver.new app,
      browser: :remote,
      url: "http://selenium_chrome:4444/wd/hub",
      capabilities: :chrome
  end

  # Faster, but you're running headless and don't get to see what's going on
  Capybara.register_driver :headless_selenium_chrome_in_container do |app|
    Capybara::Selenium::Driver.new app,
      browser: :remote,
      url: "http://selenium_chrome:4444/wd/hub",
      capabilities: chrome_options
  end

  # Faster for non-js tests
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # Slower, but required for tests involving JS
  config.before(:each, type: :system, js: true) do
    # Run tests fast, but without seeing what's going on.
    driven_by :headless_selenium_chrome_in_container
    # Slower tests, but you can seen them running via VNC
    # driven_by :selenium_chrome_in_container
    Capybara.server_host = "0.0.0.0"
    Capybara.server_port = 4000
    Capybara.app_host = 'http://web:4000'
  end
end
