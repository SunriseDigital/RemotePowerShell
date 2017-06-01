Add-Type -Language CSharp @"
public class RPSServer{
    public string AdminPassword {get; private set;}
    public string Host {get; private set;}
    public string Name {get; private set;}
    public RPSServer(string pwd, string host, string name)
    {
      AdminPassword = pwd;
      Host = host;
      Name = name;
    }
}
"@;

function Get-RPSServer {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$false)]
      [string]$name,

      [parameter(Mandatory=$false)]
      [string]$hostAddress
  )
  PROCESS {
    $servers = $(
      (new-object RPSServer "Administrator password", "Host address", "Name to identify")
    )
    # If there is no argument, display the whole list.
    if($name -eq "" -and $hostAddress -eq ""){
      return $servers
    }

    # Search by name.
    if($name -ne ""){
      return $servers | ?{$_.Name -like $name}
    }

    # Seach by ip address.
    if($hostAddress -ne ""){
      return $servers | ?{$_.Host -like $hostAddress}
    }
  }
}
