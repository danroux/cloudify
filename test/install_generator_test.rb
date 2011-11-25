require "test_helper"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Cloudify::InstallGenerator
  destination File.expand_path("../../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  setup :run_generator

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/initializers/cloudify.rb"
  end

end
