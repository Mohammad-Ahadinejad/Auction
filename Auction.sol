// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

contract Auction{
    address payable public auctioneer;
    address public highestBidder;
    uint public highestBid;
    uint public validity;
    bool public isEnded = false;
    mapping(address=>uint) pendingReturns;

    
    event highestBidChanged(address _highestBidder, uint _highestBid);
    event withdrawBidder(address _bidder, uint _amount);
    event auctionEnded(address _winnerAdr, uint _winnerBid);
    
    constructor (address payable _adr, uint _time) {
        auctioneer = _adr;
        validity = block.timestamp + _time;
    }

    function bid() external payable{
        require(validity > block.timestamp,"Bid's validity date is expired.");
        require(msg.value > highestBid, "there is already a highest bidder.");
        require(msg.sender != auctioneer, "auctioneer cant bid");

        if(highestBid != 0) pendingReturns[highestBidder] += highestBid;

        highestBidder = msg.sender;
        highestBid = msg.value;
        emit highestBidChanged(highestBidder, highestBid);
    }

    function withdraw() external payable {
        require(msg.sender != highestBidder, "You are the highest bidder, you cant withdraw your monney.");
        uint amount = pendingReturns[msg.sender];
        require(amount > 0, "You dont have any deposite in the contract.");
        pendingReturns[msg.sender] = 0;

        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        if (!sent)  pendingReturns[msg.sender] = amount;
        else emit withdrawBidder(msg.sender, amount);  
    }

    function auctionEnd() external payable{
        require(block.timestamp>validity, "Bid's validity date is not expired.");
        require(isEnded==false, "The auction is already ended.");

        isEnded = true;
        (bool sent, ) = auctioneer.call{value: highestBid}("");
        if(!sent)   isEnded=false;
        else emit auctionEnded(highestBidder, highestBid);
    }
}