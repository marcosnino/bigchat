@echo off
REM Script para instalar Node.js e dependências do CodatendChat

echo ========================================
echo Instalando Node.js v18 LTS
echo ========================================

REM Tentar usar Chocolatey se disponível
choco --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Chocolatey encontrado. Instalando Node.js...
    choco install nodejs --version=18.17.1 -y
    goto fim
)

REM Tentar usar winget se disponível
winget --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Winget encontrado. Instalando Node.js...
    winget install OpenJS.NodeJS.LTS
    goto fim
)

REM Se nenhum package manager estiver disponível
echo.
echo ========================================
echo Nenhum package manager encontrado!
echo ========================================
echo.
echo Por favor, instale Node.js manualmente em:
echo https://nodejs.org/
echo.
echo Depois execute este comando no PowerShell (como admin):
echo $env:Path += ';C:\Program Files\nodejs'
echo.
pause

:fim
echo.
echo Atualizando PATH...
setx PATH "%PATH%;C:\Program Files\nodejs"
echo.
echo Verificando instalação...
node --version
npm --version
echo.
echo Instalação concluída!
pause
