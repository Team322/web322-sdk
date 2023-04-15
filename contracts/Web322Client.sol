// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Web322.sol";
import "./Web322Endpoint.sol";

abstract contract Web322Client {
    using Web322 for Web322.Request;

    address public _oracle_addr; 
    address public _admin_addr; 
    mapping(uint256 => address) private pendingRequests;
    uint256 n_request = 0;

    event Web2Request(Web322.Request request);
    event FulfilledWeb2Request(uint256 requestId);

    function setAddresses(
        address oracle_addr,
        address admin_addr
    ) internal {
        _oracle_addr = oracle_addr;
        _admin_addr = admin_addr;
    }

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
        // bytes memory encodedRequest = abi.encodeWithSignature(
        //     "request(Web322.Request calldata req)", req);
        bytes memory encodedRequest = abi.encodeWithSelector(0x6ac67648, [req]);
        pendingRequests[n_request] = _oracle_addr;
        (bool success, ) = payable(_oracle_addr).call{value: amount}(encodedRequest);
        require(success, "Call failed");
    }

    modifier recordWeb322Fulfillment(uint256 requestId) {
        require(msg.sender == _admin_addr, "Source must be the Web322 admin contract");
        delete pendingRequests[requestId];
        emit FulfilledWeb2Request(requestId);
        _;
    }
}