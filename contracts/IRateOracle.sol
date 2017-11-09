pragma solidity 0.4.18;

contract IRateOracle {
    function converted(uint256 weis) external constant returns (uint256);
}