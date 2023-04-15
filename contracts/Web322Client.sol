// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Web322.sol";

abstract contract Web322Client {
    using Web322 for Web322.Request;

    address private constant oracle_addr = 0xDA75E6AA92629eA4D45Aa3D478ecb6d7BE9A3Ab2; 
    mapping(uint256 => address) private pendingRequests;
    uint256 n_request = 0;

    event Web2Request(Web322.Request request);
    event FulfilledWeb2Request(uint256 requestId);

    function buildWeb2Request(
        uint256 requestId,
        string memory endpoint
        //address callbackAddr
    ) internal pure returns (Web322.Request memory) {
        Web322.Request memory request;
        request.initialize(requestId); //, callbackAddr);
        request.add("get", endpoint);
        return request;
    }

    function sendWeb322Request(
        Web322.Request memory req,
        uint256 amount
    ) internal {
        bytes memory encodedRequest = abi.encodeWithSignature(
            "request(Web322.Request calldata req)", req);
        pendingRequests[n_request] = oracle_addr;
        (bool success, ) = payable(oracle_addr).call{value: amount}(encodedRequest);
        require(success, "Call failed");
    }

    modifier recordWeb322Fulfillment(uint256 requestId) {
        require(msg.sender == oracle_addr, "Source must be the unique oracle of the request");
        delete pendingRequests[requestId];
        emit FulfilledWeb2Request(requestId);
        _;
    }
}