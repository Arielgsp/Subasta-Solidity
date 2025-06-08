# Subasta-Solidity
Ejercicio en Solidity para Ethkipu


# Subasta Smart Contract

Este repositorio contiene un contrato inteligente escrito en Solidity para gestionar una subasta en la red de prueba Sepolia. El contrato permite a los usuarios realizar ofertas, retirar excesos de fondos y finalizar la subasta, transfiriendo el monto de la mejor oferta al propietario.

Descripción

El contrato implementa las siguientes funcionalidades:
- Ofertar: Los usuarios pueden enviar ofertas que superen la mejor oferta actual en al menos un 5%.
- Retirar Exceso: Los oferentes pueden retirar todas las ofertas excepto la última si son el mejor oferente, o todo el depósito si no lo son.
- Finalizar Subasta: El propietario puede finalizar la subasta y recibir el monto de la mejor oferta.
- Ver Historial y Ganador: Funciones de vista para consultar el historial de ofertas y el ganador actual.
