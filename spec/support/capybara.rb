require "selenium/webdriver"

Capybara.register_driver :selenium_chrome_in_container do |app|
  Capybara::Selenium::Driver.new app,
    browser: :remote,
    url: "http://selenium_chrome:4444/wd/hub",
    desired_capabilities: :chrome
end

Capybara.register_driver :headless_selenium_chrome_in_container do |app|
  Capybara::Selenium::Driver.new app,
    browser: :remote,
    url: "http://selenium_chrome:4444/wd/hub",
    options: options
end

def options
  opts = Selenium::WebDriver::Chrome::Options.new
  opts.add_argument('--headless')
  opts.add_argument('--disable-gpu')
  opts.add_argument('--window-size=1400,1400')
  opts
end
