pragma solidity ^0.4.15;

import "./math/SafeMath.sol";
import "./lifecycle/Pausable.sol";
import "./IRateOracle.sol";
import "./PynToken.sol";


contract PynTokenCrowdsale is Pausable {
    using SafeMath for uint256;

    uint256 public totalRaised;
    //Crowdsale start
    uint256 public startTimestamp;
    //Crowdsale duration: 30 days
    uint256 public duration = 28 days;
    //adress of Oracle with ETH to PYN rate
    IRateOracle public rateOracle;
    //Address of wallet
    address public fundsWallet;
    // token contract
    PynToken public token;
    // bonus applied: 127 means additional 27%
    uint16 public bonus1;
    uint16 public bonus2;
    uint16 public bonus3;
    // if true bonus applied to every purchase, otherwise only if msg.sender already has some PYN tokens
    bool public bonusForEveryone;

    function PynTokenCrowdsale(
    address _fundsWallet,
    address _pynToken,
    uint256 _startTimestamp,
    address _rateOracle,
    uint16 _bonus1,
    uint16 _bonus2,
    uint16 _bonus3,
    bool _bonusForEveryone) public {
        fundsWallet = _fundsWallet;
        token = PynToken(_pynToken);
        startTimestamp = _startTimestamp;
        rateOracle = IRateOracle(_rateOracle);
        bonus1 = _bonus1;
        bonus2 = _bonus2;
        bonus3 = _bonus3;
        bonusForEveryone = _bonusForEveryone;
    }

    bool internal capReached;

    function isCrowdsaleOpen() public constant returns (bool) {
        return !capReached && now >= startTimestamp && now <= startTimestamp + duration;
    }

    modifier isOpen() {
        require(isCrowdsaleOpen());
        _;
    }


    function() public payable {
        buyTokens();
    }

    function buyTokens() public isOpen whenNotPaused payable {

        uint256 payedEther = msg.value;
        uint256 acceptedEther = 0;
        uint256 refusedEther = 0;

        uint256 expected = calculateTokenAmount(payedEther);
        uint256 available = token.balanceOf(this);
        uint256 transfered = 0;

        if (available < expected) {
            acceptedEther = payedEther.mul(available).div(expected);
            refusedEther = payedEther.sub(acceptedEther);
            transfered = available;
            capReached = true;
        } else {
            acceptedEther = payedEther;
            transfered = expected;
        }

        totalRaised = totalRaised.add(acceptedEther);
        
        token.transfer(msg.sender, transfered);
        fundsWallet.transfer(acceptedEther);
        if (refusedEther > 0) {
            msg.sender.transfer(refusedEther);
        }
    }

    function calculateTokenAmount(uint256 weiAmount) public constant returns (uint256) {
        uint256 converted = rateOracle.converted(weiAmount);
        if (bonusForEveryone || token.balanceOf(msg.sender) > 0) {

            if (now <= startTimestamp + 10 days) {
                if (now <= startTimestamp + 5 days) {
                    if (now <= startTimestamp + 2 days) {
                        //+27% bonus during first 2 days
                        return converted.mul(bonus1).div(100);
                    }
                    //+18% bonus during day 3 - 5
                    return converted.mul(bonus2).div(100);
                }
                //+12% bonus during day 6 - 10
                return converted.mul(bonus3).div(100);
            }
        }
        return converted;
    }

    function success() public returns (bool) { 
        require(now > startTimestamp);
        uint256 balance = token.balanceOf(this);
        if (balance == 0) {
            capReached = true;
            token.markFirstSaleComplete();
            return true;
        }

        if (now >= startTimestamp + duration) {
            token.burn(balance);
            capReached = true;
            token.markFirstSaleComplete();
            return true;
        }

        return false;
    }
}

