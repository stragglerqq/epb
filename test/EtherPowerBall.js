var EtherPowerBallBase = artifacts.require("./EtherPowerBallBase.sol");

contract('EtherPowerBall', function(accounts) {
    var etherPowerBallBaseInstance;
    var buyer = accounts[1];
    var cuponPrice = 10000000000000000; // in wei 0.01eth
    var numberOfCupons;
    it('initializes the contract with the correct values', function() {
        return EtherPowerBallBase.deployed().then(function(instance) {
            etherPowerBallBaseInstance = instance;
            return etherPowerBallBaseInstance.address;
        }).then(function(address) {
            assert.notEqual(address, 0x0, 'has contract address');
            return etherPowerBallBaseInstance.cuponPrice();
        }).then(function(price) {
            assert.equal(price, cuponPrice, 'cupon price is correct')
        });
    });

    it('facilitates cupon buying', function() {
        return EtherPowerBallBase.deployed().then(function(instance) {
            etherPowerBallBaseInstance = instance;
            numberOfCupons = 10;
            return etherPowerBallBaseInstance.buyCupons(numberOfCupons, { from: buyer, value: numberOfCupons * cuponPrice});        
        }).then(function(receipt) {
            assert.equal(receipt.logs.length, 1, 'triggers one event');
            assert.equal(receipt.logs[0].event, 'Sell', 'should be the "Sell" event');
            assert.equal(receipt.logs[0].args._buyer, buyer, 'logs the accunt that purchased the cupons');
            assert.equal(receipt.logs[0].args._amount, numberOfCupons, 'logs the number of cupons purchased');
            return etherPowerBallBaseInstance.cuponsSold();
        }).then(function(amount) {
            assert.equal(amount.toNumber(), numberOfCupons, 'increment the number of cupons sold');
            // Try to buy cupons different from the enter value
            return etherPowerBallBaseInstance.buyCupons(numberOfCupons, { from: buyer, value: 1 });
        }).then(assert.fail).catch(function(error) {
            assert(error.message.indexOf('revert') >= 0, 'msg.value must equal to number of cupons in wei')
        });
    });
});