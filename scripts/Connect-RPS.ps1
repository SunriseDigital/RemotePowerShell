function Connect-RPS{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPSServer]$server
  )
  PROCESS {
    # Connect to server
    Write-Host "Connect to $($server.Address) [$($server.Name)]"
    $username = $server.User
    $pass = ConvertTo-SecureString -AsPlainText $server.Password -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$pass

    Enter-PSSession -ComputerName $server.Address -Credential $cred
  }
}
