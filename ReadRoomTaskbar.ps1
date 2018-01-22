[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$Domain = [Microsoft.VisualBasic.Interaction]::InputBox('Enter Domain Name', 'Import TEC Profile')


$explorerprocesses = @(Get-WmiObject -Query "Select * FROM Win32_Process WHERE Name='explorer.exe'" -ErrorAction SilentlyContinue)
if ($explorerprocesses.Count -eq 0)
{
    "No explorer process found / Nobody interactively logged on"
} else {
    foreach ($i in $explorerprocesses)
    {
        $Username = $i.GetOwner().User  
    }
}

$SID = [wmi] "win32_userAccount.Domain='$Domain',Name='$Username'" | select -ExpandProperty SID

New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name "TaskbarNoMultimon" -PropertyType DWORD -Value "1" -Force
New-ItemProperty -Path Registry::\HKEY_USERS\$SID\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name "TaskbarNoMultimon" -PropertyType DWORD -Value "1" -Force


Stop-Process -Name explorer
Start-Sleep 2
Start-Process explorer