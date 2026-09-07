#!/usr/bin/env bash
# Huevo Chain - Linux/macOS Miner & Node Script
set -e

echo "================================================================"
echo "          HUEVO CHAIN - MINERO PROOF OF WORK (POW)"
echo "================================================================"
echo ""

if [ -z "$1" ]; then
    echo "Uso: bash mine.sh <TU_DIRECCION_METAMASK>"
    echo "Ejemplo: bash mine.sh 0x75e91570444AEa728B55700243E75a4206f29bB4"
    exit 1
fi

WALLET=$1
echo "Minando con destino a: $WALLET"

if [ ! -d "data/geth" ]; then
    echo "Inicializando bloque genesis..."
    geth init --datadir ./data genesis.json
fi

echo "Iniciando minero en 1 hilo de CPU..."
geth \
  --datadir ./data \
  --networkid 882323 \
  --port 30304 \
  --bootnodes "enode://dbd5ace51c871c29cb8b24bbd9f84547e2b97dd1423dfc34957dc94cbc72ae611459a6e484d00c42a0dc73438216f780433d6b8ec611f2c40a4b79da67888105@191.95.132.199:30303" \
  --mine \
  --miner.threads 1 \
  --miner.etherbase "$WALLET" \
  --cache 256
