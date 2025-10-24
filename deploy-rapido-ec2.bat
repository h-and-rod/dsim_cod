@echo off
title DSIM - Deploy Rapido EC2

echo ==========================================
echo DSIM - DEPLOY RAPIDO PARA EC2
echo ==========================================

REM CONFIGURACOES - ATUALIZE AQUI:
set EC2_IP=SEU_IP_EC2_AQUI
set EC2_USER=ec2-user
set KEY_FILE=C:\path\to\dsim_keypair.pem
set REMOTE_PATH=/var/www/html

echo 📋 Configuracoes atuais:
echo    EC2 IP: %EC2_IP%
echo    Usuario: %EC2_USER%
echo    Chave: %KEY_FILE%
echo    Destino: %REMOTE_PATH%
echo.

if "%EC2_IP%"=="SEU_IP_EC2_AQUI" (
    echo ⚠️ AVISO: Atualize o IP do EC2 no inicio deste arquivo!
    echo.
)

echo 🔨 Build ja esta pronto em dist\
echo 📁 Criando arquivo para upload...

REM Criar tar da dist
tar -czf dsim-frontend.tar.gz -C dist .

if %errorlevel% neq 0 (
    echo ❌ Erro ao criar arquivo tar
    pause
    exit /b 1
)

echo 📤 Enviando para EC2...
scp -i "%KEY_FILE%" dsim-frontend.tar.gz %EC2_USER%@%EC2_IP%:~/

if %errorlevel% neq 0 (
    echo ❌ Erro no upload. Verifique:
    echo    - IP do EC2 correto
    echo    - Caminho da chave .pem
    echo    - Conexao com a internet
    pause
    exit /b 1
)

echo 🔧 Configurando no servidor...
ssh -i "%KEY_FILE%" %EC2_USER%@%EC2_IP% "sudo mkdir -p %REMOTE_PATH% && sudo tar -xzf ~/dsim-frontend.tar.gz -C %REMOTE_PATH% && sudo chown -R ec2-user:ec2-user %REMOTE_PATH% && sudo systemctl restart httpd 2>/dev/null || sudo systemctl restart nginx 2>/dev/null"

if %errorlevel% neq 0 (
    echo ⚠️ Aviso: Erro na configuracao do servidor
    echo    Arquivo foi enviado, mas pode precisar configurar manualmente
)

echo 🧹 Limpando arquivo temporario...
del dsim-frontend.tar.gz

echo.
echo ==========================================
echo ✅ DEPLOY CONCLUIDO!
echo 🌐 Acesse: http://%EC2_IP%
echo ==========================================

echo.
echo 📋 PROXIMOS PASSOS:
echo 1. Acesse http://%EC2_IP% para ver o site
echo 2. Teste a conectividade com o backend
echo 3. Configure SSL se necessario
echo.

echo 🔧 COMANDOS UTEIS:
echo    Rebuild: npm run build
echo    Redeploy: .\deploy-rapido-ec2.bat
echo    Ver logs: ssh -i "%KEY_FILE%" %EC2_USER%@%EC2_IP% "sudo journalctl -u httpd -f"

pause