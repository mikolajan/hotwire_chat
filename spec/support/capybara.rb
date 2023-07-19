require 'capybara/rspec'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.register_driver :headless_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1280,900")
  Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
end

Capybara.javascript_driver = :headless_chromium
