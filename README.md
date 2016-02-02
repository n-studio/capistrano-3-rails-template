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
3. Install the packages you need your server! (nginx, ruby, rbenv, rbenv-vars, monit, postgresql, libpq-dev, postgresql-contrib)
4. Create a new user with ``adduser deploy --disabled-password``. Share a SSH key (``ssh-keygen -t rsa -b 4096``) with your server and another for the repository. Create a new postgresql user ``su - postgres`` ``psql`` ``CREATE ROLE deploy LOGIN PASSWORD 'my_password' SUPERUSER; CREATE DATABASE deploy WITH OWNER = deploy;``
5. Add ``gem 'capistrano-3-rails-template', git: 'https://github.com/n-studio/capistrano-3-rails-template.git', group: :development`` to your Gemfile. You will probably need to add ``pg``, ``unicorn`` and ``therubyracer``. Run ``bundle update``. Commit and push to your repository.
6. run ``rails g capistrano:rails_template``
7. set 
```
set :application, 'name_of_application'
set :repo_url, 'git@github.com:username/my_repository.git'
set :secret_keys, [:secret_key_base, :db_name, :db_username, :db_password] # all the keys in your .rbenv-vars
```
8. set
```
server 'example.com', user: 'deploy', roles: %w{web app db}
set :server_name, "mywebsite.com"
set :deploy_user, "deploy"
```
9. If you deploy on a custom environment like staging, don't forget to create a staging.rb file
10. ``cap staging before_deploy:sudo_conf`` Add the generated lines to your sudoer
11. run
```
cap staging deploy:setup_config
cap staging deploy:setup_secrets
cap staging deploy:first_deploy
```
  
And the website is live!

## Deploy Sidekiq

1. Add ``worker`` in your roles.
2. Uncomment the sidekiq related lines in ``sudo.cap``, run ``cap staging before_deploy:sudo_conf`` and edit your sudoer file with the generated lines
3. Set ``:sidekiq_queue``
4. Add ``config/sidekiq.yml`` in ``:linked_files``
5. Add ``sidekiq.yml`` and ``sidekiq_init.sh`` in ``:config_files``
6. Add ``sidekiq_init.sh`` in ``:executable_config_files``
7. Add ``{source: "sidekiq_init.sh", link: "/etc/init.d/sidekiq_{{full_app_name}}"}`` in ``:symlinks``
8. Run ``cap staging deploy:setup_config`` again

## Deploy Action Cable

1. Add ``ws`` in your roles.
2. Uncomment the action cable related lines in ``sudo.cap``, run ``cap staging before_deploy:sudo_conf`` and edit your sudoer file with the generated lines
3. Add ``actioncable_init.sh`` in ``:config_files``
4. Add ``actioncable_init.sh`` in ``:executable_config_files``
5. Add ``{source: "actioncable_init.sh", link: "/etc/init.d/actioncable_{{full_app_name}}"}`` in ``:symlinks``
6. Run ``cap staging deploy:setup_config`` again

# Upgrade Ruby

Whenever you update your Ruby version, don't forget to run ``cap staging deploy:setup_config`` again.

# Credits

Most of the scripts come from:

* https://github.com/TalkingQuickly/capistrano-3-rails-template
* https://github.com/capistrano/capistrano/issues/878

# Contribute

* Open issues!
* Send pull requests!