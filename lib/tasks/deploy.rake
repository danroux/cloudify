namespace :cloudify do
  desc "sync assets"
  task :sync => :environment do
    puts "*** Syncing with #{Cloudify.config.provider} ***"
    Cloudify.sync
  end
end
         