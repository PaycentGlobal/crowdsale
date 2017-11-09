pragma solidity ^0.4.15;

import "./token/StandardToken.sol";
import "./ownership/Ownable.sol";

/// @title ERC20-compatible Paycentos Token 
/// total supply is 450m tokens
/// `transfer` and `transferFrom` methods are blocked until first crowdsale phase is complete 
/// @author Evgeny Marchenko
contract PynToken is StandardToken, Ownable {

    string public constant name = "Paycentos Token";
    string public constant symbol = "PYN";
    uint256 public constant decimals = 18;
    uint256 public totalSupply = 450000000 * (uint256(10) ** decimals);
    
    mapping(address => bool) public specialAccounts;

    function PynToken(address wallet) public {
        balances[wallet] = totalSupply;
        specialAccounts[wallet]=true;
        Transfer(0x0, wallet, totalSupply);
    }

    /// @dev used to allow crowdsale to transfer tokens
    function addSpecialAccount(address account) external onlyOwner {
        specialAccounts[account] = true;
    }

    bool public firstSaleComplete;

    /// @dev called from crowdsale contract to enable transfers early
    function markFirstSaleComplete() public {
        if (specialAccounts[msg.sender]) {
            firstSaleComplete = true; 
        }
    }

    /// @dev checks if `msg.sendser` can call `transfer` and `transferFrom` methods
    /// @return false if transfers are still blocked for msg.sender 
    function isOpen() public constant returns (bool) {
        return firstSaleComplete || specialAccounts[msg.sender];
    }

    /// @dev transfer token for a specified address
    /// @param _to The address to transfer to.
    /// @param _value The amount to be transferred.
    /// @return false if transfers are still blocked (check `isOpen()` or `firstSaleComplete`)
    function transfer(address _to, uint _value) public returns (bool) {
        return isOpen() && super.transfer(_to, _value);
    }

    /// @dev Transfer tokens from one address to another
    /// @param _from address The address which you want to send tokens from
    /// @param _to address The address which you want to transfer to
    /// @param _value uint256 the amount of tokens to be transferred
    /// @return false if transfers are still blocked (check `isOpen()` or `firstSaleComplete`)
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        return isOpen() && super.transferFrom(_from, _to, _value);
    }


    /// @dev should be fired when burning tokens
    event Burn(address indexed burner, uint256 value);

    
    /// @dev Burns a specific amount of tokens.
    /// @param _value The amount of token to be burned.
    function burn(uint256 _value) public {
        require(_value >= 0);
        require(_value <= balances[msg.sender]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }

}