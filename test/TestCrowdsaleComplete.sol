pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RateOracle.sol";
import "../contracts/PynToken.sol";
import "../contracts/PynTokenCrowdsale.sol";
import "./ReturnTokens.sol";

contract TestCrowdsaleComplete {

  uint public initialBalance = 1 ether;

  RateOracle public oracle;
  PynToken public token;
  PynTokenCrowdsale public phase;

  function TestCrowdsaleComplete() public {
    oracle = new RateOracle();
    oracle.setRate(60000);
  }

  // if you finish crowdsale all tokens get burned
  function test_phase_success_date() public {
    token = new PynToken(this);
    phase = new PynTokenCrowdsale(this, token, now - 31 days, oracle, 127, 118, 112, true, 0);
    token.addSpecialAccount(phase);
    Assert.equal(phase.isCrowdsaleOpen(), false, "Crowdsale should not be open");

    // send some tokens
    token.transfer(phase, 3*10**25);

    // crowdsale burns all tokens
    Assert.equal(phase.success(), true, "Should be considered complete");
    Assert.equal(phase.isCrowdsaleOpen(), false, "Crowdsale should not be open");
    Assert.equal(token.balanceOf(phase), 0, "Crowdsale burned all the tokens");
    Assert.equal(token.balanceOf(this), 42*10**25, "Crowdsale burned its tokens");

    // send some tokens
    ReturnTokens returnTokens = new ReturnTokens();
    token.transfer(returnTokens, 1000);

    // not special accounts can send tokens now
    Assert.equal(token.balanceOf(returnTokens), 1000, "Send 1000 tokens to contract`");
    returnTokens.getTokensBack(token);
    Assert.equal(token.balanceOf(returnTokens), 0, "This contract send tokens back");
  }

  // if you finish crowdsale all tokens get burned
  function test_phase_success_tokens() public {
    // init and check that crowdsale is open
    token = new PynToken(this);
    phase = new PynTokenCrowdsale(this, token, now - 1 days, oracle, 127, 118, 112, true, 0);
    token.addSpecialAccount(phase);
    Assert.equal(phase.isCrowdsaleOpen(), true, "Crowdsale should be open");

    // send some tokens
    ReturnTokens returnTokens = new ReturnTokens();
    token.transfer(returnTokens, 1000);

    // crowdsale has no tokens so anyone can mark it as success
    Assert.equal(phase.success(), true, "Should be considered complete");
    Assert.equal(phase.isCrowdsaleOpen(), false, "Crowdsale should not be open");

    // not special accounts can send tokens now
    Assert.equal(token.balanceOf(returnTokens), 1000, "Send 1000 tokens to contract`");
    returnTokens.getTokensBack(token);
    Assert.equal(token.balanceOf(returnTokens), 0, "This contract send tokens back");
  }


  function () public payable {}
}

