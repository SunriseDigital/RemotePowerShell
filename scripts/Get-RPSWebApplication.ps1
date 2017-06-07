function Get-RPSWebApplication{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    $pipe,

    [parameter(Mandatory=$false,Position=0)]
    [string]$Name,

    [parameter(Mandatory=$false)]
    [string]$Site


  )
  PROCESS {
    if( $pipe.GetType() -eq [RPS.Server]){
      $Server = $pipe
    } else {
      $Server = $pipe.Server
      $Site = $pipe.Value.name
    }

    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $Site = $args[0]
      $Name = $args[1]

      $command = "Get-WebApplication -Site ""$Site"""

      if($Name -ne ""){
        $command += " -Name $Name"
      }

      Invoke-Expression -Command $command
    } -argumentlist $Site, $Name | %{
      return new-object RPS.Result $Server, $_, "${Site} $($_.path)"
    }
  }
}
