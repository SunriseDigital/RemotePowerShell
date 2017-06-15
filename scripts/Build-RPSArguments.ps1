function Build-RPSArguments{
  [CmdletBinding()]
  param (
    [parameter(Mandatory=$false,Position=0)]
    [object[]]$Arguments
  )
  PROCESS {
    if($Arguments -eq $null){
      Write-Output ""
      return
    }
    
    $command = " "

    for ($i = 0; $i -lt $Arguments.count; $i+=2){
      $key = $Arguments[$i]
      $value = $Arguments[$i+1]
      if($value -is [System.Collections.IEnumerable]){
        $value = $value | %{"""${_}"""}
        $value = $($value -join ",")
      } else {
        $value = $value | %{"""${value}"""}
      }

      $command += " ${key} ${value}"
    }

    Write-Output $command
  }
}
