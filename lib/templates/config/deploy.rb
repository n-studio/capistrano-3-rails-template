# config valid only for Capistrano 3.4
# lock '3.4.0'

set :application, 'name_of_application'
set :repo_url, 'git@github.com:username/my_repository.git'

set :secret_keys, [:secret_key_base, :db_name, :db_username, :db_password]

set :rbenv_type, :user
set :rbenv_ruby, '2.5.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Sidekiq
# set :sidekiq_queue, ['mailers', 'default']

# CRON tasks
# set :whenever_command, -> { [:bundle, :exec, :whenever] }
# set :whenever_environment, -> { fetch :rails_env, fetch(:stage, "production") }
# set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
# set :branch, :master

# Default value for :format is :pretty
# set :format, :pretty
set :format_options, truncate: false

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml .rbenv-vars}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, []

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
set(:config_files, %w(
  nginx.conf
  database.yml
  log_rotation
))

# which config files should be made executable after copying
# by deploy:setup_config
set(:executable_config_files, %w(
))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc. The full_app_name variable isn't
# available at this point so we use a custom template {{}}
# tag and then add it at run time.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: "log_rotation",
   link: "/etc/logrotate.d/{{full_app_name}}"
  }
])

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
  # make sure we're deploying what we think we're deploying
  before :deploy, "deploy:check_revision"
  # only allow a deploy with passing tests to deployed
  before :deploy, "deploy:run_tests"
  # compile assets locally then rsync
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  # remove the default nginx configuration as it will tend
  # to conflict with our configs.
  # before 'deploy:setup_config', 'nginx:remove_default_vhost'

  # reload nginx to it will pick up any modified vhosts from
  # setup_config
  after 'deploy:setup_config', 'nginx:reload'

  # As of Capistrano 3.1, the `deploy:restart` task is not called
  # automatically.
  after 'deploy:publishing', 'deploy:restart'
end

# for the first deploy, call:
# cap staging before_deploy:sudo_conf
# cap staging deploy:setup_config
# cap staging deploy:setup_secrets
# cap staging deploy:first_deploy

# and then, for the other deploys:
# cap staging deploy
