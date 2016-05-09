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
RUN chmod 600 server.key
ADD apache.rb .
RUN chef-client --local-mode apache.rb
ADD index.html /var/www/html/index.html
RUN mv server.crt /etc/ssl/certs/server.crt
RUN mv server.key /etc/ssl/private/server.key
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
CMD ["apachectl", "-D", "FOREGROUND"]
