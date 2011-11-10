# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloud-storage-sync/version"

Gem::Specification.new do |s|
  s.name        = "cloud_storage_sync"
  s.version     = CloudStorageSync::VERSION
  s.authors     = ["Amed Rodriguez", "Javier Saldana", "Daniel Roux"]
  s.email       = ["amed@tractical.com", "javier@tractical.com", "daniel@tractical.com"]
  s.homepage    = ""
  s.summary     = %q{Sync assets hosts}
  s.description = %q{Sync your assets hosts to Amazon & Rackspace services}

  s.rubyforge_project = "cloud-storage-sync"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec-rails", "2.7.0"
  s.add_development_dependency "mocha", "0.10.0"
  s.add_development_dependency "ruby-debug19"

  s.add_dependency "fog", "1.0.0"

end
