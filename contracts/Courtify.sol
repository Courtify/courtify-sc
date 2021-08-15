pragma solidity ^0.5.17;
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
	 * @notice Emitted when case is created.
	 * @param _initiator The one who initiates the event.
	 * @param _caseID The new case id which was created.
	 * @param _timestamp The time when the case was created.
	 * @param _state The state where the case was created.
	 * @param _district The district where the case was created.
	 * @param _court The court where the case was created.
	 * @param _petitonerID The Petitioner ID.
	 * @param _caseType The case type.
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
	 * @notice Emitted when the case is created.
	 * @param _initiator The one who initiates the event.
	 * @param _caseID The case ID for which the evidence was added.
	 * @param _IPFS The IPFS hash.
	 */
	event EvidenceAdded(address _initiator, uint256 _caseID, string _IPFS);

	/* CONSTRUCTOR */

	/*
	 * @param _chiefJustice The Chief Justice Address.
	 * @dev _chiefJustice cannot be a zero address.
	 */
	constructor(address _chiefJustice) public CourtifyRights(_chiefJustice) {
		lastCaseID = 1;
		totalPetitoner = 1;
	}

	/* PUBLIC */

	/*
	 * @notice Function to create a new case.
	 * @param _timestamp The time when the case was created.
	 * @param _state The state where the case was created.
	 * @param _district The district where the case was created.
	 * @param _court The court where the case was created.
	 * @param _petitonerID The Petitioner ID.
	 * @param _name The Petitioner Name.
	 * @param _caseType The case type.
	 * @return _newCaseID The new case id which was created.
	 */
	function createNewCase(
		uint256 _timestamp,
		string memory _state,
		string memory _district,
		string memory _court,
		uint256 _petitonerID,
		string memory _name,
		uint256 _caseType
	) public onlyCourt returns (uint256 _newCaseID) {
		_newCaseID = _createNewCase(_timestamp, _state, _district, _court, _petitonerID, _name, _caseType);
	}

	/*
	 * @notice Function to upload the evidence.
	 * @param _caseID The case ID for which the evidence will be added.
	 * @param _IPFS The IPFS hash.
	 */
	function uploadEvidence(uint256 _caseID, string memory _IPFS) public onlyAdvocate {
		_uploadEvidence(_caseID, _IPFS);
	}

	/* INTERNAL */

	/*
	 * @param _timestamp The time when the case was created.
	 * @param _state The state where the case was created.
	 * @param _district The district where the case was created.
	 * @param _court The court where the case was created.
	 * @param _petitonerID The Petitioner ID.
	 * @param _name The Petitioner Name.
	 * @param _caseType The case type.
	 * @return _newCaseID The new case id which was created.
	 * @dev The internal function which creates a new case.
	 */
	function _createNewCase(
		uint256 _timestamp,
		string memory _state,
		string memory _district,
		string memory _court,
		uint256 _petitonerID,
		string memory _name,
		uint256 _caseType
	) internal returns (uint256 _newCaseID) {
		_newCaseID = lastCaseID;
		Case storage _case = cases[_newCaseID];
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
		emit CaseCreated(msg.sender, _newCaseID, _timestamp, _state, _district, _court, _petitonerID, _caseType);
		lastCaseID++;
	}

	/*
	 * @param _caseID The case ID for which the evidence will be added.
	 * @param _IPFS The IPFS hash.
	 * @dev Internal function to upload the evidence.
	 */
	function _uploadEvidence(uint256 _caseID, string memory _IPFS) internal {
		cases[_caseID].evidence.push(_IPFS);
		emit EvidenceAdded(msg.sender, _caseID, _IPFS);
	}

	/* GETTER */

	/*
	 * @notice Function to get the case details.
	 * @param _caseID The case ID which has to be queried.
	 * @return _timestamp The time when the case was created.
	 * @return _state The state where the case was created.
	 * @return _district The district where the case was created.
	 * @return _court The court where the case was created.
	 * @return _name The Petitioner Name.
	 * @return _caseType The case type.
	 */
	function getCase(uint256 _caseID)
		public
		view
		returns (
			uint256 _timestamp,
			string memory _state,
			string memory _district,
			string memory _court,
			string memory _name,
			uint256 _caseType
		)
	{
		Case memory _case = cases[_caseID];
		Petitoner memory petitoner = petitoners[_case.petitonerID];
		return (_case.timestamp, _case.state, _case.district, _case.court, petitoner.name, _case.caseType);
	}

	/*
	 * @notice Function to get the evidence of a case.
	 * @param _caseID The case ID which has to be queried.
	 * @return The IPFS array of evidences for a case.
	 */
	function getEvidence(uint256 _caseID) public view returns (string[] memory) {
		return cases[_caseID].evidence;
	}
}
