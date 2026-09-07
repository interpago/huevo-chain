@echo off
title Cambiar Billetera - Huevo Chain
color 0B
echo ================================================================
echo           CAMBIAR BILLETERA DE PAGO - HUEVO CHAIN
echo ================================================================
echo.
echo Introduce tu nueva direccion de MetaMask (0x...):
set /p NEW_WALLET="Nueva Direccion: "
echo %NEW_WALLET% > wallet.txt
echo.
echo [OK] Billetera actualizada a: %NEW_WALLET%
echo La proxima vez que inicies INICIAR_MINERO.bat minaras a esta direccion.
echo.
pause
