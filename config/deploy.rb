#
set :stages, %w(production staging sandbox boskone)
set :default_stage, "staging"
set :application, "PlannerPrototype"
set :repository,  "https://conferenceplan.svn.sourceforge.net/svnroot/conferenceplan/PlannerPrototype"
set :deploy_to, "/opt/www"

require "capistrano/ext/multistage"
require "config/capistrano_database_yml"
require "config/capistrano_production_rb"

set :scm, :subversion
set :group, "www-data"
set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end