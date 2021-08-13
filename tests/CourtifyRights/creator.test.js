const { zeroAddress } = require("../constants");
const {
	// External Functions
	expectRevert,
	assert,
	// Contract Artifacts
	CourtifyRights,
} = require("../utils");

contract("CourtifyRights (Creator Functions)", (accounts) => {
	let courtifyRights;
	let creator, chiefJustice, courtOne, advocateOne;

	before("Initiating Accounts & Creating Contract Instance.", async () => {
		// Checking if we have enough accounts to test.
		assert.isAtLeast(accounts.length, 8, "Alteast 8 accounts are required to test the contracts.");
		[creator, chiefJustice, courtOne, advocateOne] = accounts;

		// Creating the instance of CourtifyRights Contract.
		courtifyRights = await CourtifyRights.new(chiefJustice, { from: creator });
	});

	it("Creator should not be able to create an instance with zero address as chief justice address.", async () => {
		await expectRevert(
			CourtifyRights.new(zeroAddress, { from: creator }),
			"CourtifyRights: Chief Justice Address cannot be a zero Address."
		);
	});

	it("Creator should not be able to transfer its position to another address.", async () => {
		await expectRevert(
			courtifyRights.transferChiefJustice(chiefJustice, { from: creator }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Creator should not be able to add a court.", async () => {
		await expectRevert(
			courtifyRights.addCourt(courtOne, { from: creator }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Creator should not be able to remove a court.", async () => {
		await expectRevert(
			courtifyRights.removeCourt(courtOne, { from: creator }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Creator should not be able to add an advocate.", async () => {
		await expectRevert(
			courtifyRights.addAdvocate(advocateOne, { from: creator }),
			"CourtifyRights: Only Court can call this function."
		);
	});

	it("Creator should not be able to remove an advocate.", async () => {
		await expectRevert(
			courtifyRights.removeAdvocate(advocateOne, { from: creator }),
			"CourtifyRights: Only Court can call this function."
		);
	});
});
