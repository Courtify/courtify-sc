const { zeroAddress } = require("../constants");
const {
	// External Functions
	expectRevert,
	assert,
	// Contract Artifacts
	CourtifyRights,
} = require("../utils");

contract("CourtifyRights (Chief Justice Functions)", (accounts) => {
	let courtifyRights;
	let creator, chiefJustice, newChiefJustice, courtOne, advocateOne;

	before("Initiating Accounts & Creating Contract Instance.", async () => {
		// Checking if we have enough accounts to test.
		assert.isAtLeast(accounts.length, 8, "Alteast 8 accounts are required to test the contracts.");
		[creator, chiefJustice, newChiefJustice, courtOne, advocateOne] = accounts;

		// Creating the instance of CourtifyRights Contract.
		courtifyRights = await CourtifyRights.new(newChiefJustice, { from: creator });
	});

	it("Chief Justice should be able to transfer its position to another address.", async () => {
		await courtifyRights.transferChiefJustice(chiefJustice, { from: newChiefJustice });
	});

	it("Chief Justice should not be able to transfer its position to zero address.", async () => {
		await expectRevert(courtifyRights.transferChiefJustice(zeroAddress, { from: chiefJustice }), "CourtifyRights: Invalid Address.");
	});

	it("Chief Justice should be able to call addCourt().", async () => {
		await courtifyRights.addCourt(courtOne, { from: chiefJustice });
	});

	it("Chief Justice should not be able to add a zero address as court.", async () => {
		await expectRevert(courtifyRights.addCourt(zeroAddress, { from: chiefJustice }), "CourtifyRights: Invalid Address.");
	});

	it("Chief Justice should not be able to add a court more than once.", async () => {
		await expectRevert(courtifyRights.addCourt(courtOne, { from: chiefJustice }), "CourtifyRights: Address is already a court.");
	});

	it("Chief Justice should be able to call removeCourt() with a court address.", async () => {
		await courtifyRights.removeCourt(courtOne, { from: chiefJustice });
	});

	it("Chief Justice should not be able to call removeCourt() with a normal user address.", async () => {
		await expectRevert(courtifyRights.removeCourt(advocateOne, { from: chiefJustice }), "CourtifyRights: Address is not a court.");
	});

	it("Chief Justice should not be able to call addAdvocate().", async () => {
		await expectRevert(
			courtifyRights.addAdvocate(advocateOne, { from: chiefJustice }),
			"CourtifyRights: Only Court can call this function."
		);
	});

	it("Chief Justice should not be able to call removeAdvocate().", async () => {
		await expectRevert(
			courtifyRights.removeAdvocate(advocateOne, { from: chiefJustice }),
			"CourtifyRights: Only Court can call this function."
		);
	});
});
