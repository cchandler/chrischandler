set :application, "chrischandler"
set :domain, "chrischandler.name"
set :deploy_to, "/home/deploy/apps/chrischandler"
set :repository, 'git://github.com/cchandler/chrischandler.git'

namespace :vlad do
  ##
  # Merb app server

  set :merb_address,       "127.0.0.1"
  set :merb_clean,         false
  set :merb_command,       'merb -I new_chrischandler.rb'
  set :merb_conf,          nil
  set :merb_extra_config,  nil
  set :merb_environment,   "production"
  set :merb_group,         nil
  set :merb_port,          9000
  set :merb_prefix,        nil
  set :merb_servers,       1
  set :merb_user,          nil

  desc "Prepares application servers for deployment. merb
configuration is set via the merb_* variables.".cleanup

  remote_task :setup_app, :roles => :app do
    "rake"
  end

  def merb(cmd) # :nodoc:
    "cd #{current_path} && #{merb_command} -p #{merb_port} -c #{merb_servers} -e #{merb_environment} #{cmd}"
  end

  desc "Restart the app servers"

  remote_task :start_app, :roles => :app do
    run merb('')
  end

  remote_task :start_app => :stop_app

  desc "Stop the app servers"

  remote_task :stop_app, :roles => :app do
    run merb("-K all")
  end

  remote_task :migrate_merb, :roles => :db do
    run "cd #{current_release}; rake db:migrate MERB_ENV=#{merb_environment}"
  end

  task :update do
    run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
  end
end

task :deploy => ["vlad:start_app"]