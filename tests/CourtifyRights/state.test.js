const { zeroAddress } = require("../constants");
const {
	// External Functions
	expectRevert,
	assert,
	// Contract Artifacts
	CourtifyRights,
} = require("../utils");

contract("CourtifyRights (State)", (accounts) => {
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
		let currentChiefJustice = await courtifyRights.chiefJustice();
		assert.strictEqual(currentChiefJustice, chiefJustice, "Chief Justice is not correct in Contract.");
	});

	it("Chief Justice should be able to call addCourt().", async () => {
		await courtifyRights.addCourt(courtOne, { from: chiefJustice });
		let isCourt = await courtifyRights.checkCourt(courtOne);
		let court = (await courtifyRights.getCourts())[0];
		assert.strictEqual(isCourt, true, "Court Status is not correct.");
		assert.strictEqual(court, courtOne, "Court One is not added correctly.");
	});

	it("Chief Justice should be able to call removeCourt() with a court address.", async () => {
		await courtifyRights.removeCourt(courtOne, { from: chiefJustice });
		let isCourt = await courtifyRights.checkCourt(courtOne);
		let courtLen = (await courtifyRights.getAdvocates()).length;
		assert.strictEqual(isCourt, false, "Court Status is not correct.");
		assert.strictEqual(courtLen, 0, "Court One is not removed correctly.");
	});

	it("Court should be able to call addAdvocate().", async () => {
		await courtifyRights.addCourt(courtOne, { from: chiefJustice });
		await courtifyRights.addAdvocate(advocateOne, { from: courtOne });
		let isAdvocate = await courtifyRights.checkAdvocate(advocateOne);
		let advocate = (await courtifyRights.getAdvocates())[0];
		assert.strictEqual(isAdvocate, true, "Advocate Status is not correct.");
		assert.strictEqual(advocate, advocateOne, "Advocate One is not added correctly.");
	});

	it("Court should be able to call removeAdvocate() with a court address.", async () => {
		await courtifyRights.removeAdvocate(advocateOne, { from: courtOne });
		let isAdvocate = await courtifyRights.checkAdvocate(advocateOne);
		let advocateLen = (await courtifyRights.getAdvocates()).length;
		assert.strictEqual(isAdvocate, false, "Advocate Status is not correct.");
		assert.strictEqual(advocateLen, 0, "Advocate One is not removed correctly.");
	});
});
