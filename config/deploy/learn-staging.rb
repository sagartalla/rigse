# learn staging branch
set :user, "deploy"
set :domain, "learn.staging.concord.org"
set :deploy_to, "/web/portal"
server domain, :app, :web
role :db, domain, :primary => true
set :branch, "master"