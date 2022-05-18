// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.13;

interface ITruhuisMarketplace {
    function verifySeller(address _seller, uint256 _tokenId) external;
    function verifyBuyer(address _buyer, uint256 _tokenId) external;
    function getMarketplaceCommission(uint256 _salePrice) external view returns (uint256);

    function getRoyaltyCommission(uint256 _tokenId, uint256 _salePrice) external view returns (uint256);
    function getRoyaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address, uint256);
    function getRoyaltyReceiver(uint256 _tokenId) external view returns (address);

    function hasEnoughFunds(address _account, address _currency, uint256 _amount) external view returns (bool);

    function isHuman(address _account) external view returns (bool);

    function isVerifiedBuyer(address _buyer, uint256 _tokenId) external view returns (bool);

    function isVerifiedSeller(address _seller, uint256 _tokenId) external view returns (bool);

}
