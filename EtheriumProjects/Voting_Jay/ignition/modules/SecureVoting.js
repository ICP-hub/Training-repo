const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("SecureVotingModule", (m) => {
  // Deploy the SecureVoting contract
  // Note: Our contract constructor doesn't take any parameters as voting period is fixed to 1 hour
  const secureVoting = m.contract("SecureVoting", []);

  // We can add some verification calls to ensure the contract is properly deployed
  // Check if voting end time is set properly (should be ~1 hour from deployment)
  m.call(secureVoting, "votingEndTime", [], {
    id: "SecureVoting_checkVotingEndTime"
  });

  // Check if initial vote counts are zero
  m.call(secureVoting, "getResults", [], {
    id: "SecureVoting_checkInitialResults"
  });

  return { secureVoting };
});