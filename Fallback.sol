// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

/*  
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
    receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    
    Note:
    1. fallback function(receive/fallback) will run if a function is called but there is no such a function in that contract
    2. Fallback contract will not work if send ether and send data at the same time
    3. FallbackPayable contract will work if send ether and send data at the same time
*/

contract Fallback {
    event log(string functionName, uint256 value);

    // Function to receive Ether. msg.data must be empty
    receive() external payable{
        // receive ether when no data
        // higher priority if there is no data

        emit log("receive function", msg.value);
    }

    fallback() external{
        //if call 

        emit log("fallback function", 0);
    }

    function test(uint256 number) external{
        emit log("test function", number);
    }
}

contract FallbackPayable{
    event log(string functionName, uint256 value);

    // Function to receive Ether. msg.data must be empty
    receive() external payable{
        // receive ether when no data
        // higher priority if there is no data

        emit log("receive function", msg.value);
    }

    fallback() external payable{
        //if call 

        emit log("fallback function", 0);
    }

    function test(uint256 number) external{
        emit log("test function", number);
    }
}

contract Tester{
    address public calledContract;
    event log(string functionName, uint256 value);

    constructor(address _calledContract){
        calledContract = _calledContract;
    }

    function callFallbackContract(string memory functionName) external payable{
        emit log("call Tester", 0);

        (bool success, ) = calledContract.call{value: msg.value}(
            abi.encodeWithSignature(functionName, 1)
        );

        require(success, "Call Fallback contract failed");
    }
}