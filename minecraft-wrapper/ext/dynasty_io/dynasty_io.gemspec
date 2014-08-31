Gem::Specification.new do |s|
  s.name    = "dynasty_io"
  s.version = "0.1.0"
  s.summary = "DynastyIO"
  s.author  = ""
  
  s.files = Dir.glob("ext/**/*.{c,rb}") +
            Dir.glob("lib/**/*.rb")
  
  s.extensions << "ext/dynasty_io/extconf.rb"
  
  s.add_development_dependency "rake-compiler"
end
