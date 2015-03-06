# Generator for Capistrano 3 and Ruby on Rails 4.1.x (Postgresql/Nginx/Unicorn)

1. Change your secrets.yml file as following:
```
default: &default
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  devise_secret: <%= ENV["DEVISE_SECRET"] %>

development:
  <<: *default

test:
  <<: *default

staging:
  <<: *default

production:
  <<: *default
```

And your database.yml as following:
```
postgresql: &postgresql
  adapter: postgresql
  encoding: unicode
  pool: 5
  
default: &default
  database: <%= ENV['DB_NAME'] %>
  username: <%= ENV['DB_USERNAME'] %>
  password: <%= ENV['DB_PASSWORD'] %>

development:
  <<: *postgresql
  <<: *default
  
test:
  <<: *postgresql
  username: test
  password:
  database: your_app_name_test

staging:
  <<: *postgresql
  <<: *default
  
production:
  <<: *postgresql
  <<: *default
```

Create a .rbenv-vars with all the data for development and add it to your .gitignore.

2. Set up your DNS zones
3. Install the packages you need your server! (nginx, ruby, rbenv, rbenv-vars, monit, postgresql)
4. Share a SSH key with your server and another for the repository
5. Add ``gem 'capistrano-3-rails-template', git: 'https://github.com/n-studio/capistrano-3-rails-template.git', group: :development`` to your Gemfile. You will probably need to add ``pg``, ``unicorn`` and ``therubyracer``. Run ``bundle update``. Commit and push to your repository.
6. run ``rails g capistrano:rails_template``
7. ``cap staging before_deploy:sudo_conf`` Add the generated lines to your sudoer
8. set 
```
set :application, 'name_of_application'
set :repo_url, 'git@github.com:username/my_repository.git'
set :secret_keys, [:secret_key_base] # all the keys in your .rbenv-vars
```
9. set
```
server 'example.com', user: 'deploy', roles: %w{web app db}
set :server_name, "mywebsite.com"``
set :deploy_user, "deployer"
```
10. run
```
cap staging deploy:setup_config
cap staging deploy:setup_secrets
cap staging deploy:first_deploy
```
  
And the website is live!

# Credits

Most of the scripts come from:

* https://github.com/TalkingQuickly/capistrano-3-rails-template
* https://github.com/capistrano/capistrano/issues/878

# Contribute

* Open issues!
* Send pull requests!