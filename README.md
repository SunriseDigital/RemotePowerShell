# RemotePowerShell

A set of cmdlets that runs the same PowerShell cmdlets for multiple remote servers.

## Installation

Please put source in any directory.

```
cd C:\path\to\RemotePowerShell\dir
git clone git@github.com:SunriseDigital/RemotePowerShell.git
```

### Auto load setting

To load files automatically when PowerShell is started you need to enable $profile.

Please open the terminal of PowerShell and check the $ profile file exists.

```ps1
test-path $profile
```

If the result is False, create a $profile file with the following command.

```ps1
new-item -path $profile -itemtype file -force
```

You can check the path of the $ profile file with `$profile`.

```ps1
PS > $profile
C:\Path\To\Microsoft.PowerShell_profile.ps1
```

Edit the $profile as below.

```ps1
Get-ChildItem "C:\path\to\RemotePowerShell\dir\scripts\*.ps1" | %{.$_}
```

If you want to reload, you can restart the shell or with `. $profile`.

### Server settings

First, copy `include \ servers.ps1.tpl` and change the name to `servers.ps1`.

```ps1
Copy-Item C:\path\to\RemotePowerShell\dir\scripts\include\servers.ps1.tpl C:\path\to\RemotePowerShell\dir\scripts\include\servers.ps1
```

And, added server settgins to servers.ps1

```ps1
$servers = $(
  (new-object RPS.Server "Administrator", "**Administrator password**", "192.168.0.1", "test")
)
```

1. Login user name.
1. Login user password.
1. Server address.
1. Server name.

Do not forget to reload.

```ps1
. $profile
```

You can confirm server setting with the following command.

```ps1
Get-RPSServer

User          Password         Address        Name
----          --------         -------        ----
Administrator **Administrator  192.168.0.1    test
```

### Server side settings

1. For safety, set 5985 port of the firewall of the destination server so that it can connect only from a specific remote IP address.

```ps1
Get-NetFirewallPortFilter | ? {$_.LocalPort -eq 5985 -and $_.Protocol -eq "TCP"} | Get-NetFirewallRule | ? {$_.Direction –eq "Inbound"} | Set-NetFirewallRule -RemoteAddress ***.***.***.***
```

2. Execute the following cmdlet and select `Y` for all options. You need administrator privileges.

```ps1
Enable-PSRemoting
```

3. Register the IP address of the destination server in TrustedHosts of the source PC.

```ps1
Set-Item WSMan:\localhost\Client\TrustedHosts -Value ***.***.***.***
```


## Cmdlets

If you want to know the details of the cmdlet, please use `Get-Help`.

```ps1
Get-Help Get-RPSServer -full
```

* Copy-RPSWebsite
* Create-RPSCredential
* Enter-RPSSession
* Format-RPSList
* Get-RPSNetFirewallAddressFilter
* Get-RPSNetFirewallApplicationFilter
* Get-RPSNetFirewallPortFilter
* Get-RPSNetFirewallRule
* Get-RPSServer
* Get-RPSWebApplication
* Get-RPSWebAppPool
* Get-RPSWebsite
* Restart-RPSWebAppPool
* Set-RPSNetFirewallRule
