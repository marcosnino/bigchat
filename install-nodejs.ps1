[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
$NodeURL = "https://nodejs.org/dist/v18.17.1/node-v18.17.1-win-x64.msi"
$OutFile = "C:\nodejs-installer.msi"
Write-Host "Baixando Node.js v18 LTS..."
(New-Object System.Net.WebClient).DownloadFile($NodeURL, $OutFile)
Write-Host "Download concluído em: $OutFile"
Write-Host "Execute o instalador: msiexec /i $OutFile"
Start-Process -FilePath msiexec.exe -ArgumentList "/i", $OutFile, "/quiet" -Wait
Write-Host "Node.js instalado com sucesso!"
