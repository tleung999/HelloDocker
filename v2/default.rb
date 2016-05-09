#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Update apt cache
apt_update 'Update apt cache' do
  action [:update]
end

# Install Apache2
package 'apache2' do
  action [:install]
end

# Copy key file to private directory
cookbook_file "#{node['apache']['sslpath']}/private/server.key" do
  source 'certificates/server.key'
  owner 'root'
  group 'root'
  mode 0600
  action :create_if_missing
end

# Copy crt file to ssl cert directory
cookbook_file "#{node['apache']['sslpath']}/certs/server.crt" do
  source 'certificates/server.crt'
  owner 'root'
  group 'root'
  mode 0644
  action :create_if_missing
end

# Update default-ssl.conf
template "#{node['apache']['dir']}/sites-available/default-ssl.conf" do
  source "default-ssl.conf.erb"
  mode 0644
  owner "root"
  group "root"
  variables(
          :servername => "#{node['apache']['servername']}",
          :sslcertificate => "#{node['apache']['sslpath']}/certs/server.crt",
          :sslkey => "#{node['apache']['sslpath']}/private/server.key"
  )
end

# Update 000-default.conf
template "#{node['apache']['dir']}/sites-available/000-default.conf" do
  source "000-default.conf.erb"
  mode  0644
  owner 'root'
  group 'root'
  variables(
          :servername => "#{node['apache']['servername']}",
          :redirect => "Redirect permanent / https://localhost/"
  )
end

# Activate SSL
execute 'a2enmod' do
  command '/usr/sbin/a2enmod ssl'
end

execute 'a2ensite' do
  command '/usr/sbin/a2ensite default-ssl.conf'
end




