// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HuevoFaucet
 * @notice Primer contrato inteligente oficial desplegado en Huevo Chain (Chain ID: 882323).
 * Distribuye monedas HV gratuitas para pruebas a la comunidad.
 */
contract HuevoFaucet {
    string public constant networkName = "Huevo Chain";
    string public constant symbol = "HV";
    uint256 public constant DRIP_AMOUNT = 0.1 ether; // 0.1 HV por solicitud
    uint256 public constant COOLDOWN = 1 minutes;    // 1 minuto de espera entre solicitudes

    address public immutable owner;
    uint256 public totalDisbursed;
    mapping(address => uint256) public lastRequestTime;

    event Drip(address indexed recipient, uint256 amount, uint256 timestamp);
    event Deposit(address indexed sender, uint256 amount);

    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function requestHV() external {
        require(address(this).balance >= DRIP_AMOUNT, "El Faucet no tiene suficiente saldo");
        require(block.timestamp >= lastRequestTime[msg.sender] + COOLDOWN, "Debes esperar 1 minuto antes de solicitar de nuevo");

        lastRequestTime[msg.sender] = block.timestamp;
        totalDisbursed += DRIP_AMOUNT;

        payable(msg.sender).transfer(DRIP_AMOUNT);
        emit Drip(msg.sender, DRIP_AMOUNT, block.timestamp);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
