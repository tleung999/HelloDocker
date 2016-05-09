FROM ubuntu

RUN apt-get update
RUN apt-get install -y curl
RUN curl -L https://www.opscode.com/chef/install.sh | bash
RUN chef-solo -v
RUN openssl genrsa -des3 -passout pass:bigsecret -out server.pass.key 2048
RUN openssl rsa -pubout -passin pass:bigsecret -in server.pass.key -out server.key
RUN rm server.pass.key
RUN openssl req -nodes -newkey rsa:2048 -keyout server.key -out server.csr -subj "/C=US/ST=California/L=San Francisco/O=Some Company/OU=Engineering/CN=localhost"
RUN openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

RUN knife cookbook create apache
RUN mkdir -p /var/chef/cookbooks/apache/files/certificates/
RUN mv -t /var/chef/cookbooks/apache/files/certificates/ server.key server.crt
ADD attributes/default.rb /var/chef/cookbooks/apache/attributes/default.rb
ADD templates/ /var/chef/cookbooks/apache/templates
ADD default.rb /var/chef/cookbooks/apache/recipes/default.rb
WORKDIR /var/chef/cookbooks/apache/
RUN chef-client --local-mode --runlist 'recipe[apache]'
ADD index.html /var/www/html/index.html
CMD ["apachectl", "-D", "FOREGROUND"]

