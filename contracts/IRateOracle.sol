pragma solidity ^0.4.15;

contract IRateOracle {
    function converted(uint256 weis) external constant returns (uint256);
}