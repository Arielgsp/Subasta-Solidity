// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;


contract Subasta {
    

    address public owner;
    address public mejorOferente;
    uint256 public mejorOferta;
    uint256 public tiempoFinalizacion;
    bool public finalizada;

    mapping(address => uint256[]) public historialOfertas;
    mapping(address => uint256) public depositos;

    uint public extension = 10 minutes;

    event NuevaOferta(address indexed oferente, uint256 monto);
    event SubastaFinalizada(address indexed ganador, uint256 monto);

    constructor(uint256 _duracionMinutos) {
        owner = msg.sender;
        tiempoFinalizacion = block.timestamp + (_duracionMinutos);
    }

    function ofertar() public payable {
        require(block.timestamp < tiempoFinalizacion, "La subasta ha finalizado");
        require(msg.value > mejorOferta * 105 / 100, "La oferta debe superar en al menos 5% a la actual");

        depositos[msg.sender] += msg.value;
        historialOfertas[msg.sender].push(msg.value);

        mejorOferente = msg.sender;
        mejorOferta = msg.value;

        // Si faltan menos de 10 minutos, extender
        if (tiempoFinalizacion - block.timestamp <= 10 minutes) {
            tiempoFinalizacion += extension;
        }

        emit NuevaOferta(msg.sender, msg.value);
    }

    event ExcesoRetirado(address indexed oferente, uint256 monto);

    function retirarExceso() public {
    require(historialOfertas[msg.sender].length > 0, "Sin ofertas registradas");
    require(!finalizada, "La subasta ha finalizado");

    uint256 totalDepositado = depositos[msg.sender];
    uint256 ultimaOferta = historialOfertas[msg.sender][historialOfertas[msg.sender].length - 1];

    // Si el usuario es el mejor oferente, debe dejar su última oferta en el contrato
    uint256 montoARetirar = (msg.sender == mejorOferente) ? totalDepositado - ultimaOferta : totalDepositado;

    require(montoARetirar > 0, "No hay exceso para retirar");

    // Actualizar el depósito
    depositos[msg.sender] -= montoARetirar;

    // Si no es el mejor oferente, limpiar el historial de ofertas
    if (msg.sender != mejorOferente) {
        delete historialOfertas[msg.sender];
    }

    // Transferir el exceso al usuario
    (bool success, ) = payable(msg.sender).call{value: montoARetirar}("");
    require(success, "Transferencia fallida");

    emit ExcesoRetirado(msg.sender, montoARetirar);
}

    function finalizarSubasta() public {
        require(block.timestamp >= tiempoFinalizacion, "La subasta aun no ha finalizado");
        require(!finalizada, "La subasta ya ha sido finalizada");

        finalizada = true;
        emit SubastaFinalizada(mejorOferente, mejorOferta);

        payable(owner).transfer(mejorOferta);
    }

    function verHistorial(address usuario) public view returns (uint256[] memory) {
        return historialOfertas[usuario];
    }

    function verGanador() public view returns (address, uint256) {
        return (mejorOferente, mejorOferta);
    }
}