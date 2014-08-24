Gem::Specification.new do |s|
  s.name        = 'pagehub-markdown'
  s.version     = '0.1.3'
  s.summary     = "PageHub's extensions of GitHub's Redcarpet Markdown renderer."
  s.description = "A bunch of extensions added to the Markdown renderer usable as pure Markdown syntax."
  s.authors     = ["Ahmad Amireh"]
  s.email       = 'ahmad@amireh.net'
  s.files       = Dir.glob("lib/**/*.rb")
  s.homepage    = 'https://github.com/amireh/pagehub-markdown'

  s.add_dependency('redcarpet', '= 3.1.2')
  s.add_dependency('json')
  s.add_dependency('nokogiri', '= 1.6.3.1')
  s.add_dependency('pygments.rb', '~> 0.6.0')

  s.add_development_dependency 'rspec'
end
