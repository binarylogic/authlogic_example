default_run_options[:pty] = true

set :application, "authlogic_example.binarylogic.com"
set :repository,  "git@github.com:binarylogic/authlogic_example.git"
set :keep_releases, 5

set :scm, :git
set :deploy_via, :remote_cache # prevent git from cloning on every deploy
set :deploy_to, "/var/www/#{application}"
set :branch, "master"

set :thin_conf, "#{current_path}/config/thin.yml" # must be set after :deploy_to is set

set :user, 'root'
set :runner, 'root'
set :use_sudo, false

role :app, "binarylogic.com"
role :web, "binarylogic.com"
role :db,  "binarylogic.com", :primary => true

task :after_update_code do
  # handle shared files
  %w{/config/database.yml /config/thin.yml}.each do |file|
    run "ln -nfs #{shared_path}#{file} #{release_path}#{file}"
  end
  
  deploy.cleanup
end

namespace :deploy do
  namespace :thin do
    [ :stop, :start, :restart ].each do |t|
      desc "#{t.to_s.capitalize} the thin servers"
      task t, :roles => :app do
        #invoke_command checks the use_sudo variable to determine how to run the thin command
        invoke_command "thin #{t.to_s} -C #{thin_conf}", :via => run_method
      end
    end
  end

  desc "Custom restart task for thin cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    deploy.thin.restart
  end

  desc "Custom start task for thin cluster"
  task :start, :roles => :app do
    deploy.thin.start
  end

  desc "Custom stop task for thin cluster"
  task :stop, :roles => :app do
    deploy.thin.stop
  end
end