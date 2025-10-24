@echo off
title DSIM - Limpeza de Duplicacao Frontend

echo ==========================================
echo DSIM - LIMPEZA DE DUPLICACAO FRONTEND
echo ==========================================

echo.
echo 📊 ANALISE DOS PROJETOS:
echo.
echo 1. RAIZ: c:\Users\flavi\OneDrive\Area de Trabalho\DSIM\
echo    ✅ Tem global.d.ts (tipos TypeScript)
echo    ✅ Historico atualizado
echo    ✅ Build funcionando 100%%
echo    ✅ 41 arquivos
echo.
echo 2. DESENVOLVIMENTO: \Desenvolvimento\3.Implementacao\DSIM-COD\frontend\
echo    ❌ SEM global.d.ts (erros TypeScript)
echo    ❌ Historico desatualizado  
echo    ❌ 40 arquivos
echo.

echo 🎯 RECOMENDACAO: Manter apenas o da RAIZ
echo    Motivo: Unico com tipos TypeScript completos
echo.

set /p escolha="Deseja remover o projeto da pasta Desenvolvimento? (S/N): "

if /i "%escolha%"=="S" (
    echo.
    echo 🗑️ Removendo projeto duplicado da pasta Desenvolvimento...
    
    cd "c:\Users\flavi\OneDrive\Área de Trabalho\DSIM\Desenvolvimento\3.Implementação\DSIM-COD"
    
    if exist frontend\ (
        echo Copiando global.d.ts primeiro (backup)...
        if not exist backup\ mkdir backup
        copy frontend\src\types\*.* backup\ 2>nul
        
        echo Removendo frontend\dist\...
        rmdir /s /q frontend\dist 2>nul
        
        echo Removendo frontend\node_modules\...
        rmdir /s /q frontend\node_modules 2>nul
        
        echo Removendo frontend\src\... (codigo duplicado)
        rmdir /s /q frontend\src 2>nul
        
        echo Mantendo apenas arquivos de configuracao...
        del /q frontend\package-lock.json 2>nul
        
        echo.
        echo ✅ Limpeza concluida!
        echo.
        echo 📁 MANTIDO na pasta Desenvolvimento:
        echo    - package.json, .env files
        echo    - Scripts de deploy 
        echo    - index.html, vite.config.ts
        echo.
        echo 🗑️ REMOVIDO:
        echo    - src\ (codigo fonte duplicado)
        echo    - dist\ (build)
        echo    - node_modules\ (dependencias)
        echo.
        echo 🎯 PROJETO PRINCIPAL (usar sempre):
        echo    c:\Users\flavi\OneDrive\Area de Trabalho\DSIM\
        echo.
        echo 💾 ECONOMIA DE ESPAÇO: ~650MB liberados
    ) else (
        echo ❌ Pasta frontend nao encontrada!
    )
    
) else (
    echo.
    echo ℹ️ Nenhuma alteracao feita.
    echo.
    echo ⚠️ IMPORTANTE: Voce tem DUPLICACAO DESNECESSARIA:
    echo.
    echo 📊 Comparacao:
    echo    RAIZ: 41 arquivos + global.d.ts (COMPLETO)
    echo    DESENVOLVIMENTO: 40 arquivos - global.d.ts (INCOMPLETO)
    echo.
    echo 🎯 PARA DEPLOY EC2: Use SEMPRE o projeto da RAIZ
    echo    Caminho: c:\Users\flavi\OneDrive\Area de Trabalho\DSIM\
    echo    Comando: .\deploy-ec2.bat
    echo.
    echo 💡 Razao: Apenas a RAIZ tem os tipos TypeScript necessarios!
)

echo.
echo ==========================================
pause