pragma solidity ^0.4.23;

contract EtherPowerBallBase {
    address admin;
    uint256 public cuponPrice;
    uint256 public cuponsSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(uint256 _cuponPrice) public {
        admin = msg.sender;
        cuponPrice = _cuponPrice;
    }
    
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "Invalid multiply params");
    }

    function buyCupons(uint256 _numberOfCupons) public payable {
        require(msg.value == multiply(_numberOfCupons, cuponPrice), "");

        cuponsSold += _numberOfCupons;

        emit Sell(msg.sender, _numberOfCupons);
    }
}

