// Independent Variables
let { a } = require("./variable.js");

// Independent Constants

const { zeroAddress } = require("./constants.js");

// External Functions

const {
	BN, // Big Number support.
	constants,
	expectRevert, // Assertions for transactions that should fail.
	expectEvent,
	time,
	balance,
} = require("@openzeppelin/test-helpers");

const { assert } = require("chai");

// Custom Functions

/**
 * Function to create a random value.
 * It expects no parameter.
 *
 * @return {number} Random Value.
 */
function randomValue() {
	return Math.floor(Math.random() * 10000) + 10000;
}

/**
 * Function to get back the current timestamp in seconds.
 * It expects no parameter.
 *
 * @return {number} Current Unix Timestamp.
 */
async function currentTimestamp() {
	let timestamp = await time.latest();
	return timestamp;
}

/**
 * Function to check the contract state.
 */
async function checkStatus(
	contractInstance,
	checkArray,
	userAddr,
	lastCaseID,
	totalPetitoner,
	caseID,
	timestamp,
	state,
	district,
	court,
	name,
	caseType
) {
	if (checkArray[0] == 1) {
		let cValue = await contractInstance.lastCaseID();
		assert.equal(lastCaseID, cValue.toNumber(), "The lastCaseID does not match.");
	}
	if (checkArray[1] == 1) {
		let cValue = await contractInstance.totalPetitoner();
		assert.equal(totalPetitoner, cValue.toNumber(), "The totalPetitoner does not match.");
	}
	if (checkArray[2] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[0];
		assert.equal(timestamp, cValue.toNumber(), "The timestamp does not match.");
	}
	if (checkArray[3] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[1];
		assert.equal(state, cValue, "The state does not match.");
	}
	if (checkArray[4] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[2];
		assert.equal(district, cValue, "The district does not match.");
	}
	if (checkArray[5] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[3];
		assert.equal(court, cValue, "The court does not match.");
	}
	if (checkArray[6] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[4];
		assert.equal(name, cValue, "The petitoner name does not match.");
	}
	if (checkArray[7] == 1) {
		let cValue = (await contractInstance.getCase(caseID))[5];
		assert.equal(caseType, cValue.toNumber(), "The caseType does not match.");
	}
}

// Contract Artifacts
const Courtify = artifacts.require("Courtify");
const CourtifyRights = artifacts.require("CourtifyRights");

module.exports = {
	// External Functions
	BN,
	constants,
	expectRevert,
	expectEvent,
	time,
	balance,
	assert,
	// Custom Functions
	randomValue,
	currentTimestamp,
	checkStatus,
	// Contract Artifacts
	Courtify,
	CourtifyRights,
};
