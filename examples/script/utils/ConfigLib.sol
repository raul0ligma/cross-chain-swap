// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { Vm } from "forge-std/Vm.sol";

struct Config {
    uint32 cancellationDstTimelock;
    uint32 cancellationSrcTimelock;
    uint256 chainId;
    address deployer;
    bytes32 deployerPK;
    uint256 dstAmount;
    address dstToken;
    address escrowFactory;
    address limitOrderProtocol;
    address maker;
    bytes32 makerPK;
    uint32 publicCancellationSrcTimelock;
    uint32 publicWithdrawalDstTimelock;
    uint32 publicWithdrawalSrcTimelock;
    address resolver;
    uint32 resolverFee;
    string rpcUrl;
    uint256 safetyDeposit;
    string secret;
    uint256 srcAmount;
    address srcToken;
    string[] stages;
    uint32 withdrawalDstTimelock;
    uint32 withdrawalSrcTimelock;
}

library ConfigLib {
    function getConfig(Vm vm, string memory fileName) internal view returns (Config memory) {
        string memory json = vm.readFile(fileName);
        bytes memory data = vm.parseJson(json);
 
        Config memory config = abi.decode(data, (Config));

        return config;
    }
}