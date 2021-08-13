// Constants

const {
	BN, // Big Number support.
	constants,
} = require("@openzeppelin/test-helpers");

let zero = new BN(0);
let zeroAddress = constants.ZERO_ADDRESS;

module.exports = {
	zero,
	zeroAddress,
};
