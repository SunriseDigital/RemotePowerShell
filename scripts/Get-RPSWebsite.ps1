function Get-RPSWebsite{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPSServer]$Server,

    [parameter(Mandatory=$false,Position=0)]
    [string]$Name
  )
  PROCESS {
    $username = $Server.User
    $pass = ConvertTo-SecureString -AsPlainText $Server.Password -Force
    $cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$pass

    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Server = $args[0]
      $Name = $args[1]

      $command = "Get-Website"

      if($Name -ne ""){
        $command += " -Name $Name"
      }

      Invoke-Expression -Command $command
    } -argumentlist $Server, $Name | %{
      return new-object RPSResult $Server, $_
    }
  }
}
