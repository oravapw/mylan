# config valid for current version and patch releases of Capistrano
lock "~> 3.18.0"

set :application,       "mylan"
set :repo_url,          "git@github.com:oravapw/mylan.git"
set :deploy_to,         "/usr/local/webapps/capistrano/mylan"
set :rvm_type,          :user
set :rvm_ruby_version,  "3.1.2@mylan"
set :branch,            "main"
set :deploy_user,       "rails"
append :linked_dirs,    "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :passenger_restart_with_touch, true
#set :assets_prefix,     "mylan/assets"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do

  desc "Setup production master key"
  task :setup_master_key do
    on roles(:app) do
      master_key_dir =  File.join(shared_path, "config", "credentials")
      master_key_file = File.join(master_key_dir, "production.key")
      if test("[ -r #{master_key_file} ]")
        puts "Master key file exists at #{master_key_file}"
      else
        key = ENV["MASTER_KEY"]
        if key.nil? || key.empty?
          puts "Need master key in env MASTER_KEY"
          exit 1
        end
        execute "mkdir -p #{master_key_dir}"
        execute "echo -n '#{key}' > #{master_key_file}"
      end

      execute "ln -sf #{master_key_file} #{release_path}/config/credentials/production.key"

      within release_path do
        if test :bundle, :exec, :rails, "credentials:show"
          puts "Master key is valid"
          valid = true
        else
          puts "Invalid master key!"
          exit 1
        end
      end
    end
  end

  desc "Link correct ruby version (for Passenger)"
  task :link_ruby do
    on roles(:app) do
      execute "ln -sf /home/rails/.rvm/gems/ruby-#{fetch(:rvm_ruby_version)}/wrappers/ruby #{release_path}/ruby"
    end
  end  
end

before "deploy:assets:precompile", "deploy:setup_master_key"
before "deploy:publishing", "deploy:link_ruby"

Rake::Task["deploy:assets:backup_manifest"].clear_actions
Rake::Task["deploy:assets:restore_manifest"].clear_actions
