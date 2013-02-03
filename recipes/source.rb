
include_recipe "mysql::server"
include_recipe "build-essential"

user "icinga"

group "icinga" do
  members ["icinga", "www-data"]
end

group "icinga-cmd" do
  members ["icinga"]
end

case node[:platform]
when "debian"
  package "libgd2-xpm-dev"
  package "libjpeg62"
  package "libjpeg62-dev"
  package "libpng12-0"
  package "libpng12-0-dev"
  package "libdbi0"
  package "libdbi0-dev" if node[:platform_version].to_i <= 6
  package "libdbi-dev" if node[:platform_version].to_i >= 7
  package "libdbd-mysql"
  package "snmp"
  package "libsnmp-dev"
#when "ubuntu"
end

version = node[:icinga][:version]
path = "/usr/src/icinga-#{version}"
install_path = "/usr/local/icinga"

remote_file "#{path}.tar.gz" do
  source "http://downloads.sourceforge.net/project/icinga/icinga/#{version}/icinga-#{version}.tar.gz"
  checksum node[:icinga][:checksum]
end

execute "untar icinga" do
  command "tar xzf icinga-#{version}.tar.gz"
  creates path
  cwd "/usr/src"
end

execute "configure icinga" do
  command "./configure --with-command-group=icinga-cmd --enable-idoutils"
  creates "#{path}/config.log"
  cwd path
end

execute "build icinga" do
  command "make all"
  creates "#{path}/common/shared.o"
  cwd path
end

execute "install icinga" do
  command "make fullinstall"
  creates "#{install_path}/bin/icinga"
  cwd path
end

execute "install icinga-config" do
  command "make install-config"
  creates "#{install_path}/etc/icinga.cfg"
  cwd path
end

template "#{install_path}/etc/icinga.cfg" do
  source "icinga.cfg.erb"
  owner "icinga"
  group "icinga"
  notifies :reload, "service[icinga]"
end

template "#{install_path}/etc/conf.d/contacts.cfg" do
  source "contacts.cfg.erb"
  owner "icinga"
  group "icinga"
  variables( :contacts => node[:icinga][:contacts], :contactgroups => node[:icinga][:contactgroups] )
  notifies :reload, "service[icinga]"
end

template "#{install_path}/etc/conf.d/hosts.cfg" do
  source "hosts.cfg.erb"
  owner "icinga"
  group "icinga"
  variables( :hosts => node[:icinga][:hosts], :hostgroups => node[:icinga][:hostgroups] )
  notifies :reload, "service[icinga]"
end

template "#{install_path}/etc/conf.d/services.cfg" do
  source "services.cfg.erb"
  owner "icinga"
  group "icinga"
  variables( :services => node[:icinga][:services], :servicegroups => node[:icinga][:servicegroups] )
  notifies :reload, "service[icinga]"
end

template "#{install_path}/etc/conf.d/timeperiods.cfg" do
  source "timeperiods.cfg.erb"
  owner "icinga"
  group "icinga"
  variables( :timeperiods => node[:icinga][:timeperiods] )
  notifies :reload, "service[icinga]"
end

template "#{install_path}/etc/conf.d/commands.cfg" do
  source "commands.cfg.erb"
  owner "icinga"
  group "icinga"
  variables( :commands => node[:icinga][:commands] )
  notifies :reload, "service[icinga]"
end

execute "copy idomod sample config" do
  command "cp idomod.cfg-sample idomod.cfg"
  creates "#{install_path}/etc/idomod.cfg"
  cwd "#{install_path}/etc"
end
file "#{install_path}/etc/idomod.cfg" do
  owner "icinga"
  group "icinga"
end

execute "move ido2db sample config" do
  command "cp ido2db.cfg-sample ido2db.cfg"
  creates "#{install_path}/etc/ido2db.cfg"
  cwd "#{install_path}/etc"
end
file "#{install_path}/etc/ido2db.cfg" do
  owner "icinga"
  group "icinga"
end

execute "move idoutil sample config" do
  command "cp idoutils.cfg-sample idoutils.cfg"
  creates "#{install_path}/etc/modules/idoutils.cfg"
  cwd "#{install_path}/etc/modules"
end
file "#{install_path}/etc/modules/idoutils.cfg" do
  owner "icinga"
  group "icinga"
end

mysql_root_password = node[:mysql][:server_root_password]
username = 'icinga'
password = 'icinga'
db = 'icinga'
seed_sql_path = "#{path}/module/idoutils/db/mysql/mysql.sql"

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
      --execute="show tables in #{db}" | grep icinga_commands )
  user "root"
end
