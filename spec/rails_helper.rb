def test_data
  @market1 = Market.create!(id: 1,
                            name: 'Test Market 1',
                            street: '123 Test St',
                            city: 'Test City',
                            county: 'Test County',
                            state: 'Test State',
                            zip: '12345',
                            lat: '123.456',
                            lon: '123.456')

  @market2 = Market.create!(id: 2,
                            name: 'Market 2',
                            street: '4569 Test Rd',
                            city: 'Tester City',
                            county: 'Tester County',
                            state: 'Hawaii',
                            zip: '98765',
                            lat: '987.654',
                            lon: '987.667')

  @vendor1 = Vendor.create!(id: 1,
                            name: 'Test Vendor 1',
                            description: 'Test Description 1',
                            contact_name: 'Contact 1',
                            contact_phone: '123-456-7890',
                            credit_accepted: true)
  
  @vendor2 = Vendor.create!(id: 2,
                            name: 'Test Vendor 2',
                            description: 'Test Description 2',
                            contact_name: 'Contact 2',
                            contact_phone: '123-456-0000',
                            credit_accepted: false)
  
  @vendor3 = Vendor.create!(id: 3,
                            name: 'Test Vendor 3',
                            description: 'Test Description 3',
                            contact_name: 'Contact 3',
                            contact_phone: '123-456-1111',
                            credit_accepted: false)

  @mv1 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor1.id)
  @mv2 = MarketVendor.create!(market_id: @market1.id, vendor_id: @vendor2.id)

  @mv3 = MarketVendor.create!(market_id: @market2.id, vendor_id: @vendor3.id)
  @mv3 = MarketVendor.create!(market_id: @market2.id, vendor_id: @vendor2.id)
end

def market_search_data
  @market1 = create(:market, name: "City Park Farmer's Market", city: 'Aurora', state: 'CO')
  @market2 = create(:market, name: "Pearl St Farmer's Market", city: 'Denver', state: 'CO')
  @market3 = create(:market, name: "Cherry Creek Farmer's Market", city: 'Denver', state: 'CO')
  @market4 = create(:market, name: "Cohasset Farmer's Market", city: "Cohasset", state: "MA")
  @market5 = create(:market, name: "Copley Square Farmer's Market", city: "Boston", state: "MA")
  @market6 = create(:market, name: "Pheonix Park Farmer's Market", city: "Pheonix", state: "AZ")
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
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
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

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
  config.include FactoryBot::Syntax::Methods
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
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
     with.test_framework :rspec
     with.library :rails
  end
end
