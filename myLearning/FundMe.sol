// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

// Interfaces compile down to an ABI(Application Binary Interface).
// The ABI tells solidity and other programming languages how it
// can interact with another contract.
// Anytime you wnat to interact with an already deployed smart contract,
// You will need an ABI.
// Always need an ABI to interact with a contract.

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}


contract FundMe {

    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // $50
        uint256 mimimumUSD = 50 * 10 ** 18;
        // 1gwei < $50
        require(getConversionRate(msg.value) >= mimimumUSD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        // what the ETH -> USD conversion rate
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    // getPrice ETH/USD
    function getPriceDefault() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer); // answer(ETH) to (Gwei).
    }

    // getPrice ETH/USD (Gwei)
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
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
}