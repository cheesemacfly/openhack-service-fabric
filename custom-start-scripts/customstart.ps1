$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

echo "trying to map azure stroage"
net use Z: \\aboichevstorage.file.core.windows.net\mincraft /u:AZURE\aboichevstorage xHD/j9e1SCfrVyOEoijK/Sa8UQj0jgVD5VP4H6XQ2GJUMGvfFa3Mz/5u2lOactiy6cyA6K5A2pIeRyyE2DQeNA==


if((Get-ChildItem Z:\ -Force | Select-Object -First 1 | Measure-Object).Count -eq 0)
{
   echo "Empty data volume detected. Populating with default world"
   cp -r C:\default\* Z:
}

Start-Job -ScriptBlock {
  while((Select-String -Pattern 'RCON running' -Path C:\minecraft\minecraft.out) -eq $null) { Write-Output "nothing"; Start-Sleep -Seconds 1 }
  rcon-cli --host 127.0.0.1 --port 25575 --password cheesesteakjimmys ban b973ece7-93e7-477e-a69a-d22554953e89
} | Out-Null

powershell -File C:\minecraft\start.ps1 | Tee-Object C:\minecraft\minecraft.out