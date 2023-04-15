// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Web322Client.sol";
import "./Web322.sol";

contract ChatGPTClient is Web322Client {
    using Web322 for Web322.Request;

    string constant prompt = "Draw a unicorn in TikZ";
    string constant openai_endpoint = "ai.com";
    string answer = "";
    uint256 constant amount = 0.000001 ether;

    event ChatGPTAnswer(uint256 requestId, string answer);

    constructor(address oracle_addr, address admin_addr) {
        setAddresses(oracle_addr, admin_addr);
    }

    function requestUnicorn() external payable {
        Web322.Request memory request = buildWeb2Request(
            n_request,
            openai_endpoint
        );
        // header, param and data
        // parameters only as string
        request.addHeader("Content-Type", "application/json");
        request.addHeader("Authorization", "Bearer $OPENAI_API_KEY");
        request.addData('{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Say this is a test!"}],"temperature":0.7}');

        n_request += 1;
        
        sendWeb322Request(request, amount);
    } 

    function fulfill(
        uint256 _requestId,
        string memory _answer
    ) public recordWeb322Fulfillment(_requestId) {
        emit ChatGPTAnswer(_requestId, _answer);
        answer = _answer;
    }
}