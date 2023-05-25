# Auction
Auction DApplication (The Decentralized Ebay)

1. a contract called auction which contains state variables to keep track of the beneficiary (auctioneer), 
the highest bidder, the auction end time, and the highest bid. 

2. There is events set up which can emit whenever the highest bid changes both address and amount and an 
event for the auction ending emitting the winner address and amount. 

3. The contract is deployed set to the beneficiary address and how long the auction will run for. 

4. There is a bid function which includes the following: 
  a. revert the call if the bidding period is over.
  b. If the bid is not higher than the highest bid, send the money back.
  c. emit the highest bid has increased 

4. there is a withdrawal function to return bids based on a library of keys and values. 

5. There is a function which ends the auction and sends the highest bid to the beneficiary!
