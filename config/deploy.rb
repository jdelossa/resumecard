set :application, "Joanna's CV/Resume and Portfolio"
set :repository,  "_site"

# !!! Capistrano 3 does away with this useful line
set :scm, :none

set :deploy_via, :copy
set :copy_compression, :gzip
set :use_sudo, false

# the name of the user that should be used for deployments on your VPS
set :user, "admin"

# the path to deploy to on your VPS
# this is the most common path on Apache configs, update your own accordingly
set :deploy_to, "/var/www/html"

# the ip address of your VPS
role :web, "107.170.57.105"

before "deploy:update", "deploy:update_jekyll"

# your images and CSS may not appear to work after the symlink process
# this rule and subsequent code fixes this issue
after "deploy:create_symlink", "deploy:fix_permissions"

namespace :deploy do
  [:start, :stop, :restart, :finalize_update].each do |t|
    desc "#{t} task is a no-op with jekyll"
    task t, :roles => :app do ; end
  end

  desc "Run jekyll to update site before uploading"
  task :update_jekyll do
    # clear existing _site
    # build site using jekyll
    # remove Capistrano stuff from build
    %x(rm -rf _site/* && jekyll build && rm _site/Capfile && rm -rf _site/config)
  end

  desc "Fix permissions"
  task :fix_permissions do
    # chmod files on the server
    run "chmod 775 -R #{current_path}"
    run "chmod 644 -R #{current_path}/.htaccess"
  end
end
