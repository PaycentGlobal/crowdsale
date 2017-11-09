pragma solidity ^0.4.15;

import './ownership/Ownable.sol';
import './IRateOracle.sol';

/// @title Contract used to store ETH to Token rate in blockchain
/// @author Evgeny Marchenko
contract RateOracle is IRateOracle, Ownable {

    uint32 public constant delimiter = 100;
    uint32 public rate;

    /// @dev should be fired when changing rate
    event RateUpdated(uint32 indexed newRate);

    /// @param _rate new ETH to Token rate 
    function setRate(uint32 _rate) external onlyOwner {
        rate = _rate;
        RateUpdated(rate);
    }
    
    /// @dev amount of tokens recieved when buying with current rate
    /// @param weis - amount of ether that should be converted to token with current rate 
    /// @return amount of Token units recieved from provided amount of ether
    function converted(uint256 weis) external constant returns (uint256)  {
        return weis * rate / delimiter;
    }
}