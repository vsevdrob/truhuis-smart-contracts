// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

abstract contract Authentication {
    address private s_citizen;
    address private s_government;

    event CitizenOwnershipTransferred(
        address indexed previousCitizen,
        address indexed newCitizen
    );

    event GovernmentOwnershipTransferred(
        address indexed previousGovernment,
        address indexed newGovernment
    );

    modifier onlyOwner() {
        require(isOwner(msg.sender), "caller is not the owner");
        _;
    }

    constructor(address _citizen, address _government) {
        s_citizen = _citizen;
        s_government = _government;
    }

    function transferCitizenOwnership(address _newCitizen)
        public
        virtual
        onlyOwner
    {
        require(
            _newCitizen != address(0),
            "Authentication: new citizen is the zero address"
        );
        _transferCitizenOwnership(_newCitizen);
    }

    function transferGovernmentOwnership(address _newGovernment)
        public
        virtual
        onlyOwner
    {
        require(
            _newGovernment != address(0),
            "Authentication: new government is the zero address"
        );
        _transferGovernmentOwnership(_newGovernment);
    }

    function _transferGovernmentOwnership(address _newGovernment)
        internal
        virtual
    {
        address oldGovernment = _newGovernment;
        s_government = _newGovernment;
        emit GovernmentOwnershipTransferred(oldGovernment, _newGovernment);
    }

    function _transferCitizenOwnership(address _newCitizen) internal virtual {
        address oldCitizen = s_citizen;
        s_citizen = _newCitizen;
        emit CitizenOwnershipTransferred(oldCitizen, _newCitizen);
    }

    function isOwner(address _caller) public view virtual returns (bool) {
        return citizen() == _caller || government() == _caller ? true : false;
    }

    function citizen() private view returns (address) {
        return s_citizen;
    }

    function government() private view returns (address) {
        return s_government;
    }
}
