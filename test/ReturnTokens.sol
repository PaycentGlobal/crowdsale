pragma solidity ^0.4.15;

import "../contracts/token/BasicToken.sol";


contract ReturnTokens {
	function getTokensBack(address _token) public {
		BasicToken token = BasicToken(_token);
		uint256 tokens = token.balanceOf(this);
		token.transfer(msg.sender, tokens);
	}
}