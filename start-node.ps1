$baseDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $baseDir

& ".\bin\geth.exe" `
  --datadir ".\data" `
  --networkid 882323 `
  --http `
  --http.addr "127.0.0.1" `
  --http.port 8545 `
  --http.corsdomain "*" `
  --http.vhosts "*" `
  --http.api "eth,net,web3,personal,txpool,miner" `
  --mine `
  --miner.threads 1 `
  --miner.etherbase "0x75e91570444AEa728B55700243E75a4206f29bB4" `
  --port 30303 `
  --cache 256
