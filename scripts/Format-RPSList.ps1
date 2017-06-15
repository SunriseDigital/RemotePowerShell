<#
.Synopsis
  Format-List for RPSResult.
.Parameter Result
  Target server
.EXAMPLE
  Get-RPSServer test | Get-RPSWebsite | Format-RPSList *
#>
function Format-RPSList{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Result]$Result,

    [parameter(Mandatory=$false,Position=0)]
    [object[]]$Property
  )
  PROCESS {
    $Result.Value | Format-List $Property
  }
}
