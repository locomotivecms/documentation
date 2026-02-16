require 'rspec'
require 'liquid'
require 'rails'
require 'markdown-rails'
require_relative '../liquid/liquid'

# Load all files in spec/support
Dir[File.join(__dir__, 'support', '**', '*.rb')].sort.each { |file| require file }

# Configure RSpec
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
