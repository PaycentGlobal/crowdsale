
Date.prototype.getUnixTime = function() { 
  return this.getTime()/1000|0;
};


// set start and walet to actual values
var start = new Date("November 2, 2017 09:00:00 GMT+0800").getUnixTime();
var wallet = '0x873D80B51A364347c6b4dd12d547F5459845A67B';

var RateOracle = artifacts.require("RateOracle");
var PynToken = artifacts.require("PynToken");
var PynTokenCrowdsale = artifacts.require("PynTokenCrowdsale");

var oracleInstance
var tokenInstance
var crowdsaleInstance

module.exports = function(deployer, network, accounts) {
  return deployer.deploy(RateOracle).then(function () {
    return RateOracle.deployed()
  })
  .then(function (_instance) {
    oracleInstance = _instance
    return deployer.deploy(
      PynToken, wallet)
  })
  .then(function () {
    return PynToken.deployed()
  })
  .then(function (_instance) {
    tokenInstance = _instance
    return deployer.deploy(
      PynTokenCrowdsale, wallet, tokenInstance.address, start, oracleInstance.address, 127, 118, 112, true);
  })
  .then(function () {
    return PynTokenCrowdsale.deployed()
  })
  .then(function (_instance) {
    crowdsaleInstance = _instance
  })
  .then(function () {
    oracleInstance.setRate(60000);
    tokenInstance.addSpecialAccount(wallet);
    tokenInstance.addSpecialAccount(crowdsaleInstance.address);
    //tokenInstance.transfer(crowdsaleInstance.address, 30000000 * Math.pow(10, 18));
  })
};
