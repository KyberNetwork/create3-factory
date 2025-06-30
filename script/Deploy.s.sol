// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "forge-std/StdJson.sol";

import {CREATE3Factory} from "../src/CREATE3Factory.sol";

contract DeployScript is Script {
    using stdJson for string;

    function run() public returns (CREATE3Factory factory) {
        vm.startBroadcast();
        factory = new CREATE3Factory();
        _writeAddress("deployments/create3Factory.json", block.chainid, address(factory));
        vm.stopBroadcast();
    }

    function _writeAddress(string memory path, uint256 chainId, address value) internal {
        if (!vm.isContext(VmSafe.ForgeContext.ScriptBroadcast)) {
            return;
        }
        vm.serializeJson(path, _getJsonString(path));
        vm.writeJson(path.serialize(vm.toString(chainId), value), path);
    }

    function _getJsonString(string memory path) internal view returns (string memory) {
        try vm.readFile(path) returns (string memory json) {
            return json;
        } catch {
            return "{}";
        }
    }
}
