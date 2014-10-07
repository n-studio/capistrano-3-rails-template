# Generator for Capistrano 3 and Ruby on Rails 4.1.x (Postgresql/Nginx/Unicorn)

1. Set up your DNS zones
2. Install the packages you need your server! (nginx, ruby, rbenv, rbenv-vars, monit, postgresql)
3. Share a SSH key with your server and another for the repository
4. Add ``gem 'capistrano-3-rails-template', git: 'https://github.com/n-studio/capistrano-3-rails-template.git', group: :development`` to your Gemfile and run ``bundle update``. Commit and push to your repository.
5. run ``rails g capistrano:rails_template``
6. cap staging before_deploy:sudo_conf
Add the generated lines to your sudoer
7. set 
```
set :application, 'name_of_application'
set :repo_url, 'git@github.com:username/my_repository.git'
```

8. set
```
server 'example.com', user: 'deploy', roles: %w{web app db}
set :server_name, "mywebsite.com"``
set :secret_keys, [:secret_key_base]
```

9. run
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