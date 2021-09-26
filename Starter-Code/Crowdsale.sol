pragma solidity ^0.5.0;

import "./ZincCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract ZincCoinCrowdsale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale{

    constructor(
        // Fill in the constructor parameters
        uint rate,
        address payable wallet, 
        ZincCoin token,
        uint goal,
        uint openingTime, // testing: uint fakenow
        uint closingTime // testing: closingTime = fakenow + 2 minutes
        )
        
        // Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(goal)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
        
        public
    {
        // constructor can stay empty
    }
}

contract ZincCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // Fill in the constructor parameters
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal
    )
        public
    {
        // create the ZincCoin and keep its address handy
        ZincCoin token = new ZincCoin(name, symbol, 0);
        token_address = address(token);

        //  create the ZincCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        ZincCoinCrowdsale token_sale = new ZincCoinCrowdsale(1, wallet, token, goal, now, now + 24 weeks);
        token_sale_address = address(token_sale);
        // make the ZincCoinSale contract a minter, then have the ZincCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
