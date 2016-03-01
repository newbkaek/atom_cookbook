#
# Cookbook Name:: atom
# Recipe:: install_dependencies
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install package dependencies
# package %w(curl git gearmand)

# # Include webtatic for EL6 releases
# if platform_family?('rhel') && node['platform_version'].to_i == 6
#   webtatic_rpm = 'https://mirror.webtatic.com/yum/el6/latest.rpm'
#   remote_file "#{Chef::Config[:file_cache_path]}/webtatic.rpm" do
#     source webtatic_rpm
#   end
#   rpm_package "#{Chef::Config[:file_cache_path]}/webtatic.rpm"
# end

# # Install optional packages & dependencies
# if node['atom']['install_optional_packages']

#   node['atom']['additional_repos'].each do |repo, url|
#     remote_file "#{Chef::Config[:file_cache_path]}/#{repo}.rpm" do
#       source url
#     end
#     rpm_package "#{Chef::Config[:file_cache_path]}/#{repo}.rpm"
#   end

#   package node['atom']['optional_packages']
# end

# Install less and gulp to precomile css
# nodejs_npm 'less gulp'

service 'php-fpm' do
  service_name 'php-fpm'
  supports start: true, stop: true, restart: true, reload: true
end


template "#{node['php']['fpm_pooldir']}/atom.conf" do
  source 'atom.php-fpm.erb'
  notifies :restart, 'service[php-fpm]'
end

# Nginx configuration for AtoM
nginx_site 'atom' do
  template 'atom.nginx.erb'
  notifies :reload, 'service[nginx]', :delayed
end

# MySQL
include_recipe 'atom::configure_mysql'

# # PHP
# template '/etc/php.ini' do
#   source 'php.ini.erb'
# end

# include_recipe 'atom::configure_php'
