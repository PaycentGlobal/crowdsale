pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RateOracle.sol";
import "../contracts/PynToken.sol";
import "../contracts/PynTokenCrowdsale.sol";


contract TestCrowdsaleLow {

  uint public initialBalance = 1 ether;

  RateOracle public oracle;
  PynToken public token;
  PynTokenCrowdsale public phase1;

  function TestCrowdsaleLow() public {
    oracle = new RateOracle();
    oracle.setRate(60000);
  }

  function beforeEach() {
    token = new PynToken(this);
    phase1 = new PynTokenCrowdsale(this, token, now - 1 days, oracle, 127, 118, 112, true, 0);
    token.addSpecialAccount(phase1);
  }

  // has no tokens in crowdsale, so no ether transfers
  function test_first_phase_no_tokens() public {
    phase1.buyTokens.value(1 ether)();
    Assert.equal(phase1.totalRaised(), 0, "Failed to sell tokens, so no ether raised");
    Assert.equal(this.balance, 1 ether, "Failed to buy tokens, so no ether spent");
    Assert.equal(token.balanceOf(this), 45*10**25, "Should still have same amount of tokens");
  }


  // has less tokens than required for 1 wei
  function test_first_phase_low_tokens() public {
    token.transfer(phase1, 750);
    Assert.equal(token.balanceOf(this), 45*10**25 - 750, "Sent some tokens to crowdsale");
    phase1.buyTokens.value(1)();
    Assert.equal(phase1.totalRaised(), 0, "Sold tokens for less than 1 wei, so no ether raised");
    Assert.equal(token.balanceOf(this), 45*10**25, "Got this tokens back");
  }

  // has little tokens. so get them all and part of send ether
  function test_first_phase_some_tokens() public {
    token.transfer(phase1, 1500);
    Assert.equal(token.balanceOf(phase1), 1500, "Should be 1500 tokens after these transfer");
    Assert.equal(token.balanceOf(this), 45*10**25 - 1500, "Sent some tokens to crowdsale");
    phase1.buyTokens.value(2)();
    Assert.equal(phase1.totalRaised(), 1, "Sold tokens for 1 wei, so 1 wei raised");
    Assert.equal(phase1.balance, 0, "Dont hold tokens, just send them to the wallet!");
    Assert.equal(token.balanceOf(phase1), 0, "Sold all tokens");
    Assert.equal(token.balanceOf(this), 45*10**25, "Got 1500 tokens back");
  }

  function () public payable {}
}

