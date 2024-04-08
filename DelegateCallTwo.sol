// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

/*  How to Test:
    1. Deploy DeployedContract
    2. Deploy CallDeployedContract using address from DeployedContract
    3. use any number and call normalChangeNumber
    4. use any number, call delegateChangeNumber and see the difference

    Things to remember:
    1. Delegate call sensitive to the sequence of declared variable of deployed contract
    2. contract in solidity can be convert to address using typecasting and vice versa
*/

contract DeployedContract {
    uint256 public oldNumber;
    event NumberChanged(address fromAddress, uint256 newNumber); // for logging

    function changeNumber(uint256 newNumber)public{
        oldNumber = newNumber;
        emit NumberChanged(msg.sender, newNumber); // for logging
    }
}

contract CallDeployedContract{
    uint256 public oldNumber;
    address public deployedContract;

    constructor(address _deployedContract){
        deployedContract = _deployedContract;
    }

    function delegateChangeNumber(uint256 newNumber) public { //will change the number variable in this contract(CallDeployedContract)
        (bool success, ) = deployedContract.delegatecall(
            abi.encodeWithSignature("changeNumber(uint256)", newNumber)
        );

        require(success, "Delegate call failed");
    }

    function normalChangeNumber(uint256 newNumber) public { //will change the number variable in DeployedContract
        (bool success, ) = deployedContract.call(
            abi.encodeWithSignature("changeNumber(uint256)", newNumber)
        );

        require(success, "Normal call failed");
    }
}