function Get-RPSServer {
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$false)]
        [string]$name,

        [parameter(Mandatory=$false)]
        [string]$ip
    )
    PROCESS {
      $servers = $(
        @{pwd = "AdministratorPasswaord"; ip = "ServerIPAddress"; name = "NameToIdentify";}
      )

      # If there is no argument, display the whole list.
      if($name -eq "" -and $ip -eq ""){
        return $servers | %{"$($_.ip)`t$($_.pwd)`t$($_.name)"}
      }

      # Search by name.
      if($name -ne ""){
        return $servers | ?{$_.name -like $name}
      }

      # Seach by ip address.
      if($ip -ne ""){
        return $servers | ?{$_.ip -like $ip}
      }
    }
}
