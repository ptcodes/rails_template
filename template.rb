remove_file "README.rdoc"
remove_file "public/index.html"
remove_file "public/favicon.ico"
remove_file "public/robots.txt"
remove_file "app/assets/images/rails.png"
remove_file "app/views/layouts/application.html.erb"

create_file ".rvmrc", "rvm use 1.9.3"

gem 'devise'
gem 'simple_form'
gem 'haml-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'thin'
gem 'carrierwave'
gem 'mini_magick'
gem 'cancan'
gem 'state_machine'

gem_group :assets do
  gem 'twitter-bootstrap-rails'
  gem 'bootstrap-sass'
  gem 'bootswatch-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
end

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request', '0.2.1'
  gem 'bullet'
  gem 'awesome_print'
  gem 'pry-rails'
end

gem_group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'growl'
  gem 'guard-spork'
  gem 'rb-fsevent'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rspec-rails-mocha', '~> 0.3.1', require: false
  gem 'shoulda-matchers'
  gem 'spork-rails'
  gem 'sqlite3'
  gem 'rb-inotify', '~> 0.8.8' , require:false
  gem 'annotate', '~> 2.4.1.beta'
  gem 'guard'
  gem 'guard-rails'
  gem 'guard-livereload'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-annotate'
  gem 'guard-delayed'
end

run 'bundle install'

rake "db:create", :env => 'development'
rake "db:create", :env => 'test'
generate 'simple_form:install --bootstrap'
generate 'devise:install'
generate 'devise:views'
generate 'bootstrap:install'
generate 'bootstrap:layout'
run "for i in `find app/views/devise -name '*.erb'` ; do html2haml -e $i ${i%erb}haml ; rm $i ; done"
generate 'jquery:install'
generate 'rspec:install'
generate 'cucumber:install --spork'

git :init
append_file '.gitignore', <<-END
  config/database.yml
  db/*.sqlite3
  log/*.log
  tmp
  public/uploads
  .bundle
  .sass-cache
  .rvmrc
  .DS_Store
  .sw*
END
remove_file  'spec/spec_helper.rb'
create_file 'spec/spec_helper.rb', <<-END
  require 'rubygems'
  require 'spork'

  Spork.prefork do
    ENV["RAILS_ENV"] ||= 'test'
    require File.expand_path("../../config/environment", __FILE__)
    require 'rspec/rails'
    require 'capybara/rails'
    require 'capybara/rspec'
    require 'capybara/dsl'
    require 'factory_girl'

    Capybara.ignore_hidden_elements = true
    Capybara.javascript_driver = :webkit

    Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

    RSpec.configure do |config|
      config.before do
        ActiveRecord::Base.observers.disable :all
      end

      config.mock_with :rspec
      config.use_transactional_fixtures = true
      config.infer_base_class_for_anonymous_controllers = false

      ActiveSupport::Dependencies.clear

      config.include FactoryGirl::Syntax::Methods
    end
  end

  Spork.each_run do
    load "\#{Rails.root}/config/routes.rb"
    Dir["\#{Rails.root}/app/**/*.rb"].each { |f| load f }
  end
END

run 'cp config/database.yml config/database.example.yml'

git add: '.', commit: '-m "Initial commit"'
