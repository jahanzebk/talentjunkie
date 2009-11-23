set :application, "gulpd"
set :repository,  "http://svn.loudgooey.com/gulpd.org/branches/0.1.2"
set :domain, "staging.gulpd.com"
set :user, "root"
set :scm_username, 'luis.ca@gmail.com'
set :scm_password, 'svn1268'

set :user, "root"
set :use_sudo, false

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

set :deploy_to, "/var/www/html/staging.#{application}"

set :mongrel_conf, "#{current_path}/config/staging_mongrel_cluster.yml"
set :rails_env, "staging"
