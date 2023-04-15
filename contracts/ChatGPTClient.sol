// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Web322Client.sol";
import "./Web322.sol";

contract ChatGPTClient is Web322Client {
    using Web322 for Web322.Request;

    string constant prompt = "Draw a unicorn in TikZ";
    string constant openai_endpoint = "https://api.openai.com/v1/completions";
    string answer = "";
    uint256 constant amount = 0.000001 ether;

    event ChatGPTAnswer(uint256 requestId, string answer, bytes20 verification_hash);

    constructor(address oracle_addr, address admin_addr) {
        setAddresses(oracle_addr, admin_addr);
    }

    function requestUnicorn() external payable {
        Web322.Request memory request = buildWeb2Request(
            n_request,
            "POST",
            openai_endpoint
        );
        // header, param and data
        // parameters only as string
        request.addHeader("Content-Type", "application/json");
        request.addData('{"model": "text-davinci-003","prompt": "Mr. Watson--come here--I want to see you.","max_tokens": 20,"temperature": 0}');

        n_request += 1;
        
        sendWeb322Request(request, amount);
    } 

    function fulfill(
        uint256 _requestId,
        string memory _answer,
        bytes20 verificationHash
    ) public recordWeb322Fulfillment(_requestId) {
        emit ChatGPTAnswer(_requestId, _answer, verificationHash);
        answer = _answer;
    }
}