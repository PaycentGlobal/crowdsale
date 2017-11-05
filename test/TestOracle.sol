pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/RateOracle.sol";
import "../contracts/IRateOracle.sol";

contract TestOracle {

  RateOracle private oracle;
  IRateOracle private ioracle;

  function TestOracle() public {
    oracle = new RateOracle();
    ioracle = IRateOracle(oracle);
  }

  function test_oracle_deployed_rate() public {
    RateOracle oracle = RateOracle(DeployedAddresses.RateOracle());
    Assert.equal(uint256(oracle.rate()), uint256(60000), "deployment sets rate to 600 PYN for ETH");
  }
  
  function test_oracle_rate() public {
    oracle.setRate(300);
    Assert.equal(uint256(oracle.rate()), uint256(300), "rate was set to 300");

    oracle.setRate(60000);
    Assert.equal(uint256(oracle.rate()), uint256(60000), "rate was set to 60000");
  }

  function test_oracle_convert() public {
    oracle.setRate(60000);
    Assert.equal(uint256(oracle.delimiter()), uint256(100), "delimiter should be 100");

    Assert.equal(oracle.converted(1), uint256(600), "1 wei converts to 600 nanoTokens");
  }
  
  function test_ioracle() public {
    RateOracle(oracle).setRate(60000);
    Assert.equal(IRateOracle(oracle).converted(1), uint256(600), "1 wei converts to 600 nanoTokens");
  }
}
