@echo off
title DSIM Frontend - Deploy EC2

echo ==========================================
echo DEPLOY FRONTEND DSIM - EC2
echo ==========================================

REM Configuracoes do EC2
set EC2_IP=SEU_IP_EC2
set EC2_USER=ec2-user
set KEY_FILE=C:\path\to\your\dsim_keypair.pem
set REMOTE_PATH=/var/www/html

echo Configuracoes:
echo EC2 IP: %EC2_IP%
echo Usuario: %EC2_USER%
echo Chave: %KEY_FILE%
echo Caminho Remoto: %REMOTE_PATH%

echo.
echo IMPORTANTE: Atualize as variaveis no inicio deste arquivo!

echo.
echo 📦 Instalando dependencias...
call npm install

echo.
echo 🔨 Gerando build de producao...
call npm run build

if %errorlevel% neq 0 (
    echo ❌ Erro no build!
    pause
    exit /b 1
)

echo.
echo 📁 Criando arquivo tar dos arquivos de build...
tar -czf dist.tar.gz -C dist .

echo.
echo ⬆️ Enviando arquivos para EC2...
scp -i "%KEY_FILE%" dist.tar.gz %EC2_USER%@%EC2_IP%:~/

echo.
echo 🔧 Configurando no servidor EC2...
ssh -i "%KEY_FILE%" %EC2_USER%@%EC2_IP% "sudo mkdir -p %REMOTE_PATH% && sudo tar -xzf ~/dist.tar.gz -C %REMOTE_PATH% && sudo chown -R apache:apache %REMOTE_PATH% && sudo systemctl restart httpd"

echo.
echo 🧹 Limpando arquivos temporarios...
del dist.tar.gz

echo.
echo ==========================================
echo ✅ Deploy concluido!
echo 🌐 URL: http://%EC2_IP%
echo ==========================================

echo.
echo PROXIMOS PASSOS:
echo 1. Configure o arquivo .env.production com o IP real do EC2
echo 2. Atualize as variaveis no inicio deste script
echo 3. Certifique-se que o Apache/Nginx esta rodando no EC2
echo 4. Configure o CORS no backend para aceitar o frontend

pause