// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {KintoID} from "../../src/KintoID.sol";
import {MigrationHelper} from "@kinto-core-script/utils/MigrationHelper.sol";
import "@openzeppelin/contracts/access/IAccessControl.sol";

contract UpgradeKintoIDScript is MigrationHelper {
    function run() public override {
        super.run();

        bytes memory bytecode = abi.encodePacked(
            type(KintoID).creationCode,
            abi.encode(_getChainDeployment("KintoWalletFactory"), _getChainDeployment("Faucet"))
        );

        address impl = _deployImplementationAndUpgrade("KintoID", "V12", bytecode);
        saveContractAddress("KintoIDV12-impl", impl);

        KintoID kintoID = KintoID(_getChainDeployment("KintoID"));

        assertTrue(kintoID.isKYC(deployer));
    }
}
