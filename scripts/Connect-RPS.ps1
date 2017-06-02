function Connect-RPS{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPSServer]$Server
  )
  PROCESS {
    # Connect to server
    Write-Host "Connect to $($Server.Address) [$($Server.Name)]"
    $username = $Server.User
    $pass = ConvertTo-SecureString -AsPlainText $Server.Password -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$pass

    Enter-PSSession -ComputerName $Server.Address -Credential $cred
  }
}
