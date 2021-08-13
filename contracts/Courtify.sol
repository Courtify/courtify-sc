pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;

import "./CourtifyRights.sol";

contract Courtify is CourtifyRights {
	/* STORAGE */

	uint256 public lastCaseID;
	uint256 public totalPetitoner;

	mapping(uint256 => Petitoner) public petitoners;
	mapping(uint256 => Case) public cases;

	struct Petitoner {
		uint256 id;
		string name;
	}

	struct Case {
		uint256 timestamp;
		string state;
		string district;
		string court;
		uint256 petitonerID;
		uint256 caseType;
		string[] evidence;
	}

	/* EVENTS */

	/*
	 *
	 */
	event CaseCreated(
		address _initiator,
		uint256 indexed _caseID,
		uint256 _timestamp,
		string _state,
		string _district,
		string _court,
		uint256 indexed _petitonerID,
		uint256 indexed _caseType
	);

	/*
	 *
	 */
	event EvidenceAdded(address _initiator, uint256 _caseID, string _IPFS);

	/* CONSTRUCTOR */

	/*
	 *
	 */
	constructor(address _chiefJustice) public CourtifyRights(_chiefJustice) {
		lastCaseID = 1;
		totalPetitoner = 1;
	}

	/* PUBLIC */

	/*
	 *
	 */
	function createNewCase(
		uint256 _timestamp,
		string memory _state,
		string memory _district,
		string memory _court,
		uint256 _petitonerID,
		string memory _name,
		uint256 _caseType
	) public onlyCourt {
		_createNewCase(_timestamp, _state, _district, _court, _petitonerID, _name, _caseType);
	}

	/*
	 *
	 */
	function uploadEvidence(uint256 _caseID, string memory _IPFS) public onlyAdvocate {
		_uploadEvidence(_caseID, _IPFS);
	}

	/* INTERNAL */

	/*
	 *
	 */
	function _createNewCase(
		uint256 _timestamp,
		string memory _state,
		string memory _district,
		string memory _court,
		uint256 _petitonerID,
		string memory _name,
		uint256 _caseType
	) internal {
		Case memory _case = cases[lastCaseID];
		_case.timestamp = _timestamp;
		if (_timestamp == 0) {
			_case.timestamp = block.timestamp;
		}
		_case.state = _state;
		_case.district = _district;
		_case.court = _court;
		if (_petitonerID == 0) {
			petitoners[totalPetitoner].id = totalPetitoner;
			petitoners[totalPetitoner].name = _name;
			_case.petitonerID = totalPetitoner;
			totalPetitoner++;
		} else {
			_case.petitonerID = _petitonerID;
		}
		_case.caseType = _caseType;
		emit CaseCreated(msg.sender, lastCaseID, _timestamp, _state, _district, _court, _petitonerID, _caseType);
		lastCaseID++;
	}

	/*
	 *
	 */
	function _uploadEvidence(uint256 _caseID, string memory _IPFS) internal {
		cases[_caseID].evidence.push(_IPFS);
		emit EvidenceAdded(msg.sender, _caseID, _IPFS);
	}

	/* GETTER */

	/*
	 *
	 */
	function getCase(uint256 _caseID)
		public
		view
		returns (
			uint256 _timestamp,
			string memory _state,
			string memory _district,
			string memory _court,
			string memory name,
			uint256 _caseType
		)
	{
		Case memory _case = cases[_caseID];
		Petitoner memory petitoner = petitoners[_case.petitonerID];
		return (_case.timestamp, _case.state, _case.district, _case.court, petitoner.name, _case.caseType);
	}

	/*
	 *
	 */
	function getEvidence(uint256 _caseID) public view returns (string[] memory) {
		return cases[_caseID].evidence;
	}
}
