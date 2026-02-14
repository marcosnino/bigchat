@echo off
setlocal enabledelayedexpansion

echo ========================================
echo CodatendChat - Setup Automático
echo ========================================
echo.

REM Configurar Path para Node.js e Git
set PATH=C:\nodejs;C:\Program Files\Git\cmd;%PATH%

echo Verificando Node.js...
node --version
if %errorlevel% neq 0 (
    echo ERRO: Node.js não encontrado!
    pause
    exit /b 1
)

echo.
echo Verificando Git...
git --version
if %errorlevel% neq 0 (
    echo ERRO: Git não encontrado!
    pause
    exit /b 1
)

echo.
echo Configurando Git...
git config --global user.name "Builder"
git config --global user.email "builder@localhost"

echo.
echo Instalando dependências npm (pode levar 10-15 minutos)...
cd /d c:\codatendechat-main\codatendechat-main\backend
npm install --legacy-peer-deps --no-fund

if %errorlevel% neq 0 (
    echo ERRO na instalação de dependências!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Instalação concluída com sucesso!
echo ========================================
echo.
echo Para iniciar o servidor, execute:
echo npm run dev:server
echo.
pause
