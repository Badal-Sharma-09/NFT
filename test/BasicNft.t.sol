// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {BasicNft} from "../src/BasicNft.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract TestBasicNFT is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    address public constant USER = address(1);
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testName() public {
        string memory expectName = "Doggie";
        string memory actualName = basicNft.name();
        assertEq(keccak256(abi.encodePacked(expectName)), keccak256(abi.encodePacked(actualName)));
    }

    function testSymbol() public {
        string memory expectSymbol = "Dog";
        string memory actualSymbol = basicNft.symbol();
        assertEq(keccak256(abi.encodePacked(expectSymbol)), keccak256(abi.encodePacked(actualSymbol)));
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        basicNft.mint(PUG_URI);
        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenURIIsCorrect() public {
        vm.prank(USER);
        basicNft.mint(PUG_URI);
        assert(keccak256(abi.encodePacked(PUG_URI)) == keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }

    function testCounter() public {
        uint256 startingCount = basicNft.getTokenCounter();
        console.log("count", startingCount);
        vm.prank(USER);
        basicNft.mint(PUG_URI);
        uint256 AfterCount = basicNft.getTokenCounter();
        console.log("count", AfterCount);
        assert(AfterCount == startingCount + 1);
    }

    function testGetErrorIfTokenUriIsNotExist() public {
        vm.prank(USER);
        vm.expectRevert(BasicNft.BasicNft__TokenUriNotFound.selector);
        basicNft.tokenURI(2);
    }
}
