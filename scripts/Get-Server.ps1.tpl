param([string]$serverName, [string]$ip)

$servers = $(
  @{pwd = "AdministratorPasswaord"; ip = "ServerIPAddress"; name = "NameToIdentify";}
)

# If there is no argument, display the whole list.
if($serverName -eq "" -and $ip -eq ""){
  $servers | %{"$($_.ip)`t$($_.pwd)`t$($_.name)"}
  exit 0
}

# Search by name.
if($serverName -ne ""){
  $servers | ?{$_.name -like $serverName}
  exit 0
}

# Seach by ip address.
if($ip -ne ""){
  $server = $servers | ?{$_.ip -like $ip}
  exit 0
}
