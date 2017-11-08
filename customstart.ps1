$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

if((Get-ChildItem G:\ -Force | Select-Object -First 1 | Measure-Object).Count -eq 0)
{
   echo "Empty data volume detected. Populating with default world"
   cp -r C:\default\* G:
}

$acctKey = ConvertTo-SecureString -String "rXVm0D7toMHwzS5a2VCINfMGJumM6ZwrpbvkDXp3WHAj5rlOr8clEWj+qn+LmtryyVYX/gTLR37Gn6T71YF+Nw==" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\minecraftshareteam01", $acctKey
New-PSDrive -Name Z -PSProvider FileSystem -Root "\\minecraftshareteam01.file.core.windows.net\data" -Credential $credential

[Environment]::SetEnvironmentVariable("APPDATA", "Z:\minecraft")

Start-Job -ScriptBlock {
  while((Select-String -Pattern 'RCON running' -Path C:\minecraft\minecraft.out) -eq $null) { Write-Output "nothing"; Start-Sleep -Seconds 1 }
  rcon-cli --host 127.0.0.1 --port 25575 --password cheesesteakjimmys ban b973ece7-93e7-477e-a69a-d22554953e89
} | Out-Null

powershell -File C:\minecraft\start.ps1 | Tee-Object C:\minecraft\minecraft.out