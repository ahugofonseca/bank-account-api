# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

###### DEFAULT GEMS ############################################################

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

###### OTHERS GEMS #############################################################

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS),
# making cross-origin AJAX possible
gem 'rack-cors'
# Use Json Web Token (JWT) for token based authentication
gem 'jwt'
# JSON serializer to Rails Active Model
gem 'fast_jsonapi'
# CPF and CNPJ utils
gem 'cpf_cnpj'
# Generates attr_accessors that transparently encrypt and decrypt attributes.
gem 'symmetric-encryption'
# Library to validation contract objects
gem 'dry-validation'
# Documentation API with Swagger + RSpec
gem 'rswag'
# Authorization policies
gem 'pundit'

################################################################################

group :development, :test do
  gem 'pry'
  gem 'pry-rails'
  gem 'rails-erd'
end

group :test do
  # RSpec testing framework
  gem 'rspec-rails'
  # Others gems to works with rspec
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rack-attack', '~> 6.3'
