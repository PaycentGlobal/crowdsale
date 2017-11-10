pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RateOracle.sol";
import "../contracts/PynToken.sol";
import "../contracts/PynTokenCrowdsale.sol";


contract TestCrowdsaleMinContribution {

  uint public initialBalance = 1 ether;

  RateOracle public oracle;
  PynToken public token;
  PynTokenCrowdsale public phase1;
  uint256 public balance;

  function TestCrowdsaleMinContribution() public {
    oracle = new RateOracle();
    oracle.setRate(60000);

  }

  // just test if phase is started
  // function test_min_contribution_passed() public {
  //   token = new PynToken(this);
  //   // deploy crowdsale with 10 wei as minimum contribution
  //   phase1 = new PynTokenCrowdsale(this, token, now - 1 days, oracle, 127, 118, 112, true, 10);
  //   token.addSpecialAccount(phase1);
  //   token.transfer(phase1, 150000);



  //   phase1.buyTokens.value(10)();
  //   Assert.equal(phase1.totalRaised(), 10, "Sold tokens for 10 wei, so balance increase 10 wei");
  //   Assert.equal(phase1.balance, 0, "Dont hold tokens, just send them to the wallet!");
  //   Assert.equal(token.balanceOf(phase1), 150000 - 7620, "Still has some tokens");
  //   Assert.equal(token.balanceOf(this), 45*10**25 - 150000 + 7620, "Got some tokens back");
  //   balance = token.balanceOf(this);

  // }

  // function test_min_contribution_should_fail_because_sending_to_little() public {
  //   phase1.buyTokens.value(1)();
  // }

  // function test_min_contribution_check_if_contribution_below_minimum_was_rejected() public {
  //   Assert.equal(token.balanceOf(this), balance, "Last contribution was rejected so token balance didnt change");
  //   phase1.buyTokens.value(10)();
  //   Assert.equal(phase1.totalRaised(), 10, "Sending enough ether again, balance should increase by 10 wei");
  //   Assert.equal(token.balanceOf(this), balance + 7620, "Sending enough ether again, this contribution should be accepted");
  // }

  function () public payable {}
}

