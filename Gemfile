source 'https://rubygems.org'
source 'https://code.stripe.com'

gem 'rails', '4.0.3'
gem 'thin'

gem 'cancan', git: 'https://github.com/jackquack/cancan.git'
gem 'devise'

gem 'configatron'
gem 'sidekiq'
gem 'has_scope'
gem 'cloud_assets', git: 'https://github.com/jackquack/cloud_assets.git'
gem 'typhoeus'
gem 'foreman'
gem 'gon'
gem 'retriable'

gem 'inherited_resources'

gem 'oj'
gem 'active_model_serializers', '0.8.4', git: 'https://github.com/jackquack/active_model_serializers.git', branch: '0-8-stable'

gem 'twitter-bootstrap-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'less-rails'
gem 'sass'
gem 'haml'
gem 'skeuocard-rails'

gem 'stripe'
gem 'coinbase'
gem 'bitcoin'

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-stack_explorer'

  gem 'capistrano'
  gem 'guard-livereload', require: false
  gem 'quiet_assets'
  gem 'mysql2'
end

group :staging, :production do
  gem 'exception_notification'
  gem 'pg'
end