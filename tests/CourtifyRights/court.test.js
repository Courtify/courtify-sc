const { zeroAddress } = require("../constants");
const {
	// External Functions
	expectRevert,
	assert,
	// Contract Artifacts
	CourtifyRights,
} = require("../utils");

contract("CourtifyRights (Court Functions)", (accounts) => {
	let courtifyRights;
	let creator, chiefJustice, courtOne, advocateOne;

	before("Initiating Accounts & Creating Contract Instance.", async () => {
		// Checking if we have enough accounts to test.
		assert.isAtLeast(accounts.length, 8, "Alteast 8 accounts are required to test the contracts.");
		[creator, chiefJustice, courtOne, advocateOne] = accounts;

		// Creating the instance of CourtifyRights Contract.
		courtifyRights = await CourtifyRights.new(chiefJustice, { from: creator });

		await courtifyRights.addCourt(courtOne, { from: chiefJustice });
	});

	it("Court should not be able to transfer its position to another address.", async () => {
		await expectRevert(
			courtifyRights.transferChiefJustice(chiefJustice, { from: courtOne }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Court should not be able to call addCourt().", async () => {
		await expectRevert(
			courtifyRights.addCourt(courtOne, { from: courtOne }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Chief Justice should not be able to call removeCourt() with a normal user address.", async () => {
		await expectRevert(
			courtifyRights.removeCourt(courtOne, { from: courtOne }),
			"CourtifyRights: Only Chief Justice can call this function."
		);
	});

	it("Court should be able to call addAdvocate().", async () => {
		await courtifyRights.addAdvocate(advocateOne, { from: courtOne });
	});

	it("Court should not be able to add a zero address as court.", async () => {
		await expectRevert(courtifyRights.addAdvocate(zeroAddress, { from: courtOne }), "CourtifyRights: Invalid Address.");
	});

	it("Court should not be able to add a court more than once.", async () => {
		await expectRevert(courtifyRights.addAdvocate(advocateOne, { from: courtOne }), "CourtifyRights: Address is already an advocate.");
	});

	it("Court should be able to call removeAdvocate() with a court address.", async () => {
		await courtifyRights.removeAdvocate(advocateOne, { from: courtOne });
	});

	it("Court should not be able to call removeAdvocate() with a normal user address.", async () => {
		await expectRevert(courtifyRights.removeAdvocate(advocateOne, { from: courtOne }), "CourtifyRights: Address is not an advocate.");
	});
});
