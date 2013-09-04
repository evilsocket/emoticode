# Load RVM's capistrano plugin.    
require "rvm/capistrano"
require 'fileutils'

set :rvm_ruby_string, '2.0.0'
set :rvm_type, :user  # Don't use system-wide RVM
 
server "emoticode.net", :web, :app, :db, primary: true
 
set :application, "emoticode"
set :user, "evilsocket"
set :deploy_to, "/var/www/#{application}.net/rails"
set :deploy_via, :remote_cache
set :use_sudo, false
 
set :scm, "git"
set :repository, "git@github.com:evilsocket/#{application}.git"
set :branch, "master"
 
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"
 
namespace :deploy do
  secrets = [ 'config/database.yml', 'config/secrets.yml', 'config/development.sphinx.conf', 'public/avatars' ]

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_ini.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"

    secrets.each do |secret|
      if File.directory? secret
        FileUtils.cp_r(secret), "#{shared_path}/#{secret}"
      else
        put File.read(secret), "#{shared_path}/#{secret}"
      end
    end

    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"
 
  task :symlink_config, roles: :app do
    secrets.each do |secret|
      run "ln -nfs #{shared_path}/#{secret} #{release_path}/#{secret}"
    end
  end
  after "deploy:finalize_update", "deploy:symlink_config"
 
  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
