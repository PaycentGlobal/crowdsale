pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RateOracle.sol";
import "../contracts/PynToken.sol";
import "../contracts/PynTokenCrowdsale.sol";


contract TestCrowdsale {

  uint public initialBalance = 1 ether;

  RateOracle public oracle;
  PynToken public token;
  PynTokenCrowdsale public phase1;

  function TestCrowdsale() public {
    oracle = new RateOracle();
    oracle.setRate(60000);
    
  }

  function beforeAll() {
    token = new PynToken(this);
    phase1 = new PynTokenCrowdsale(this, token, now - 1 days, oracle, 127, 118, 112, true, 0);
    token.addSpecialAccount(phase1);
  }

  // just test if phase is started
  function test_first_phase_is_started() public {
    Assert.equal(phase1.isCrowdsaleOpen(), true, "Crowdsale should be open");
  }

  function test_first_phase_rate() public {
    uint256 from1wei = phase1.calculateTokenAmount(1);
    Assert.equal(from1wei, 762, "should be 600*1.27=762 PYN tokens per 1 ETH");
    uint256 from1ether = phase1.calculateTokenAmount(1 ether);
    Assert.equal(from1ether, 762 * 10**18, "should be 600*1.27=762 PYN tokens per 1 ETH");
  }

  // just to check the test itself
  function test_first_phase_eth_and_tokens() public {
    Assert.equal(this.balance, 1 ether, "Should have 1 ether at start");
    Assert.equal(token.balanceOf(this), 45*10**25, "Should have 450*10**6 tokens at start");
  }

  // has plenty of tokens. so get tokens as expected and refund no ether
  function test_first_phase_plenty_of_tokens() public {
    token.transfer(phase1, 150000);
    Assert.equal(token.balanceOf(phase1), 150000, "Should be 150000 tokens after these transfer");
    Assert.equal(token.balanceOf(this), 45*10**25 - 150000, "Sent some tokens to crowdsale");

    uint256 raised = phase1.totalRaised();
    phase1.buyTokens.value(10)();
    Assert.equal(phase1.totalRaised() - raised, 10, "Sold tokens for 10 wei, so balance increase 10 wei");
    Assert.equal(phase1.balance, 0, "Dont hold tokens, just send them to the wallet!");
    Assert.equal(token.balanceOf(phase1), 150000 - 7620, "Still has some tokens");
    Assert.equal(token.balanceOf(this), 45*10**25 - 150000 + 7620, "Got some tokens back");
  }


  function () public payable {}
}

