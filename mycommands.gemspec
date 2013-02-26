# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'mycommands/version'

Gem::Specification.new do |gem|
  gem.name          = "mycommands"
  gem.version       = Mycommands::VERSION
  gem.authors       = ["Nils Eriksson"]
  gem.email         = ["nils.epost@gmail.com"]
  gem.description   = %q{Often when I need a solution for a specific task I do a google search to find out what command I can use. Before I made this script I had a text file with commands saved that I wanted to rember. This script makes it easier to fetch and organize my favourite commands.}
  gem.summary       = %q{Small console app to manage your favourite commands}
  gem.homepage      = "https://github.com/nilseriksson/Mycommands"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "clipboard", "~> 1.0.1"
  gem.add_development_dependency "minitest", "~> 4.5.0"
  gem.add_development_dependency "pry", "~> 0.9.11.4"
  gem.add_development_dependency "rake", "~> 10.0.3"

end
