// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Pocketpay Contract
 * @dev This contract handles merchant transactions.
 */
contract Pocketpay is ReentrancyGuard {
    address public owner;

    /**
     * @dev Constructor to set the contract deployer as the owner
     */
    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner
    }

    /**
     * @dev Modifier to check if the function caller is the owner of the contract
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /**
     * @dev Struct to store merchant information.
     */
    struct Merchant {
        string merchant_name;
        uint64 merchant_id;
        address payable merchant_address;
    }

    /**
     * @dev Mapping to store merchant records with their IDs as keys.
     */
    mapping(uint64 => Merchant) public MerchantStat;

    // Mapping from _merchant_id to transaction hash
    mapping(uint64 => string) private transactionHashes;

    /**
     * @dev Event to log new merchant transaction.
     */

    event MerchantEvent(
        string merchant_name,
        uint64 merchant_id,
        address merchant_address,
        uint256 amount
    );

    /**
     * @dev Function to process a merchant transaction.
     * @param _merchant_name Name of the merchant.
     * @param _merchant_id ID of the merchant.
     */
    function transaction(
        string memory _merchant_name,
        uint64 _merchant_id,
        address payable _merchant_address
    ) public payable nonReentrant {
        require(
            MerchantStat[_merchant_id].merchant_id == 0,
            "Merchant ID already exists"
        );
        require(msg.value > 0, "Send some BNB");
        MerchantStat[_merchant_id] = Merchant({
            merchant_name: _merchant_name,
            merchant_id: _merchant_id,
            merchant_address: _merchant_address
        });

        emit MerchantEvent(
            _merchant_name,
            _merchant_id,
            _merchant_address,
            msg.value
        );

        (bool sent, bytes memory data) = _merchant_address.call{
            value: msg.value
        }("");
        require(sent, "Failed to send Ether");
    }

    /**
     * @dev Function to get merchant details.
     * @param _merchant_id ID of the merchant.
     * @return merchant_name, merchant_id
     */
    function getMerchant(
        uint64 _merchant_id
    ) public view returns (string memory, uint64) {
        Merchant memory merchant = MerchantStat[_merchant_id];
        return (merchant.merchant_name, merchant.merchant_id);
    }

    /**
     * @dev Function to check if merchant exists.
     * @param _merchant_id ID of the merchant.
     * @return bool
     */
    function isMerchantExists(uint64 _merchant_id) public view returns (bool) {
        return MerchantStat[_merchant_id].merchant_id != 0;
    }

    /**
     * @dev Function to delete a merchant record.
     * @param _merchant_id ID of the merchant. Only owner can delete a merchant
     */
    function deleteMerchant(uint64 _merchant_id) public onlyOwner {
        require(
            MerchantStat[_merchant_id].merchant_id != 0,
            "Merchant does not exist"
        );
        delete MerchantStat[_merchant_id];
    }

    /**
     * @dev Function to store a transaction hash.
     * @param _merchant_id ID of the merchant.
     * @param txHash Tx Hash of the users.
     */
    function storeTransactionHash(
        uint64 _merchant_id,
        string memory txHash
    ) public {
        transactionHashes[_merchant_id] = txHash;
    }

    /**
     * @dev Function will give users Tx hash exists.
     * @param _merchant_id ID of the merchant.
     * @return bool
     */
    function getTransactionHash(
        uint64 _merchant_id
    ) public view returns (string memory, bool) {
        string memory txHash = transactionHashes[_merchant_id];
        bool exists = bytes(txHash).length > 0;
        return (txHash, exists);
    }
}
