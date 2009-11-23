set :application, "gulpd"
set :repository,  "http://svn.spoonsix.com/gulpd.org/branches/0.1.2"
set :domain, "gulpd.com"
set :user, "root"
set :scm_username, 'luis.ca@gmail.com'
set :scm_password, 'svn1268'

set :location, "ec2-174-129-196-0.compute-1.amazonaws.com"

set :user, "root"
set :use_sudo, false

role :app, "#{location}"
role :web, "#{location}"
role :db,  "#{location}", :primary => true

set :deploy_to, "/var/www/html/#{application}"

#set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :rails_env, "production"

namespace :passenger do
  desc "Set permissions"
  task :set_permissions do
    run "cd #{current_path} && chown -R nobody: public/ tmp/ log/ cache/"
  end
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:set_permissions"
after :deploy, "passenger:restart"