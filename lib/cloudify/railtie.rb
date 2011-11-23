module Cloudify
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/deploy.rake"
    end
  end
end
