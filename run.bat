@echo off
setlocal enabledelayedexpansion

echo ========================================
echo CodatendChat - Iniciando Servidor
echo ========================================
echo.

set PATH=C:\nodejs;C:\Program Files\Git\cmd;%PATH%

echo Verificando instalação de dependências...
cd /d c:\codatendechat-main\codatendechat-main\backend

if not exist node_modules (
    echo ERRO: node_modules não encontrado!
    echo Execute setup.bat primeiro
    pause
    exit /b 1
)

echo OK: Dependências encontradas

echo.
echo ========================================
echo Iniciando servidor em desenvolvimento...
echo ========================================
echo.
echo Servidor rodando em: http://localhost:8080
echo Frontend em: http://localhost:3000
echo.
echo Pressione Ctrl+C para parar o servidor
echo.

npm run dev:server

pause
