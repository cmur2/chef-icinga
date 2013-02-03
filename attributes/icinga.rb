default[:icinga][:version] = "1.8.4"
default[:icinga][:checksum] = "e1ecbc6c83bb"
default[:icinga][:web][:version] = "1.8.1"
default[:icinga][:web][:checksum] = "3f23e94ad0c8"

default[:icinga][:contacts] = []
default[:icinga][:contactgroups] = []

default[:icinga][:hosts] = []
default[:icinga][:hostgroups] = []

default[:icinga][:services] = []
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
