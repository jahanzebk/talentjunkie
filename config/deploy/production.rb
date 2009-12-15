default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, "talentjunkie"
set :domain, "talentjunkie.co.uk"

set :scm, "git"
set :repository, "git@github.com:/spoonsix/talentjunkie.git"
set :branch, "master"
# set :deploy_via, :remote_cache

set :user, "root"
set :use_sudo, false

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

set :deploy_to, "/var/www/html/#{application}"
set :rails_env, "production"

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :passenger do
  desc "Set permissions"
  task :set_permissions do
    run "cd #{current_path} && chown -R nobody: public tmp log"
  end
end

after :deploy, "passenger:set_permissions"
