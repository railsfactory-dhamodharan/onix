$:.push File.expand_path("../lib", __FILE__)
require "onix/version"

Gem::Specification.new do |s|
  s.name              = "milkfarm-onix"
  s.version           = ONIX::VERSION
  s.summary           = "A convient mapping between ruby objects and the ONIX XML specification"
  s.description       = "A fork of the original onix gem by James Healy. Differs from original mainly in it's adjustments for the US school/library market as applied in the product wrapper SLProduct."
  s.authors           = ["James Healy", "milkfarm productions"]
  s.email             = ["jimmy@deefa.com", "stuff@milkfarmproductions.com"]
  s.has_rdoc          = true
  s.homepage          = "http://github.com/milkfarm/onix"
  s.rdoc_options     << "--title" << "ONIX - Working with the ONIX XML spec" <<
                        "--line-numbers"
  s.test_files        = Dir.glob("spec/**/*.rb")
  s.files             = Dir.glob("{lib,support,dtd}/**/**/*") + ["README.markdown", "TODO", "CHANGELOG"]

  s.add_dependency('roxml', '~>3.1.6')
  s.add_dependency('activesupport', '~> 3.0.5')
  s.add_dependency('i18n')
  s.add_dependency('andand')
  s.add_dependency('nokogiri', '>=1.4')

  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", "~>2.1")
end
