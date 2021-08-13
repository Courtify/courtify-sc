pragma solidity ^0.5.17;

/**
 *  @title A access contract with granular access for multiple parties.
 *  @author Shebin John - admin@remedcu.com
 *  @notice You can use this contract for creating multiple roles with different access.
 *  @dev To add a new role, add the corresponding array and mapping, along with add, remove and get functions.
 */
contract CourtifyRights {
	/* Storage */

	address public chiefJustice;
	address[] private courts;
	address[] private advocates;

	mapping(address => bool) private isCourt;
	mapping(address => bool) private isAdvocate;
	/**
	 * @notice In the future new list can be added based on the required limit.
	 * When adding a new list, a new array & mapping has to be created.
	 * Adding/Removing functions, getter for array and mapping.
	 * Events for Adding/Removing and modifier to check the validity.
	 */

	/* Events */

	/**
	 * @notice Emitted when a chief justice position is transferred.
	 * @param _oldChiefJustice The one who initiates this event. Will be the current chief justice.
	 * @param _newChiefJustice The new chief justice who has been added recently.
	 */
	event ChiefJusticeTransferred(address indexed _oldChiefJustice, address indexed _newChiefJustice);

	/**
	 * @notice Emitted when a new court is added.
	 * @param _initiator The one who initiates this event.
	 * @param _newCourt The new court who has been added recently.
	 */
	event CourtAdded(address indexed _initiator, address indexed _newCourt);

	/**
	 * @notice Emitted when a court is removed.
	 * @param _initiator The one who initiates this event.
	 * @param _removedCourt The court who has been removed.
	 */
	event CourtRemoved(address indexed _initiator, address indexed _removedCourt);

	/**
	 * @notice Emitted when an Advocate is added.
	 * @param _initiator The one who initiates this event.
	 * @param _newAdvocate The new Advocate who has been added recently.
	 */
	event AdvocateAdded(address indexed _initiator, address indexed _newAdvocate);

	/**
	 * @notice Emitted when an Advocate is removed.
	 * @param _initiator The one who initiates this event.
	 * @param _removedAdvocate The Advocate who has been removed.
	 */
	event AdvocateRemoved(address indexed _initiator, address indexed _removedAdvocate);

	/* Modifiers */

	/**
	 * @dev Throws if called by any account other than the Chief Justice.
	 */
	modifier onlyChiefJustice() {
		require(chiefJustice == msg.sender, "CourtifyRights: Only Chief Justice can call this function.");
		_;
	}

	/**
	 * @dev Throws if called by any account other than the Court.
	 */
	modifier onlyCourt() {
		require(isCourt[msg.sender], "CourtifyRights: Only Court can call this function.");
		_;
	}

	/**
	 * @dev Throws if called by any account other than the Advocate.
	 */
	modifier onlyAdvocate() {
		require(isAdvocate[msg.sender], "CourtifyRights: Only Advocate can call this function.");
		_;
	}

	/* Functions */

	/**
	 * @dev Initializes the contract, setting the Chief Justice initially.
	 * @param _chiefJustice The Chief Justice Address.
	 */
	constructor(address _chiefJustice) public {
		require(_chiefJustice != address(0), "CourtifyRights: Chief Justice Address cannot be a zero Address.");
		chiefJustice = _chiefJustice;
		emit ChiefJusticeTransferred(address(0), _chiefJustice);
	}

	/**
	 * @notice The function to transfer Chief Justice Position.
	 * @param _newChiefJustice The address of the new Chief Justice.
	 * @dev Only callable by Chief Justice.
	 */
	function transferChiefJustice(address _newChiefJustice) public onlyChiefJustice {
		_transferChiefJustice(_newChiefJustice);
	}

	/**
	 * @notice The function to add a new court.
	 * @param _newCourt The address of the new court.
	 * @dev Only callable by Chief Justice.
	 */
	function addCourt(address _newCourt) public onlyChiefJustice {
		_addCourt(_newCourt);
	}

	/**
	 * @notice The function to remove a court.
	 * @param _courtToRemove The address of the court which should be removed.
	 * @dev Only callable by Chief Justice.
	 */
	function removeCourt(address _courtToRemove) public onlyChiefJustice {
		_removeCourt(_courtToRemove);
	}

	/**
	 * @notice The function to add a new advocate.
	 * @param _newAdvocate The address of the new advocate.
	 * @dev Only callable by a Court.
	 */
	function addAdvocate(address _newAdvocate) public onlyCourt {
		_addAdvocate(_newAdvocate);
	}

	/**
	 * @notice The function to remove an advocate.
	 * @param _advocateToRemove The address of the advocate which should be removed.
	 * @dev Only callable by a Court.
	 */
	function removeAdvocate(address _advocateToRemove) public onlyCourt {
		_removeAdvocate(_advocateToRemove);
	}

	/* Internal Functions */

	/**
	 * @notice The internal function to add a new court.
	 * @param _newChiefJustice The address of the new court.
	 */
	function _transferChiefJustice(address _newChiefJustice) internal {
		require(_newChiefJustice != address(0), "CourtifyRights: Invalid Address.");
		chiefJustice = _newChiefJustice;
		emit ChiefJusticeTransferred(msg.sender, _newChiefJustice);
	}

	/**
	 * @notice The internal function to add a new court.
	 * @param _newCourt The address of the new court.
	 */
	function _addCourt(address _newCourt) internal {
		require(_newCourt != address(0), "CourtifyRights: Invalid Address.");
		require(!isCourt[_newCourt], "CourtifyRights: Address is already a court.");
		isCourt[_newCourt] = true;
		courts.push(_newCourt);

		emit CourtAdded(msg.sender, _newCourt);
	}

	/**
	 * @notice The internal function to remove a court.
	 * @param _courtToRemove The address of the court which should be removed.
	 */
	function _removeCourt(address _courtToRemove) internal {
		require(isCourt[_courtToRemove], "CourtifyRights: Address is not a court.");
		isCourt[_courtToRemove] = false;
		uint256 len = courts.length;
		for (uint256 index = 0; index < len; index++) {
			if (_courtToRemove == courts[index]) {
				courts[index] = courts[len - 1];
				break;
			}
		}
		courts.pop();

		emit CourtRemoved(msg.sender, _courtToRemove);
	}

	/**
	 * @notice The internal function to add a new advocate.
	 * @param _newAdvocate The address of the new advocate.
	 */
	function _addAdvocate(address _newAdvocate) internal {
		require(_newAdvocate != address(0), "CourtifyRights: Invalid Address.");
		require(!isAdvocate[_newAdvocate], "CourtifyRights: Address is already an advocate.");
		isAdvocate[_newAdvocate] = true;
		advocates.push(_newAdvocate);

		emit AdvocateAdded(msg.sender, _newAdvocate);
	}

	/**
	 * @notice The internal function to remove an advocate.
	 * @param _advocateToRemove The address of the advocate which should be removed.
	 */
	function _removeAdvocate(address _advocateToRemove) internal {
		require(isAdvocate[_advocateToRemove], "CourtifyRights: Address is not an advocate.");
		isAdvocate[_advocateToRemove] = false;
		uint256 len = advocates.length;
		for (uint256 index = 0; index < len; index++) {
			if (_advocateToRemove == advocates[index]) {
				advocates[index] = advocates[len - 1];
				break;
			}
		}
		advocates.pop();

		emit AdvocateRemoved(msg.sender, _advocateToRemove);
	}

	/* Getter Functions */

	/**
	 * @notice Checks if the passed address is an court or not.
	 * @param _addr The address to check.
	 * @return True if Court, False otherwise.
	 */
	function checkCourt(address _addr) public view returns (bool) {
		return isCourt[_addr];
	}

	/**
	 * @notice Checks if the passed address is a advocate or not.
	 * @param _addr The address to check.
	 * @return True if Advocate, False otherwise.
	 */
	function checkAdvocate(address _addr) public view returns (bool) {
		return isAdvocate[_addr];
	}

	/**
	 * @dev Returns the address array of the courts.
	 * @return The list of courts.
	 */
	function getCourts() public view returns (address[] memory) {
		return courts;
	}

	/**
	 * @dev Returns the address array of the advocate.
	 * @return The list of advocates.
	 */
	function getAdvocates() public view returns (address[] memory) {
		return advocates;
	}
}
