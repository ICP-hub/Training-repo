// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BillCalculator} from "../src/discount.sol";

contract CounterScript is Script {
    BillCalculator public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new BillCalculator();

        vm.stopBroadcast();
    }
}
