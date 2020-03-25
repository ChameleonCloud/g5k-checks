ROOT_DIR = File.expand_path(File.dirname(__FILE__))
VERSION_FILE = File.join(ROOT_DIR, 'VERSION')
VERSION = File.read(VERSION_FILE).chomp

Gem::Specification.new do |s|
  s.name        = 'g5k-checks'
  s.version     = VERSION
  s.licenses    = ['CECILL-B']
  s.summary     = "Hardware verification tool for Grid'5000"
  s.description = "g5k-checks verifies that a node is matching its Grid'5000 Reference API description"
  s.authors     = ["Grid'5000"]
  s.email       = 'users@grid5000.fr'
  s.files       = Dir.glob("{bin,conf,lib,scripts}/**/*") + %w(LICENSE VERSION)
  s.executables = ['g5k-checks']
  s.homepage    = 'https://github.com/grid5000/g5k-checks'

  s.add_runtime_dependency('json')

  s.add_development_dependency('rake')
end
