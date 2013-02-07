Gem::Specification.new do |s|
  s.name = 'subunit'
  s.version = '0.2.3'
  s.summary = 'subunit'
    s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/subunit.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
