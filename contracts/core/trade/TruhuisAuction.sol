//SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "../address/TruhuisAddressRegistryAdapter.sol";

contract TruhuisAuction is 
    Ownable,
    ReentrancyGuard,
    TruhuisAddressRegistryAdapter,
    Pausable
{
//    struct Auction {
//        bool exists;
//        bool isResulted;
//        address currency;
//        address auctioneer;
//        uint256 minBid;
//        uint256 reservePrice;
//        uint256 startTime;
//        uint256 endTime;
//    }
//
//    struct HighestBid {
//        address bidder;
//        uint256 bid;
//        uint256 lastBidTime;
//    }
//
//    address public auctionOwner;
//    uint256 public auctionCommissionFranction;
//
//    mapping(uint256 => Auction) public s_auctions;
//    mapping(uint256 => HighestBid) public s_highestBids;
//
//    uint256 public minBidAllowed = 1; 
//    uint256 public bidWithdrawalLockTime = 25 minutes;
//    /// @dev Set corridor between auction start time and end time.
//    uint256 public corridor = 86400;
//
//    modifier auctionExists(uint256 _tokenId) {
//        require(isAuctionExistent(_tokenId), "auction not exists");
//        _;
//    }
//
//    modifier auctionStarted(uint256 _tokenId) {
//        require(isAuctionStarted(_tokenId), "auction is not started");
//        _;
//    }
//
//    modifier auctionNotExists(uint256 _tokenId) {
//        require(!isAuctionExistent(_tokenId), "auction already exists");
//        _;
//    }
//
//    modifier auctionNotStarted(uint256 _tokenId) {
//        require(!isAuctionStarted(_tokenId), "auction is already started");
//        _;
//    }
//
//    modifier auctionNotEnded(uint256 _tokenId) {
//        require(isAuctionEnded(_tokenId), "auction seems to be ended");
//        _;
//    }
//
//    modifier auctionNotResulted(uint256 _tokenId) {
//        require(!isAuctionResulted(_tokenId), "auction seems to be resulted or nonexistent");
//        _;
//    }
//
//    modifier onlyAuctioneer(address _auctioneer, uint256 _tokenId) {
//        validateAuctioneer(_auctioneer, _tokenId);
//        _;
//    }
//
//    modifier onlyBidder(address _bidder, uint256 _tokenId) {
//        validateBidder(_bidder, _tokenId);
//        _;
//    }
//
//    constructor(address _auctionOwner, address _addressRegistry, uint256 _marketplaceCommissionFraction) {
//        auctionOwner = _auctionOwner;
//        auctionCommissionFranction = _marketplaceCommissionFraction;
//        updateAddressRegistry(_addressRegistry);
//    }
//
//    function pause() external onlyOwner {_pause();}
//
//    function unpause() external onlyOwner {_unpause();}
//
//    // AUCTION
//
//    function createAuction(
//        address _currency,
//        uint256 _tokenId,
//        uint256 _reservePrice,
//        uint256 _startTime,
//        bool _minBidReserve,
//        uint256 _endTime
//    )
//        external
//        whenNotPaused
//        auctionNotExists(_tokenId)
//        onlyAuctioneer(msg.sender, _tokenId)
//    {
//        require(isAllowedCurrency(_currency), "invalid currency");
//        validateStartEndTimes(_startTime, _endTime);
//
//        uint256 minBid = 0;
//        uint256 tokenId = _tokenId;
//
//        if (_minBidReserve) {
//            minBid = _reservePrice;
//        }
//
//        s_auctions[_tokenId].exists = true;
//        s_auctions[tokenId].isResulted = false;
//        s_auctions[tokenId].currency = _currency;
//        s_auctions[tokenId].auctioneer = msg.sender;
//        s_auctions[tokenId].minBid = minBid;
//        s_auctions[tokenId].reservePrice = _reservePrice;
//        s_auctions[tokenId].startTime = _startTime;
//        s_auctions[tokenId].endTime = _endTime;
//
//        //emit AuctionCreated(msg.sender, tokenId);
//    }
//
//    function cancelAuction(uint256 _tokenId)
//        external
//        nonReentrant
//        onlyAuctioneer(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        HighestBid storage highestBid = s_highestBids[_tokenId];
//        
//        if (highestBid.bidder != address(0)) {
//            _refundHighestBidder(
//                _tokenId,
//                highestBid.bidder,
//                highestBid.bid
//            );
//
//            delete s_highestBids[_tokenId];
//        }
//
//        delete s_auctions[_tokenId];
//
//        //emit AuctionCancelled(msg.sender, _tokenId);
//    }    
//
//    function makeBid(uint256 _tokenId, uint256 _madeBid)
//        external
//        nonReentrant
//        whenNotPaused 
//        onlyBidder(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionStarted(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        Auction memory auction = s_auctions[_tokenId];
//        HighestBid memory highestBid = s_highestBids[_tokenId];
//
//        uint256 minBidRequired = highestBid.bid + minBidAllowed; // + 1 EUR or + 1 USDT or + 1 WETH
//
//        _validateMadeBid(_tokenId, _madeBid, minBidRequired);
//
//        _sendMadeBid(msg.sender, auction.currency, _madeBid);
//        _refundHighestBidder(_tokenId, highestBid.bidder, highestBid.bid);
//        _defineNewHighestBidder(msg.sender, _madeBid, _tokenId, _getNow());
//
//        //emit BidMade(_tokenId, msg.sender, _madeBid);
//    }
//
//    function withdrawBid(uint256 _tokenId)
//        external
//        nonReentrant
//        whenNotPaused 
//        onlyBidder(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionStarted(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        HighestBid memory highestBid = s_highestBids[_tokenId];
//
//        _validateBidWithdrawer(msg.sender, highestBid.bidder);
//        _validateBidWithdrawal(s_auctions[_tokenId].endTime);
//
//        uint256 previousBid = highestBid.bid;
//
//        delete s_highestBids[_tokenId];
//        _refundHighestBidder(_tokenId, msg.sender, previousBid);
//
//        //emit BidWithdrawn()
//    }
//
//    function resultAuction(uint256 _tokenId)
//        external
//        nonReentrant
//        onlyAuctioneer(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionStarted(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        Auction memory auction = s_auctions[_tokenId];
//        HighestBid memory highestBid = s_highestBids[_tokenId];
//
//        _validateWinner(highestBid.bidder, highestBid.bid, auction.reservePrice);
//
//        uint256 tokenId = _tokenId;
//        address currency = auction.currency;
//        address bidder = highestBid.bidder;
//        uint256 madeBid = highestBid.bid;
//        uint256 auctionCommission = getAuctionCommission(madeBid);
//        uint256 transferTax = getTransferTax(tokenId, madeBid - auctionCommission);
//
//        require(isAuctionApproved(auction.auctioneer), "auction should be approved");
//
//        delete s_highestBids[tokenId];
//
//        _setAuctionIsResulted(tokenId);
//        _sendAuctionCommission(currency, auctionCommission);
//        _sendTransferTax(currency, tokenId, transferTax);
//        _sendFundsTo(msg.sender, currency, madeBid - auctionCommission - transferTax);
//        _transferNftFrom(msg.sender, bidder, tokenId);
//
//        delete s_auctions[tokenId];
//    }
//
//    //          xxxxxxxxxxx                xxxxxxxxxxxxx
//    // UPDATE
//    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx
//
//    function updateAuctionEndTime(uint256 _tokenId, uint256 _endTime)
//        external 
//        onlyAuctioneer(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        Auction storage auction = s_auctions[_tokenId];
//        validateEndTime(auction.startTime, _endTime);
//        auction.endTime = _endTime;
//    }
//
//    function updateAuctionReservePrice(uint256 _tokenId, uint256 _reservePrice)
//        external 
//        onlyAuctioneer(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionNotEnded(_tokenId)
//        auctionNotResulted(_tokenId)
//    {
//        Auction storage auction = s_auctions[_tokenId];
//        auction.reservePrice = _reservePrice;
//    }
//
//    function updateAuctionStartTime(uint256 _tokenId, uint256 _startTime)
//        external 
//        onlyAuctioneer(msg.sender, _tokenId)
//        auctionExists(_tokenId)
//        auctionNotStarted(_tokenId)
//    {
//        validateStartTime(_startTime);
//        Auction storage auction = s_auctions[_tokenId];
//        auction.startTime = _startTime;
//    }
//
//    function updateBidWithdrawalLockTime(uint256 _bidWithdrawalLockTime) external onlyOwner {
//        bidWithdrawalLockTime = _bidWithdrawalLockTime;
//    }
//
//    function updateAuctionCommissionFraction(uint256 _newCommissionFraction)
//        external
//        onlyOwner
//    {
//        auctionCommissionFranction = _newCommissionFraction;
//    }
//
//    function updateAuctionOwner(address _newOwner)
//        external
//        onlyOwner
//    {
//        auctionOwner = _newOwner;
//    }
//
//    function reclaimERC20(address _currency) external onlyOwner {
//        require(_currency != address(0), "invalid currency address");
//        uint256 balance = IERC20(_currency).balanceOf(address(this));
//        require(IERC20(_currency).transfer(msg.sender, balance), "failed to transfer");
//    }
//
//    // GET
//
//    function getAuction(uint256 _tokenId) external view returns (Auction memory) {
//        return s_auctions[_tokenId];
//    }
//
//    function getIsResulted(uint256 _tokenId) external view returns (bool) {
//        return s_auctions[_tokenId].isResulted;
//    }
//
//    function getHighestBidder(uint256 _tokenId) external view returns (HighestBid memory) {
//        return s_highestBids[_tokenId];
//    }
//
//    function getAuctionCommission(uint256 _bid) public view returns (uint256) {
//        return marketplace().getMarketplaceCommission(_bid);
//    }
//
//    function getTransferTaxReceiver(uint256 _tokenId) public view returns (address) {
//        (address transferTaxReceiver, /*uint256 transferTax*/) = cadastre().royaltyInfo(_tokenId, uint256(1));
//        return transferTaxReceiver;
//    }
//
//    function getTransferTax(uint256 _tokenId, uint256 _salePrice) public view returns (uint256) {
//        (/*address transferTaxReceiver*/, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, _salePrice);
//        return transferTax;
//    }
//
//    function getStartTime(uint256 _tokenId) external view returns (uint256) {
//        return s_auctions[_tokenId].startTime;
//    }
//
//    //          xxxxxxxxxxx                xxxxxxxxxxxxx
//    // PUBLIC VIEW RETURNS
//    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx
//
//    //function areSimilarCountries(address _account, uint256 _tokenId) public view returns (bool) {
//    //    (address transferTaxReceiver, uint256 transferTax) = cadastre().royaltyInfo(_tokenId, uint256(1));
//    //    bytes3 realEstateCountry = IStateGovernment(transferTaxReceiver).getCountry();
//    //    bytes3 citizenship = resident(_account).citizenship();
//    //    return realEstateCountry == citizenship;
//    //}
//
//    function hasEnoughFunds(address _account, address _currency, uint256 _amount) public view returns (bool) {
//        return IERC20(_currency).balanceOf(_account) > _amount;
//    }
//
//    function isAllowedCurrency(address _currency) public view returns (bool) {
//        return currencyRegistry().isAllowed(_currency);
//    }
//
//    function isAuctionApproved(address _auctioneer) public view returns (bool) {
//        return cadastre().isApprovedForAll(_auctioneer, address(this));
//    }
//
//    function isAuctionEnded(uint256 _tokenId) public view returns (bool) {
//        return _getNow() > s_auctions[_tokenId].endTime;
//    }
//
//    function isAuctionExistent(uint256 _tokenId) public view returns (bool) {
//        return s_auctions[_tokenId].exists;
//    }
//
//    function isAuctionResulted(uint256 _tokenId) public view returns (bool) {
//        return s_auctions[_tokenId].isResulted;
//    }
//
//    function isAuctionStarted(uint256 _tokenId) public view returns (bool) {
//        require(isAuctionExistent(_tokenId), "auction not exists");
//        Auction memory auction = s_auctions[_tokenId];
//        return _getNow() > auction.startTime + 120;
//    }
//
//    function isHuman(address _account) public view returns (bool) {
//        uint256 codeLength;
//        assembly {codeLength := extcodesize(_account)}
//        return codeLength == 0 && _account != address(0);
//    }
//
//    function isPropertyOwner(address _auctioneer, uint256 _tokenId) public view returns (bool) {
//        return cadastre().isOwner(_auctioneer, _tokenId);
//    }
//
//    function isValidEndTime(uint256 _startTime, uint256 _endTime) public view returns (bool) {
//        return _endTime >= _startTime + corridor;
//    }
//
//    function isValidStartTime(uint256 _startTime) public view returns (bool) {
//        return _startTime + 60 > _getNow();
//    }
//
//    function isVerifiedAuctioneer(address _auctioneer, uint256 _tokenId) public view returns (bool) {
//        return marketplace().isVerifiedSeller(_auctioneer, _tokenId);
//    }
//
//    function isVerifiedBidder(address _bidder, uint256 _tokenId) public view returns (bool) {
//        return marketplace().isVerifiedBuyer(_bidder, _tokenId);
//    }
//
//    //          xxxxxxxxxxx                xxxxxxxxxxxxx
//    // PUBLIC VIEW 
//    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx
//
//    function validateAuctioneer(address _auctioneer, uint256 _tokenId) public {
//        if (!isVerifiedAuctioneer(_auctioneer, _tokenId)) {
//            marketplace().verifySeller(_auctioneer, _tokenId);
//        }
//        require(_auctioneer == s_auctions[_tokenId].auctioneer, "auctioneer must be the auction owner");
//    }
//
//    function validateBidder(address _bidder, uint256 _tokenId) public {
//        if (!isVerifiedBidder(_bidder, _tokenId)) {
//            marketplace().verifySeller(_bidder, _tokenId);
//        }
//        require(_bidder != s_auctions[_tokenId].auctioneer, "bidder can not be an auctioneer");
//    }
//
//    function validateEndTime(uint256 _startTime, uint256 _endTime) public view {
//        require(isValidEndTime(_startTime, _endTime), "invalid end time");
//    }
//
//    function validateStartEndTimes(uint256 _startTime, uint256 _endTime) public view {
//        require(isValidStartTime(_startTime), "start time must be greater than current time");
//        require(isValidEndTime(_startTime, _endTime),
//            "end time must be greater than start time (by 24 hours)"
//        );
//    }
//
//    function validateStartTime(uint256 _startTime) public view {
//        require(isValidStartTime(_startTime), "start time must be greater than current time");
//    }
//
//    //          xxxxxxxxxxx                xxxxxxxxxxxxx
//    // INTERNAL  &   PRIVATE 
//    //                          xxxxxxxxxxxxx               xxxxxxxxxxxxx
//
//    function _getNow() internal view virtual returns (uint256) {
//        return block.timestamp;
//    }
//    
//    function _sendTransferTax(address _currency, uint256 _tokenId, uint256 _transferTax) private {
//        address transferTaxReceiver = getTransferTaxReceiver(_tokenId);
//        require(transferTaxReceiver != address(0) || _transferTax > 0, "invalid transfer tax info");
//        IERC20(_currency).transfer(transferTaxReceiver, _transferTax);
//    }
//
//    function _transferNftFrom(address _auctioneer, address _bidder, uint256 _tokenId) private {
//        IERC721(addressRegistry().cadastre()).transferFrom(_auctioneer, _bidder, _tokenId);
//    }
//
//    function _sendMadeBid(address _bidder, address _currency, uint256 _madeBid) private {
//        require(hasEnoughFunds(_bidder, _currency, _madeBid), "insufficient balance");
//        require(
//            IERC20(_currency).transferFrom(_bidder, address(this), _madeBid),
//            "not approved"
//        );
//    }
//
//    function _refundHighestBidder(
//        uint256 _tokenId,
//        address _highestBidder,
//        uint256 _highestBid
//    ) private {
//        Auction memory auction = s_auctions[_tokenId];
//
//        require(
//            IERC20(auction.currency).transfer(_highestBidder, _highestBid),
//            "failed to refund previous bidder"
//        );
//    }
//
//    function _sendAuctionCommission(address _currency, uint256 _commission) private {
//        IERC20(_currency).transfer(auctionOwner, _commission);
//    }
//
//    function _setAuctionIsResulted(uint256 _tokenId) private {
//        Auction storage auction = s_auctions[_tokenId];
//        auction.isResulted = true;
//    }
//
//    function _sendFundsTo(
//        address _auctioneer, address _currency, uint256 _payAmount
//    ) private {
//        IERC20(_currency).transfer(_auctioneer, _payAmount);
//    }
//
//    function _defineNewHighestBidder(address _bidder, uint256 _madeBid, uint256 _tokenId, uint256 _lastBidTime) private {
//        HighestBid storage highestBid = s_highestBids[_tokenId];
//        highestBid.bidder = _bidder;
//        highestBid.bid = _madeBid;
//        highestBid.lastBidTime = _lastBidTime;
//    }
//
//    function _validateStartTime(uint256 _startTime) private view {
//        require(_startTime > _getNow(), "start time must be greater than current time");
//    }
//
//    function _validateBidWithdrawal(uint256 _endTime) private view {
//        require(
//            _getNow() > _endTime && (_getNow() - _endTime >= 43200),
//            "can withdraw only after 12 hours"
//        );
//    }
//
//    function _validateBidWithdrawer(address _withdrawer, address _highestBidder) private pure {
//        require(
//            _withdrawer == _highestBidder,
//            "bid withdrawer is not the highest bidder"
//        );
//    }
//
//    function _validateMadeBid(uint256 _tokenId, uint256 _madeBid, uint256 _minBidRequired) private view {
//        Auction memory auction = s_auctions[_tokenId];
//        if (auction.minBid == auction.reservePrice) {
//            require(_madeBid >= auction.reservePrice, "bid must be higher than reserve price");
//        }
//        require(_madeBid >= _minBidRequired, "made bid must be greater than previous highest bid");
//    }
//
//    function _validateWinner(address _winner, uint256 _highestBid, uint256 _reservePrice) private view {
//        require(isHuman(_winner), "winner can not be a contract");
//        require(_highestBid > _reservePrice, "highest bid must be greater than reserve price");
//    }
}
