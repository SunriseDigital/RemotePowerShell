# RemotePowerShell

## Auto load

To load files automatically when PowerShell is started you need to enable $profile.

Please open the terminal of PowerShell and check if the $ profile file exists.

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
Get-ChildItem "C:\Projects\RemotePowerShell\scripts\*.ps1" | %{.$_}
```
