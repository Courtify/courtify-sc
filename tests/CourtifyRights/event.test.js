const { zeroAddress } = require("../constants");
const {
	// External Functions
	expectEvent,
	assert,
	// Contract Artifacts
	CourtifyRights,
} = require("../utils");

contract("CourtifyRights (Events)", (accounts) => {
	let courtifyRights;
	let creator, chiefJustice, courtOne, advocateOne;

	before("Initiating Accounts & Creating Contract Instance.", async () => {
		// Checking if we have enough accounts to test.
		assert.isAtLeast(accounts.length, 8, "Alteast 8 accounts are required to test the contracts.");
		[creator, chiefJustice, courtOne, advocateOne] = accounts;

		// Creating the instance of CourtifyRights Contract.
		courtifyRights = await CourtifyRights.new(chiefJustice, { from: creator });
	});

	it("Adding another court should emit CourtAdded.", async () => {
		let txReceipt = await courtifyRights.addCourt(courtOne, { from: chiefJustice });
		expectEvent(txReceipt, "CourtAdded", {
			_initiator: chiefJustice,
			_newCourt: courtOne,
		});
	});

	it("Remove an court should emit CourtRemoved.", async () => {
		let txReceipt = await courtifyRights.removeCourt(courtOne, { from: chiefJustice });
		expectEvent(txReceipt, "CourtRemoved", {
			_initiator: chiefJustice,
			_removedCourt: courtOne,
		});
	});

	it("Adding a verifier should emit AdvocateAdded.", async () => {
		await courtifyRights.addCourt(courtOne, { from: chiefJustice });
		let txReceipt = await courtifyRights.addAdvocate(advocateOne, { from: courtOne });
		expectEvent(txReceipt, "AdvocateAdded", {
			_initiator: courtOne,
			_newAdvocate: advocateOne,
		});
	});

	it("Removing a verifier should emit AdvocateRemoved.", async () => {
		let txReceipt = await courtifyRights.removeAdvocate(advocateOne, { from: courtOne });
		expectEvent(txReceipt, "AdvocateRemoved", {
			_initiator: courtOne,
			_removedAdvocate: advocateOne,
		});
	});
});
