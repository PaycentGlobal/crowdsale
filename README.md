# PYN Crowdsale

Paycentos Crowdsale and Token contracts

## How to deploy
* configure `truffle.js` 
* configure `2_deploy_contracts.js`
* run `truffle deploy`
* transfer some tokens from wallet to Crowdsale contract

## How to buy
Use either of methods
* send ether from wallet to Crowdsale contract
* call `PynTokenCrowdsale.buyTokens()` function and send ether with it

Don't forget to provide enough gas.

## How to enable transfers
Call `PynTokenCrowdsale.success()` function after crowdsale is complete (check with `PynTokenCrowdsale.isCrowdsaleOpen()`). It will unlock transfers.