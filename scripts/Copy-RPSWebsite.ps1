<#
.Synopsis
  Duplicate the web application. It also duplicates `Location` in `applicationHost.config`.
.Parameter From
  Specify source site name.
.Parameter To
  Specify destination site name.
.EXAMPLE
  Get-RPSServer | Copy-RPSWebsite "Default Web Site" test_site
#>
function Copy-RPSWebsite{
  [CmdletBinding(PositionalBinding=$true)]
  param (
    [parameter(Mandatory=$true,ValueFromPipeline=$true)]
    [RPS.Server]$Server,

    [parameter(Mandatory=$true,Position=0)]
    [string]$From,

    [parameter(Mandatory=$true,Position=1)]
    [string]$To
  )
  PROCESS {
    $cred = Create-RPSCredential $Server
    Invoke-Command -ComputerName $Server.Address -Credential $cred -ScriptBlock {
      $fromIISName = $args[0]
      $toIISName = $args[1]

      # retry for file lock
      $saveRetry = 0
      function saveIISConfig($iisConfig, $iisConfigPath, $toIISName){
        try{
          $iisConfig.save($iisConfigPath)
        } catch [Exception]{
          if($saveRetry -lt 5){
            $sec = 3
            Write-Host "Fail to save by '$($error[0])'. I will try to save again after ${sec} second..." -foregroundcolor "red"
            Start-Sleep -s $sec
            ++$saveRetry
            saveIISConfig $iisConfig $iisConfigPath $toIISName
          } else {
            Write-Error "Fail to save by '$($error[0])'."
            cmd /c "$Env:Windir\System32\inetsrv\appcmd delete site ""$toIISName"""
          }
        }
      }

      # Check source site is exists.
      $exists = cmd /c "$Env:Windir\System32\inetsrv\appcmd list site /site.name:""${fromIISName}"""
      if($exists.Length -eq 0){
        Write-Host "Not exists ${fromIISName}" -foregroundcolor "red"
        exit 1
      }

      #Check destination site is exists.
      $exists = cmd /c "$Env:Windir\System32\inetsrv\appcmd list site /site.name:""${toIISName}"""
      if($exists.Length -ne 0){
        Write-Host "Already exists ${toIISName}" -foregroundcolor "red"
        exit 1
      }

      $date = Get-Date -Format "yyyyMMdd_HHmmss_fff"
      $xmlPath = "${env:userprofile}\${fromIISName}_${date}.xml"

      # Write it temporarily to xml
      cmd /c "$Env:Windir\System32\inetsrv\appcmd list site ""$fromIISName"" /config /xml" | Set-Content $xmlPath

      # Remove id and set site name.
      $siteConfig = [xml](Get-Content $xmlPath)
      $siteConfig.appcmd.SITE.SetAttribute("SITE.NAME", $toIISName)
      $siteConfig.appcmd.SITE.site.SetAttribute("name", $toIISName)
      $siteConfig.appcmd.SITE.RemoveAttribute("SITE.ID")
      $siteConfig.appcmd.SITE.site.RemoveAttribute("id")
      $siteConfig.save($xmlPath)

      # Create site.
      Get-Content $xmlPath | cmd /c "$Env:Windir\System32\inetsrv\appcmd add site /in" | Write-Host -foregroundcolor "green"

      # Clean temp xml.
      Remove-Item $xmlPath

      # Duplicate the <location /> in applicationHost.config.
      $iisConfigPath = "$Env:Windir\System32\inetsrv\config\applicationHost.config"
      $iisConfig = [xml](Get-Content $iisConfigPath)
      $updateCount = 0

      $iisConfig.configuration.location | where {($_.path -eq "$fromIISName") -Or ($_.path -like "$fromIISName/*")} | foreach {
        $location = $_
        $toPath = $location.path -replace "^$fromIISName(.*)", ($toIISName + '$1')
        #既に対象のlocationがあったら落とす。基本的にはsiteが無かったのであるはずない。同じ名前のlocationが二つあるとIISが死ぬので防御的措置
        if(($iisConfig.configuration.location | where {$_.path -eq $toPath}) -ne $null){
          Write-Host "$toPath location already exists !" -foregroundcolor "red"
          cmd /c "$Env:Windir\System32\inetsrv\appcmd delete site ""$toIISName"""
          exit 1
        }

        $newXml = [xml]$location.OuterXml
        $newLocation = $iisConfig.ImportNode($newXml.location, $true)
        $newLocation.path = $toPath

        $iisConfig.configuration.AppendChild($newLocation) | Out-Null
        Write-Host "Add location[path=${toPath}] to ${iisConfigPath}" -foregroundcolor "green"
        ++$updateCount
      }

      if($updateCount -gt 0){
        saveIISConfig $iisConfig $iisConfigPath $toIISName
      }

    } -argumentlist $From, $To
  }
}
