const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');
const solc = require('solc');

const RPC_URL = 'http://127.0.0.1:8545';
const EDER_WALLET = '0x75e91570444AEa728B55700243E75a4206f29bB4';

async function setEtherbase(address) {
  const res = await fetch(RPC_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      method: 'miner_setEtherbase',
      params: [address],
      id: 1
    })
  });
  return res.json();
}

async function compileContract() {
  const sourcePath = path.join(__dirname, '../contracts/HuevoFaucet.sol');
  const source = fs.readFileSync(sourcePath, 'utf8');

  const input = {
    language: 'Solidity',
    sources: {
      'HuevoFaucet.sol': { content: source }
    },
    settings: {
      evmVersion: 'london',
      outputSelection: {
        '*': {
          '*': ['abi', 'evm.bytecode']
        }
      }
    }
  };

  console.log('Compilando HuevoFaucet.sol con solc...');
  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  if (output.errors) {
    for (const err of output.errors) {
      console.error(err.formattedMessage);
      if (err.severity === 'error') process.exit(1);
    }
  }

  const contract = output.contracts['HuevoFaucet.sol']['HuevoFaucet'];
  return {
    abi: contract.abi,
    bytecode: '0x' + contract.evm.bytecode.object
  };
}

async function main() {
  console.log('--- DESPLIEGUE DEL PRIMER SMART CONTRACT DE HUEVO CHAIN ---');
  const provider = new ethers.providers.JsonRpcProvider(RPC_URL);

  // Crear wallet efímera para el despliegue
  const deployer = ethers.Wallet.createRandom().connect(provider);
  console.log('Deployer Wallet generada:', deployer.address);

  console.log('Configurando minero para fondear la wallet de despliegue...');
  await setEtherbase(deployer.address);

  // Esperar a que mine al menos 1 bloque (2 HV)
  console.log('Esperando a que el minero resuelva 1 bloque con recompensas...');
  let balance = ethers.BigNumber.from(0);
  while (balance.eq(0)) {
    await new Promise(r => setTimeout(r, 2000));
    balance = await provider.getBalance(deployer.address);
    process.stdout.write('.');
  }
  console.log('\n¡Bloque minado! Saldo del deployer:', ethers.utils.formatEther(balance), 'HV');

  // Compilar contrato
  const { abi, bytecode } = await compileContract();

  // Desplegar contrato con 1 HV de saldo inicial para el Faucet
  console.log('Desplegando HuevoFaucet con 1.0 HV de saldo inicial...');
  const factory = new ethers.ContractFactory(abi, bytecode, deployer);
  const contract = await factory.deploy({
    value: ethers.utils.parseEther('1.0'),
    gasLimit: 1500000
  });

  console.log('Esperando confirmación en el siguiente bloque minado...');
  await contract.deployed();

  console.log('====================================================');
  console.log('🎉 ¡CONTRATO INTELIGENTE DESPLEGADO CON ÉXITO!');
  console.log('Dirección del Contrato:', contract.address);
  console.log('Transacción de despliegue:', contract.deployTransaction.hash);
  console.log('Saldo inicial del Faucet:', '1.0 HV');
  console.log('====================================================');

  // Restaurar el minero a la billetera de Eder
  console.log('Restaurando minero a la billetera de Eder:', EDER_WALLET);
  await setEtherbase(EDER_WALLET);

  // Guardar datos en docs/contract.json para la web
  const contractData = {
    address: contract.address,
    txHash: contract.deployTransaction.hash,
    network: 'Huevo Chain',
    chainId: 882323,
    symbol: 'HV',
    abi
  };

  fs.writeFileSync(
    path.join(__dirname, '../docs/contract.json'),
    JSON.stringify(contractData, null, 2)
  );
  console.log('Información guardada en docs/contract.json');
}

main().catch(err => {
  console.error('Error en el despliegue:', err);
  setEtherbase(EDER_WALLET);
});
