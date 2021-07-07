source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.7.0'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper"
end

group :development do
  gem "travis", ">= 1.7.4"
  gem "travis-lint"
  gem "beaker", ">= 1.20.1"
  gem "beaker-rspec", ">= 3.0.0"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem "metadata-json-lint"
end
