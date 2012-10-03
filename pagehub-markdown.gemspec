Gem::Specification.new do |s|
  s.name        = 'pagehub-markdown'
  s.version     = '0.1.0'
  s.summary     = "PageHub's extensions of GitHub's Redcarpet Markdown renderer."
  s.description = "A bunch of neat features added to the Markdown renderer via pure Markdown syntax."
  s.authors     = ["Ahmad Amireh"]
  s.email       = 'ahmad@amireh.net'
  s.files       = Dir.glob("lib/**/*.rb")
  s.homepage    = 'http://github.com/amireh/pagehub-markdown'

  s.add_dependency('redcarpet', '>= 2.1.1')
  s.add_dependency('albino', '>= 1.3.3')
  s.add_dependency('json', '>= 1.7.0')
  s.add_dependency('nokogiri', '>= 1.5.5')
end
