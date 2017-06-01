Add-Type -Language CSharp @"
public class RPSServer{
    public string User {get; private set;}
    public string Password {get; private set;}
    public string Address {get; private set;}
    public string Name {get; private set;}
    public RPSServer(string user, string pwd, string address, string name)
    {
      User = user;
      Password = pwd;
      Address = address;
      Name = name;
    }
}
"@;

function Get-RPSServer {
  [CmdletBinding()]
  param (
      [parameter(Mandatory=$false)]
      [string]$Name,

      [parameter(Mandatory=$false)]
      [string]$Address,

      [switch]$Regex
  )
  PROCESS {
    $servers = $(
      (new-object RPSServer "Administrator password", "Host address", "Name to identify")
    )

    return $servers `
      | ?{ if($Name -eq "") { $True } else { if( $Regex ) { $_.Name -match $Name } else { $_.Name -like $Name } } } `
      | ?{ if($Address -eq "") { $True } else { if( $Regex ) { $_.Address -match $Address } else { $_.Address -like $Address } } }
  }
}
