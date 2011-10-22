# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cloud-storage-sync/version"

Gem::Specification.new do |s|
  s.name        = "cloud-storage-sync"
  s.version     = Cloud::Storage::Sync::VERSION
  s.authors     = ["Amed Rodriguez"]
  s.email       = ["amed@tractical.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "cloud-storage-sync"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
