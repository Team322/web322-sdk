// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@web322/contracts/Web322Client.sol";


contract ChatGPTClient is Web322Client {
    using Web322 for Web322.Request;

    string constant prompt = "Draw a unicorn in TikZ";
    string constant openai_endpoint = "ai.com";
    string answer = "";
    uint256 n_request = 0;

    event ChatGPTAnswer(bytes32 indexed requestId, string answer);

    function requestUnicorn() public returns (bytes32 requestId) {
        Web322.Request memory request = buildWeb2Request(
            n_request,
            openai_endpoint,
            address(this)
        );
        
        // parameters only as string
        request.add("prompt", prompt);
        request.add("temperature", "0");
        request.add("logprobs", "false");

        n_request += 1;

        return sendWeb322Request(request);
    } 

    function fulfill(
        bytes32 _requestId,
        uint256 _answer
    ) public recordWeb322Fulfillment(_requestId) {
        emit ChatGPTAnswer(_requestId, _answer);
        answer = _answer;
    }
}