# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'qna'
set :repo_url, 'git@github.com:AnnettePancake/qna.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/qna'
set :deploy_user, 'deploy'

set :ssh_options, forward_agent: true
set :use_sudo, false

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log",
#                      color: :auto, truncate: :auto

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', '.env', 'config/secrets.yml',
       'config/production.sphinx.conf'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system',
       'public/uploads', 'db/sphinx'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end
