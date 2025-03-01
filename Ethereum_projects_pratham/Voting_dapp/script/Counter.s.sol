// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Election} from "../src/voting.sol";

contract CounterScript is Script {
    voting public Voting;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        Voting = new voting();

        vm.stopBroadcast();
    }
}
