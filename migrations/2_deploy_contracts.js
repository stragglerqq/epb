var EtherPowerBallBase = artifacts.require("./EtherPowerBallBase.sol");

module.exports = function(deployer) {
  var cuponPrice = 1000000000000000; // in wei 0.01eth
  deployer.deploy(EtherPowerBallBase, cuponPrice);
}