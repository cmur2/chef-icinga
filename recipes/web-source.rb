
include_recipe "icinga"
include_recipe "php"
include_recipe "build-essential"

# Debian 6
package "build-essential" # TODO: without!
package "php5-xmlrpc"
package "php5-xsl"
package "php5-gd"
package "php5-ldap"
package "php5-mysql"
package "libapache2-mod-php5"

node.set['apache']['servertokens'] = "Minimal"

include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
apache_module "php5"

version = node[:icinga][:web][:version]
path = "/usr/src/icinga-web-#{version}"

remote_file "#{path}.tar.gz" do
  source "http://downloads.sourceforge.net/project/icinga/icinga-web/#{version}/icinga-web-#{version}.tar.gz"
  checksum node[:icinga][:web][:checksum]
end

execute "untar icinga-web" do
  command "tar xzf icinga-web-#{version}.tar.gz"
  cwd "/usr/src"
  creates path
end

execute "configure icinga-web" do
  command "./configure"
  cwd path
  creates "#{path}/config.log"
end

execute "install icinga-web" do
  command "make install"
  cwd path
  creates "/usr/local/icinga-web"
end

mysql_root_password = node[:mysql][:server_root_password]
username = 'icinga_web'
password = 'icinga_web'
db = 'icinga_web'
seed_sql_path = path + "/etc/schema/mysql.sql"

execute "create #{username} database user" do
  command %Q( mysql --password="#{mysql_root_password}" --execute="create user '#{username}'@'localhost'
          identified by '#{password}';
          grant all on #{db}.* to '#{username}'@'%';
          flush privileges" )
  not_if %Q( mysql --password="#{mysql_root_password}" --silent --skip-column-names --database=mysql \
        --execute="select User from user where \
        User = '#{username}'" | grep #{username} )
  user "root"
end

execute "create #{db} database" do
  command %Q( mysql --password="#{mysql_root_password}" --execute="create database #{db} character set utf8" )
  not_if %Q( mysql --password="#{mysql_root_password}" --silent --skip-column-names \
      --execute="show databases like '#{db}'" | grep #{db} )
  user "root"
end

execute "initialize #{db} database" do
  command %Q( mysql --password="#{mysql_root_password}" #{db} < #{seed_sql_path} )
  not_if %Q( mysql --password="#{mysql_root_password}" --silent --skip-column-names \
      --execute="show tables in #{db}" | grep cronk )
  user "root"
end

template "#{node[:apache][:dir]}/conf.d/icinga-web.conf" do
  source "icinga-web.conf.erb"
  notifies :restart, "service[apache2]"
end
