set :application, "chrischandler"
set :repository, "git@github.com:cchandler/chrischandler.git"

set :use_sudo, false

set :scm, "git"
# set :scm_passphrase, "9hOTtkzTRnLJLTPQyC3zxEvyT"
set :branch, "master"
set :user, "deploy"
set :password, "9hOTtkzTRnLJLTPQyC3zxEvyT"

set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache

default_run_options[:pty] = true
#password 9hOTtkzTRnLJLTPQyC3zxEvyT

role :app, "chrischandler.name"
role :web, "chrischandler.name"
role :db,  "chrischandler.name", :primary => true

after "deploy:setup", "deploy:more_setup"
after "deploy:update_code", "deploy:symlink_config"
after "deploy", "deploy:cleanup"

deploy.task :more_setup, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  # run "mkdir -p #{shared_path}/config #{shared_path}/public/images/avatars"
  run "mongrel_rails cluster::configure -e production -a 127.0.0.1 --user deploy --group deploy -l #{shared_path}/log/mongrel.log -P #{shared_path}/log/mongrel.pid -p 9000 -c #{deploy_to}/current -C #{shared_path}/config/mongrel_cluster.yml"
end

deploy.task :symlink_config, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
  run "ln -nsf #{shared_path}/config/database.yml #{current_release}/config"
  run "ln -nsf #{shared_path}/config/mongrel_cluster.yml #{current_release}/config"
  run "cd #{current_release} && RAILS_ENV=production rake db:migrate"
end

deploy.task :start do
  run "mongrel_rails cluster::start -C #{shared_path}/config/mongrel_cluster.yml"
end

deploy.task :stop do
  run "mongrel_rails cluster::stop -C #{shared_path}/config/mongrel_cluster.yml"
end
