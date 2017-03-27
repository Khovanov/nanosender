# README

## See API doc on Swagger UI
[Nanosender Swagger UI](https://nanosender.herokuapp.com/apidocs)

---

# Project use:

## PostgresQL
[Redis](https://www.postgresql.org/)

## Sidekiq
[Sidekiq](https://github.com/mperham/sidekiq)

## Redis server
[Redis](https://redis.io/)

## Foreman
[Foreman](https://github.com/ddollar/foreman)

## Swagger
[Swagger](http://swagger.io/)

## For deploy Project

* install RVM, Postgres, Redis
* clone and bundle project
* config database.yml
* rails s

---

# Steps for build this project (example configs and commands)

## Create RVM Gemset
```
mkdir nanosender
cd nanosender
rvm --ruby-version use ruby-2.3.3@nanosender --create
```
## Install Rails
```
gem install rails -v 5.0.2 --no-rdoc --no-ri
```

## Generate new Rails app with PostgresQL, without: tests and run bundler
```
rails new . -d postgresql -T -B
```
### Gemfile
```
gem 'slim-rails'

# for API
gem 'responders'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

# Shell
group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

```
### /config/database.yml
```
cd config
cp database.yml database_sample.yml
```
### .gitignore
```
/config/database.yml
```
### Bundler
```
gem install bundler --no-ri --no-rdoc
bundler
```
### Git
```
git init
git add .
git ci -m init project
git remote add origin git@github.com:khovanov/nanosender.git
git push origin master
```
## Generate User
```
rails g model User name:string
```
## Setup DB from seeds (before prepare seeds.rb)
```
rake db:create
rake db:migrate
rake db:seed
```
## Generate serializer
```
rails g serializer user
```

# RSpec

## Gemfile  
```
group :test, :development do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'pry-byebug'

  # for API testing
  gem 'json_spec'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
end
```
### for 5xx Rails
```
group :test, :development do
  gem 'rails-controller-testing'
end
```

### Bundler
```
bundler
```

## RSpec generate
```
rails generate rspec:install
```

## .rspec
```
--color
--require spec_helper
--format doc
```

## rails_helper.rb

### after require ...
```
require 'shoulda/matchers'
```
### uncomment Dir...
```
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
```
### RSpec.configure for 4xx Rails
```
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  #config.include Devise::TestHelpers, type: :controller
  #config.extend ControllerMacros, type: :controller
  #config.include ControllerMacros, type: :controller
  #config.include OmniauthMacros
  ...
```
### RSpec.configure for 5xx Rails
```
RSpec.configure do |config|
  [:controller, :view, :request].each do |type|
    config.include ::Rails::Controller::Testing::TestProcess, type: type
    config.include ::Rails::Controller::Testing::TemplateAssertions, type: type
    config.include ::Rails::Controller::Testing::Integration, type: type
  end
  config.include FactoryGirl::Syntax::Methods
  #config.include AcceptanceMacros, type: :feature
  #config.include OmniauthMacros, type: :feature
  #config.include Devise::Test::ControllerHelpers, type: :controller
```
### at the end file
```
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
```

### Comfig RSpec generators - config/application.rb
```
config.generators do |g|
  g.test_framework :rspec,
                   fixtures: true,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   request_specs: false,
                   controller_specs: true

  g.fixture_replacement :factory_girl, dir: 'spec/factories'
end
```

### spec/acceptance/acceptance_helper.rb
```
require 'rails_helper'
require 'capybara/poltergeist'
# require 'capybara/rspec'

RSpec.configure do |config|
  # Capybara.javascript_driver = :webkit
  Capybara.javascript_driver = :poltergeist
  # Capybara.javascript_driver = :selenium

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end
  #config.include AcceptanceMacros, type: :feature  
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  #config.before(:each, sphinx: true) do
  #  DatabaseCleaner.strategy = :truncation
  #end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.use_transactional_fixtures = false
end
```

## Generate Factory for User
```
rails g factory_girl:model user name:text
```

## Generate job (Active Job)
```
rails g job send_message
rails g rspec:job send_message
```

## Generate NotificationMailer
```
rails g mailer NotificationMailer
```
## config/environments/development.rb
```
config.action_mailer.default_url_options = { host: '127.0.0.1', port: 3000 }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { address: '127.0.0.1', port: 1025 }
```
### console whitelist
```
config.web_console.whitelisted_ips = '10.0.2.0/24'
```

## Sidekiq

[Sidekiq](https://github.com/mperham/sidekiq)

### Gemfile

```
# rails4
gem 'sidekiq'
gem 'sinatra', '>= 1.4.6', require: nil

# rails5
gem 'sidekiq'
gem 'sinatra', github: 'sinatra/sinatra', require: nil

```

### PLug adapter sidekiq into /config/application.rb
```
config.active_job.queue_adapter = :sidekiq
```

## rails_helper.rb
```
require 'sidekiq/testing'
#Sidekiq::Testing.inline!
Sidekiq::Testing.fake!
#Sidekiq::Testing.disable!
```

### routes
```
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
```

## Redis server

[Redis](https://redis.io/)

```
sudo apt-get install redis-server
```

### .gitignore
```
dump.rdb
/public/system/
```
## Foreman

[Foreman](https://github.com/ddollar/foreman)

```
gem install foreman
```

### /procfile
```
rails: PORT=3000 rails s -b0
redis: redis-server
sidekiq: sidekiq
mail: mailcatcher -f --ip 0

```

## run servers
`foreman start`

# for Heroku
ruby '2.3.3'
