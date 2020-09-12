Gem::Specification.new do |s|
  s.name = 'subunit'
  s.version = '0.6.1'
  s.summary = 'Input a raw unit and it returns the denomination.'
    s.authors = ['James Robertson']
  s.files = Dir['lib/subunit.rb'] 
  s.signing_key = '../privatekeys/subunit.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/subunit'
  s.required_ruby_version = '>= 2.1.2'
end
