// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Web322.sol";
import "@web322worker/Web322.sol";

abstract contract Web322Client {
    using Web322 for Web322.Request;

    address payable private constant oracle_addr = "0x878474bafd53758d75a2364b82c4f82532"; 

    event Web2Request(Web322.Request request);

    function buildWeb322Request(
        bytes32 requestId,
        string endpoint
        //address callbackAddr
    ) internal pure returns (Web322.Request memory) {
        Web322.Request memory request;
        request.initialize(requestId); //, callbackAddr);
        request.add("get", endpoint);
    }

    function sendWeb322Request(
        Web322.Request memory req,
        uint256 amount,
    ) public returns (bytes32 requestId) external payable {
        (bool success, ) = oracle_addr.call{value: amount}(req);
        require(success, "Call failed");
    }
}