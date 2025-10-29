const Voting = artifacts.require("Voting");

module.exports = function (deployer) {
  deployer.deploy(Voting, "Bengaluru Election 2025");
};
