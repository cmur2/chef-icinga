default[:icinga][:version] = "1.8.4"
default[:icinga][:checksum] = "e1ecbc6c83bb"
default[:icinga][:web][:version] = "1.8.1"
default[:icinga][:web][:checksum] = "3f23e94ad0c8"

# ICINGA SAMPLE CONFIGURATION

# template section (these get a "register 0" automatically added)

default[:icinga][:template][:contacts] = [
  {
    "name" => "generic-contact",
    "service_notification_period" => "24x7",
    "host_notification_period" => "24x7",
    "service_notification_options" => "w,u,c,r,f,s",
    "host_notification_options" => "d,u,r,f,s",
    "service_notification_commands" => "notify-service-by-email",
    "host_notification_commands" => "notify-host-by-email"
  }
]
default[:icinga][:template][:contactgroups] = []

default[:icinga][:template][:hosts] = [
  {
    "name" => "generic-host",
    "notifications_enabled" => "1",
    "event_handler_enabled" => "1",
    "flap_detection_enabled" => "1",
    "failure_prediction_enabled" => "1",
    "process_perf_data" => "1",
    "retain_status_information" => "1",
    "retain_nonstatus_information" => "1",
    "notification_period" => "24x7"
  }
]
default[:icinga][:template][:hostgroups] = []

default[:icinga][:template][:services] = [
  {
    "name" => "generic-service",
    "active_checks_enabled" => "1",
    "passive_checks_enabled" => "1",
    "parallelize_check" => "1",
    "obsess_over_service" => "1",
    "check_freshness" => "0",
    "notifications_enabled" => "1",
    "event_handler_enabled" => "1",
    "flap_detection_enabled" => "1",
    "failure_prediction_enabled" => "1",
    "process_perf_data" => "1",
    "retain_status_information" => "1",
    "retain_nonstatus_information" => "1",
    "is_volatile" => "0",
    "check_period" => "24x7",
    "max_check_attempts" => "3",
    "normal_check_interval" => "10",
    "retry_check_interval" => "2",
    "contact_groups" => "admins",
    "notification_options" => "w,u,c,r",
    "notification_interval" => "60",
    "notification_period" => "24x7"
  }
]
default[:icinga][:template][:servicegroups] = []

default[:icinga][:template][:timeperiods] = []
default[:icinga][:template][:commands] = []

# normal section

default[:icinga][:contacts] = [
  {
    "use" => "generic-contact",
    "contact_name" => "admin",
    "contactgroups" => "admins",
    "alias" => "Admin",
    "email" => "root@localhost"
  }
]
default[:icinga][:contactgroups] = [
  {
    "contactgroup_name" => "admins",
    "alias" => "Admins"
  }
]

default[:icinga][:hosts] = [
  {
    "use" => "generic-host",
    "host_name" => "localhost",
    "alias" => "localhost",
    "address" => "127.0.0.1"
  }
]
default[:icinga][:hostgroups] = []

default[:icinga][:services] = [
  {
    "use" => "generic-service",
    "host_name" => "localhost",
    "service_description" => "Ping",
    "check_command" => "check_ping!100.0,1%!500.0,10%"
  },
  {
    "use": "generic-service",
    "host_name": "localhost",
    "service_description": "SSH",
    "check_command": "check_ssh"
  }
]
default[:icinga][:servicegroups] = []

default[:icinga][:timeperiods] = [
  {
    "timeperiod_name" => "24x7",
    "alias" => "24 Hours A Day, 7 Days A Week",
    "sunday" => "00:00-24:00",
    "monday" => "00:00-24:00",
    "tuesday" => "00:00-24:00",
    "wednesday" => "00:00-24:00",
    "thursday" => "00:00-24:00",
    "friday" => "00:00-24:00",
    "saturday" => "00:00-24:00"
  },
  {
    "timeperiod_name" => "workhours",
    "alias" => "Normal Work Hours",
    "monday" => "09:00-17:00",
    "tuesday" => "09:00-17:00",
    "wednesday" => "09:00-17:00",
    "thursday" => "09:00-17:00",
    "friday" => "09:00-17:00"
  },
  {
    "timeperiod_name" => "none",
    "alias" => "No Time Is A Good Time"
  }
]

default[:icinga][:commands] = [
  {
    "command_name" => "notify-host-by-email",
    "command_line" => "/usr/bin/printf \"%b\" \"***** Icinga *****\\n\\nNotification Type: $NOTIFICATIONTYPE$\\nHost: $HOSTNAME$\\nState: $HOSTSTATE$\\nAddress: $HOSTADDRESS$\\nInfo: $HOSTOUTPUT$\\n\\nDate/Time: $LONGDATETIME$\\n\" | /usr/bin/mail -s \"** $NOTIFICATIONTYPE$ Host Alert: $HOSTNAME$ is $HOSTSTATE$ **\" $CONTACTEMAIL$"
  },
  {
    "command_name" => "notify-service-by-email",
    "command_line" => "/usr/bin/printf \"%b\" \"***** Icinga *****\\n\\nNotification Type: $NOTIFICATIONTYPE$\\n\\nService: $SERVICEDESC$\\nHost: $HOSTALIAS$\\nAddress: $HOSTADDRESS$\\nState: $SERVICESTATE$\\n\\nDate/Time: $LONGDATETIME$\\n\\nAdditional Info:\\n\\n$SERVICEOUTPUT$\\n\" | /usr/bin/mail -s \"** $NOTIFICATIONTYPE$ Service Alert: $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **\" $CONTACTEMAIL$"
  },
  {
    "command_name" => "check-host-alive",
    "command_line" => "$USER1$/check_ping -H $HOSTADDRESS$ -w 3000.0,80% -c 5000.0,100% -p 5"
  },
  {
    "command_name" => "check_ping",
    "command_line" => "$USER1$/check_ping -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$ -p 5"
  },
  {
    "command_name" => "check_ssh",
    "command_line" => "$USER1$/check_ssh $ARG1$ $HOSTADDRESS$"
  },
  {
    "command_name" => "check_http",
    "command_line" => "$USER1$/check_http -I $HOSTADDRESS$ $ARG1$"
  }
]
