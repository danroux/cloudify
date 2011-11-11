require File.join(File.dirname(__FILE__), 'test_helper')

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Cloudify::InstallGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  setup :prepare_destination
  setup :run_generator

  test "Assert all files are properly created" do
    assert_file "lib/tasks/cloudify.rake"
  end

end
