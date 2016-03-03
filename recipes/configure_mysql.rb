#
# Cookbook Name:: atom
# Recipe:: configure_mysql
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install mysql2_chef_gem to set up databases
mysql2_chef_gem 'default'

# Set up AtoM database
mysql_database node['atom']['database_name'] do
  connection(
    host:     node['mysql']['bind_address'],
    username: 'root',
    socket:   "/var/run/mysql-#{node['mysql']['service_name']}/mysqld.sock",
    password: node['mysql']['initial_root_password']
  )
  encoding  'utf8'
  collation 'utf8_unicode_ci'
end

# Create database user 'atom' and grant all priveleges
mysql_connection_info = {
  host:     node['mysql']['bind_address'],
  username: 'root',
  password: node['mysql']['initial_root_password']
}

mysql_database_user node['atom']['database_user'] do
  connection      mysql_connection_info
  password        node['atom']['database_user_password']
  database_name   node['atom']['database_name']
  action :grant
end
