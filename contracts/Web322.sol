// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Buffer.sol";
import "./CBOR.sol";

library Web322 {
    using CBOR for Buffer.buffer;
    uint256 internal constant defaultBufferSize = 256;

    struct Request {
        uint256 id;
        // address callbackAddr;
        Buffer.buffer params;
    }

    function initialize(
        Request memory self,
        uint256 id
        // address callbackAddr
    ) pure public returns (Request memory) {
        // Buffer.buffer memory params;
        Buffer.init(self.params, defaultBufferSize);
        self.id = id;
        // self.callbackAddr = callbackAddr;
        // self.params = params;
        return self;
    }

    function add(
        Request memory self,
        string memory key,
        string memory value
    ) internal pure {
        self.params.encodeString(key);
        self.params.encodeString(value);
    }

    function addHeader(
        Request memory self,
        string memory key,
        string memory value
    ) internal pure {
        self.params.encodeString(string.concat("H", key));
        self.params.encodeString(value);
    }

    function addParam(
        Request memory self,
        string memory key,
        string memory value
    ) internal pure {
        self.params.encodeString(string.concat("P", key));
        self.params.encodeString(value);
    }

    function addData(
        Request memory self,
        string memory value
    ) internal pure {
        self.params.encodeString(string.concat("D", value));
    }
}