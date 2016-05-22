source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
gem 'mongoid', '~> 5.1', '>= 5.1.3'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'puma'
gem 'rack-cors', :require => 'rack/cors'
gem 'dotenv-rails', :require => 'dotenv/rails-now'
gem 'telegram-bot'
gem 'redis-rails'
gem 'httparty'
gem 'markdown-rails'
gem 'redcarpet'

group :production do
  gem 'rails_12factor'
  gem 'rack-attack'
  gem 'dalli'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.4.2'
end

group :test do
  gem 'rspec', '~> 3.4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rspec-collection_matchers'
  gem 'mongoid-rspec', '3.0.0'
  gem 'database_cleaner'
end
