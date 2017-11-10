pragma solidity 0.4.18;

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

    /// @dev Used to allow crowdsale to transfer tokens
    function addSpecialAccount(address account) external onlyOwner {
        specialAccounts[account] = true;
    }

    bool public firstSaleComplete;

    /// @dev Called from crowdsale contract to enable transfers early
    function markFirstSaleComplete() public {
        if (specialAccounts[msg.sender]) {
            firstSaleComplete = true; 
        }
    }

    /// @dev Checks if `msg.sender` can call `transfer` and `transferFrom` methods
    /// @return If the transfers are still blocked for msg.sender 
    function isOpen() public constant returns (bool) {
        return firstSaleComplete || specialAccounts[msg.sender];
    }

    /// @dev Transfer token for a specified address
    /// @param _to The address to transfer to.
    /// @param _value The amount to be transferred.
    /// @return If transfers are still blocked (check `isOpen()` or `firstSaleComplete`)
    function transfer(address _to, uint _value) public returns (bool) {
        return isOpen() && super.transfer(_to, _value);
    }

    /// @dev Transfer tokens from one address to another
    /// @param _from Address The address which you want to send tokens from
    /// @param _to Address The address which you want to transfer to
    /// @param _value An uint256 the amount of tokens to be transferred
    /// @return A bool if transfers are still blocked (check `isOpen()` or `firstSaleComplete`)
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        return isOpen() && super.transferFrom(_from, _to, _value);
    }


    /// @dev Should be fired when burning tokens
    event Burn(address indexed burner, uint256 value);

    
    /// @dev Burns a specific amount of tokens.
    /// @notice Call with amount of token `_value` to burn them.
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