# VulnsWatch

keeps track of know vulnerabilities in your systems.


# Deployment

Vulnswatch is a rails app depending on two databases. CouchDB and Postresql have
to be installed and configured.

## Couch DB
Install CouchDB 2.1 or newer, see here: http://couchdb.apache.org/
Then in the config.yml it has to be configured. Admin access 
is not required, but the user has to have rights to chage the
database structure in couch.

Login to Fauxton ( http://127.0.0.1:5984/_utils/# ) and create a database 
there. The standard name as in couch.yml is cves.

VulnsWatch will create design documents there.

If you install couch on the same machine, make sure to configure
couch to not to consume all the resources of the machine and leave
some for the rails app.

## Rails App
Installing Ruby on Rails app is possible then in a normal way.
We used Phusion Passenger and nginx. See an example below.
Other setups should work too.
We also used RVM and ruby 2.3.1.

This is how the rails app is installed:

```
gem install bundler
bundle install --with production --force
export RAILS_ENV=production
rails assets:precompile
rails db:migrate
```


## Example Passenger Configuration

This is how we configure nginx and passenger:


```
user    www-data;
worker_processes  1;
pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    passenger_root /home/deploy/.rvm/gems/ruby-2.3.1/gems/passenger-5.1.11;
    passenger_ruby /home/deploy/.rvm/gems/ruby-2.3.1/wrappers/ruby;

    include       mime.types;
    default_type  application/octet-stream;


    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  vulnswatch.genua.de;
        listen 443 ssl;
        ssl_certificate /opt/nginx/ssl/vulnswatch.genua.de.pem;
        ssl_certificate_key /opt/nginx/ssl/nginx.key;

        passenger_enabled on;
        rails_env    production;
        root /home/deploy/vulnswatch/public;
        location / { passenger_enabled on; }
    }
}
```