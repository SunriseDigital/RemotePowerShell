function Create-Credential{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPSServer]$Server
  )
  PROCESS {
    $username = $Server.User
    $pass = ConvertTo-SecureString -AsPlainText $Server.Password -Force
    return New-Object System.Management.Automation.PSCredential -ArgumentList $username,$pass
  }
}
