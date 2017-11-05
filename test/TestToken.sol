pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/PynToken.sol";

contract TestToken {


  function test_initial_state() public {
    PynToken pyn = new PynToken(this);

    Assert.equal(pyn.totalSupply(), 45 * 10**7 * 10**18, "totalSupply should be 45e25");

    Assert.equal(pyn.balanceOf(this), 45 * 10**7 * 10**18, "all tokens should be on wallet initially");
  }

  function test_hold_as_special() public {
    PynToken pyn = new PynToken(this);
    Assert.equal(pyn.transfer(0x0123456789, 1), true, "special account can transfer coins immidietly");
  }

  function test_hold_as_not_special() public {
    PynToken pyn = PynToken(DeployedAddresses.PynToken());
    Assert.equal(pyn.transfer(0x0123456789, 1), false, "usual accounts cant transfer coins immidietly");
  }

  // burn some tokens
  function test_burn() public {
    PynToken pyn = new PynToken(this);
    uint256 tokens = pyn.balanceOf(this);
    Assert.equal(tokens, 45 * 10**7 * 10**18, "all tokens should be on wallet initially");
    pyn.burn(1000);
    Assert.equal(tokens - pyn.balanceOf(this), 1000, "just burned 1000 tokens");
  }
}

