
include_recipe "icinga::source"
include_recipe "icinga::plugins"
include_recipe "icinga::web-source"

service "ido2db" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

service "icinga" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "mysql" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
