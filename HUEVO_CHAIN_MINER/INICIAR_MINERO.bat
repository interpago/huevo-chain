@echo off
title Minero Oficial Huevo Chain (PoW)
color 0E

echo ================================================================
echo           BIENVENIDO AL MINERO OFICIAL DE HUEVO CHAIN
echo         Blockchain Soberana Proof-of-Work - Moneda: HV
echo ================================================================
echo.

if not exist "wallet.txt" (
    echo [CONFIGURACION INICIAL]
    echo Para que las monedas que mines lleguen a tu MetaMask,
    echo pega a continuacion tu direccion publica de Ethereum/Polygon (0x...):
    echo.
    set /p WALLET="Direccion (0x...): "
    echo %WALLET% > wallet.txt
    echo.
    echo [OK] Direccion guardada con exito en wallet.txt!
) else (
    set /p WALLET=<wallet.txt
    echo Minando hacia tu billetera guardada: %WALLET%
    echo (Si deseas cambiarla, edita el archivo wallet.txt o ejecuta CAMBIAR_BILLETERA.bat)
)

echo.
if not exist "data\geth" (
    echo [1/2] Inicializando el bloque Genesis de Huevo Chain...
    bin\geth.exe init --datadir .\data genesis.json
    echo [OK] Genesis configurado.
)

echo.
echo [2/2] Arrancando el motor de mineria...
echo Por cada bloque que descubra tu computador, ganaras +2 HV reales.
echo Puedes dejar esta ventana abierta en segundo plano para minar.
echo.
echo Presiona Ctrl+C para pausar la mineria en cualquier momento.
echo ================================================================
echo.

bin\geth.exe ^
  --datadir .\data ^
  --networkid 882323 ^
  --port 30304 ^
  --bootnodes "enode://dbd5ace51c871c29cb8b24bbd9f84547e2b97dd1423dfc34957dc94cbc72ae611459a6e484d00c42a0dc73438216f780433d6b8ec611f2c40a4b79da67888105@191.95.132.199:30303" ^
  --mine ^
  --miner.threads 1 ^
  --miner.etherbase %WALLET% ^
  --cache 256

pause
