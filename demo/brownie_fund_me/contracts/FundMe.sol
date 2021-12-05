// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

// Interfaces compile down to an ABI(Application Binary Interface).
// The ABI tells solidity and other programming languages how it
// can interact with another contract.
// Anytime you wnat to interact with an already deployed smart contract,
// You will need an ABI.
// Always need an ABI to interact with a contract.

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);
//   function description() external view returns (string memory);
//   function version() external view returns (uint256);
// 
//   getRoundData and latestRoundData should both raise "No data present"
//   if they do not have data to report, instead of returning unset values
//   which could be misinterpreted as actual reported values.
//   function getRoundData(uint80 _roundId)
    // external
    // view
    // returns (
    //   uint80 roundId,
    //   int256 answer,
    //   uint256 startedAt,
    //   uint256 updatedAt,
    //   uint80 answeredInRound
    // );
// 
//   function latestRoundData()
    // external
    // view
    // returns (
    //   uint80 roundId,
    //   int256 answer,
    //   uint256 startedAt,
    //   uint256 updatedAt,
    //   uint80 answeredInRound
    // );
// }
// 
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }


    function fund() public payable {
        // $50
        uint256 mimimumUSD = 50 * 10 ** 18;
        // 1gwei < $50
        require(getConversionRate(msg.value) >= mimimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    // getPrice ETH/USD
    function getPriceDefault() public view returns (uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer); // answer(ETH) to (Gwei).
    }

    // getPrice ETH/USD (Gwei)
    function getPrice() public view returns (uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * (10**10)); // answer(ETH) to (Gwei).
    }

    // 1Gwei = 1,000,000,000wei
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice(); // ETH/USD (Gwei)
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10**18);
        return ethAmountInUsd;
        // 4076770000000
        // 0.000004076770000000 Gwei/USD
    }

    function getEntranceFee() public view returns (uint256) {
        // mimimumUSD
        uint256 mimimuUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (mimimuUSD * precision) / price;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);

        for(uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}