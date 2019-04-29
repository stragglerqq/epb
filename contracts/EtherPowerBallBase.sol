pragma solidity >=0.4.23;

contract EtherPowerBallBase {
    address admin;
    uint256 public cuponPrice;
    uint256 public cuponsSold;

    event Sell(address _buyer, uint256 _amount);

    constructor(uint256 _cuponPrice) public {
        admin = msg.sender;
        cuponPrice = _cuponPrice;
    }
    
    struct Cupon {
        uint id;
        uint[] numbers;
    }

    struct Buyer {
        uint numberOfCupons;
        Cupon[] cupons;
    }

    mapping(uint => Cupon) public cupons;
    uint public cuponsCount;
    mapping(address => Buyer) public buyers;


    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "Invalid multiply params");
    }

    Buyer buyer;
    function buyCupons(uint256 _numberOfCupons) public payable {
        require(msg.value == multiply(_numberOfCupons, cuponPrice), "");
        buyer = buyers[msg.sender];
        generateCuponsForBuyer(_numberOfCupons);
        
        cuponsSold += _numberOfCupons;

        emit Sell(msg.sender, _numberOfCupons);
    }

    function generateCuponsForBuyer(uint _numberOfCupons) private {
        for (uint i = 0; i < _numberOfCupons; i++) {
            addCuponToBuyer(generateSingleCupon());
        }
    }

    function addCuponToBuyer(Cupon memory _cupon) internal {
        buyer.numberOfCupons += 1;
        buyer.cupons.push(_cupon);
    }

    function generateSingleCupon() private returns (Cupon memory _cupon) {
        uint[] memory numbers = new uint[](7);
        for(uint i = 0; i < 7; i++) {
            numbers[i] = randomNumber();
        }
        _cupon = Cupon(cuponsCount, numbers);
        cupons[cuponsCount] = _cupon;
    }

    function randomNumber() private pure returns(uint) {
        return 5;
    }
}

