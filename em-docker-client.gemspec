Gem::Specification.new do |gem| 
  gem.authors     = ["dkulchenko"]
  gem.email       = ["daniilk@activestate.com"]
  gem.description = "An EM-based nonblocking client for docker."
  gem.summary     = "An EM-based nonblocking client for docker."

  glob = Dir["**/*"].
    reject { |f| File.directory?(f) }

  gem.files         = glob
  gem.name          = "em-docker-client"
  gem.require_paths = ["lib"]
  gem.version       = '0.2.0'

  gem.add_dependency("eventmachine", "~> 1.0.3")
  gem.add_dependency("em-http-request", "~> 1.0.3")
end
