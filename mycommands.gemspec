Gem::Specification.new do |s|
  s.name         = 'mycommands'
  s.version      = '0.0.10'
  s.date         = '2013-01-26'
  s.summary      = "A console manager for your favourite commands."
  s.description  = "A simple hello world gem"
  s.authors      = ["Nils Eriksson"]
  s.email        = 'nils.epost@gmail.com'
  s.files        = Dir["{lib}/**/*.rb", "{lib}/**/*.yml", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables << 'mycommands'
  s.homepage     = 'https://github.com/nilseriksson/Mycommands'
  s.add_dependency 'clipboard'
  s.add_dependency 'pry'
end