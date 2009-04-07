#############################################################
#	Application
#############################################################

set :application, "biocad"
set :deploy_to, "/projects/chenlab/website/"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
# ssh_options[:forward_agent] = true
ssh_options[:port] = 62
set :use_sudo, false
set :scm_verbose, true 

#############################################################
#	Servers
#############################################################
set :gateway, "ssh.ittc.ku.edu"
set :user, "jvalland"
set :domain, "xenon"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "master"
# set :scm_user, 'bort'
# set :scm_passphrase, "PASSWORD"
set :repository, "git://github.com/vlandham/biocad.git"
set :deploy_via, :remote_cache

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end
