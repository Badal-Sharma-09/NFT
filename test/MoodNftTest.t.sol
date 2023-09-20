// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.19;

import {MoodNft} from "../src/MoodNft.sol";
import {Test} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {console} from "../lib/forge-std/src/console.sol";

contract MoodNftTest is StdCheats, Test {
    MoodNft public moodNft;
    DeployMoodNft public deploy;

    event CreatedNFT(uint256 indexed tokenId);

    string public constant NFT_NAME = "Mood NFT";
    string public constant NFT_SYMBOL = "MN";
    address public constant USER = address(1);
    address public deployerAddress;

    string public constant HAPPY_MOOD_URI =
        "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIyYVdWM1FtOTRQU0l3SURBZ01qQXdJREl3TUNJZ2QybGtkR2c5SWpRd01DSWdJR2hsYVdkb2REMGlOREF3SWlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpUGcwS0lDQThZMmx5WTJ4bElHTjRQU0l4TURBaUlHTjVQU0l4TURBaUlHWnBiR3c5SW5sbGJHeHZkeUlnY2owaU56Z2lJSE4wY205clpUMGlZbXhoWTJzaUlITjBjbTlyWlMxM2FXUjBhRDBpTXlJdlBnMEtJQ0E4WnlCamJHRnpjejBpWlhsbGN5SStEUW9nSUNBZ1BHTnBjbU5zWlNCamVEMGlOakVpSUdONVBTSTRNaUlnY2owaU1USWlMejROQ2lBZ0lDQThZMmx5WTJ4bElHTjRQU0l4TWpjaUlHTjVQU0k0TWlJZ2NqMGlNVElpTHo0TkNpQWdQQzluUGcwS0lDQThjR0YwYUNCa1BTSnRNVE0yTGpneElERXhOaTQxTTJNdU5qa2dNall1TVRjdE5qUXVNVEVnTkRJdE9ERXVOVEl0TGpjeklpQnpkSGxzWlQwaVptbHNiRHB1YjI1bE95QnpkSEp2YTJVNklHSnNZV05yT3lCemRISnZhMlV0ZDJsa2RHZzZJRE03SWk4K0RRbzhMM04yWno0PSJ9";   
        
         string public constant SAD_MOOD_URI =
      "data:application/json;base64,eyJuYW1lIjoiTW9vZCBORlQiLCAiZGVzY3JpcHRpb24iOiJBbiBORlQgdGhhdCByZWZsZWN0cyB0aGUgbW9vZCBvZiB0aGUgb3duZXIsIDEwMCUgb24gQ2hhaW4hIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIm1vb2RpbmVzcyIsICJ2YWx1ZSI6IDEwMH1dLCAiaW1hZ2UiOiJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBEOTRiV3dnZG1WeWMybHZiajBpTVM0d0lpQnpkR0Z1WkdGc2IyNWxQU0p1YnlJL1BnMEtQSE4yWnlCM2FXUjBhRDBpTVRBeU5IQjRJaUJvWldsbmFIUTlJakV3TWpSd2VDSWdkbWxsZDBKdmVEMGlNQ0F3SURFd01qUWdNVEF5TkNJZ2VHMXNibk05SW1oMGRIQTZMeTkzZDNjdWR6TXViM0puTHpJd01EQXZjM1puSWo0TkNpQWdQSEJoZEdnZ1ptbHNiRDBpSXpNek15SWdaRDBpVFRVeE1pQTJORU15TmpRdU5pQTJOQ0EyTkNBeU5qUXVOaUEyTkNBMU1USnpNakF3TGpZZ05EUTRJRFEwT0NBME5EZ2dORFE0TFRJd01DNDJJRFEwT0MwME5EaFROelU1TGpRZ05qUWdOVEV5SURZMGVtMHdJRGd5TUdNdE1qQTFMalFnTUMwek56SXRNVFkyTGpZdE16Y3lMVE0zTW5NeE5qWXVOaTB6TnpJZ016Y3lMVE0zTWlBek56SWdNVFkyTGpZZ016Y3lJRE0zTWkweE5qWXVOaUF6TnpJdE16Y3lJRE0zTW5vaUx6NE5DaUFnUEhCaGRHZ2dabWxzYkQwaUkwVTJSVFpGTmlJZ1pEMGlUVFV4TWlBeE5EQmpMVEl3TlM0MElEQXRNemN5SURFMk5pNDJMVE0zTWlBek56SnpNVFkyTGpZZ016Y3lJRE0zTWlBek56SWdNemN5TFRFMk5pNDJJRE0zTWkwek56SXRNVFkyTGpZdE16Y3lMVE0zTWkwek56SjZUVEk0T0NBME1qRmhORGd1TURFZ05EZ3VNREVnTUNBd0lERWdPVFlnTUNBME9DNHdNU0EwT0M0d01TQXdJREFnTVMwNU5pQXdlbTB6TnpZZ01qY3lhQzAwT0M0eFl5MDBMaklnTUMwM0xqZ3RNeTR5TFRndU1TMDNMalJETmpBMElEWXpOaTR4SURVMk1pNDFJRFU1TnlBMU1USWdOVGszY3kwNU1pNHhJRE01TGpFdE9UVXVPQ0E0T0M0Mll5MHVNeUEwTGpJdE15NDVJRGN1TkMwNExqRWdOeTQwU0RNMk1HRTRJRGdnTUNBd0lERXRPQzA0TGpSak5DNDBMVGcwTGpNZ056UXVOUzB4TlRFdU5pQXhOakF0TVRVeExqWnpNVFUxTGpZZ05qY3VNeUF4TmpBZ01UVXhMalpoT0NBNElEQWdNQ0F4TFRnZ09DNDBlbTB5TkMweU1qUmhORGd1TURFZ05EZ3VNREVnTUNBd0lERWdNQzA1TmlBME9DNHdNU0EwT0M0d01TQXdJREFnTVNBd0lEazJlaUl2UGcwS0lDQThjR0YwYUNCbWFXeHNQU0lqTXpNeklpQmtQU0pOTWpnNElEUXlNV0UwT0NBME9DQXdJREVnTUNBNU5pQXdJRFE0SURRNElEQWdNU0F3TFRrMklEQjZiVEl5TkNBeE1USmpMVGcxTGpVZ01DMHhOVFV1TmlBMk55NHpMVEUyTUNBeE5URXVObUU0SURnZ01DQXdJREFnT0NBNExqUm9ORGd1TVdNMExqSWdNQ0EzTGpndE15NHlJRGd1TVMwM0xqUWdNeTQzTFRRNUxqVWdORFV1TXkwNE9DNDJJRGsxTGpndE9EZ3VObk01TWlBek9TNHhJRGsxTGpnZ09EZ3VObU11TXlBMExqSWdNeTQ1SURjdU5DQTRMakVnTnk0MFNEWTJOR0U0SURnZ01DQXdJREFnT0MwNExqUkROalkzTGpZZ05qQXdMak1nTlRrM0xqVWdOVE16SURVeE1pQTFNek42YlRFeU9DMHhNVEpoTkRnZ05EZ2dNQ0F4SURBZ09UWWdNQ0EwT0NBME9DQXdJREVnTUMwNU5pQXdlaUl2UGcwS1BDOXpkbWMrRFFvPSJ9";  
    function setUp() external {
        deploy = new DeployMoodNft();
        moodNft = deploy.run();
    }

    function testMoodNftName() public {
        string memory expectedName = "Mood NFT";
        string memory actualName = moodNft.name();
        assertEq(keccak256(abi.encodePacked(expectedName)), keccak256(abi.encodePacked(actualName)));
    }

    function testMoodNftSymbol() public {
        string memory expectedSymbol = "MN";
        string memory actualSymbol = moodNft.symbol();
        assertEq(keccak256(abi.encodePacked(expectedSymbol)), keccak256(abi.encodePacked(actualSymbol)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        moodNft.mintNft();

        assert(moodNft.balanceOf(USER) == 1);
    }

    function testTokenURIDefaultIsCorrectlySet() public {
        vm.prank(USER);
        moodNft.mintNft();
        console.log("Token URI:", moodNft.tokenURI(0));
        console.log("Happy Mood URI", HAPPY_MOOD_URI);
        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(HAPPY_MOOD_URI)));
    }

    function testFlipTokenToSad() public {
        vm.prank(USER);
        moodNft.mintNft();

        vm.prank(USER);
        moodNft.flipMood(0);
        //console.log("Token URI:", moodNft.tokenURI(0));
        console.log("Sad Mood URI", SAD_MOOD_URI);

        assert(keccak256(abi.encodePacked(moodNft.tokenURI(0))) == keccak256(abi.encodePacked(SAD_MOOD_URI)));
    }

    function testEventRecordsCorrectTokenIdOnMinting() public {
        uint256 currentAvailableTokenId = moodNft.getTokenCounter();

        vm.prank(USER);
        vm.recordLogs();
        moodNft.mintNft();
        Vm.Log[] memory entries = vm.getRecordedLogs();

        bytes32 tokenId_proto = entries[1].topics[1];
        uint256 tokenId = uint256(tokenId_proto);

        assertEq(tokenId, currentAvailableTokenId);
    }

    function testGetErrorIfCantFlipMoodIfNotOwner() public {
        vm.prank(USER);
        moodNft.mintNft();
        vm.prank(address(2));
        vm.expectRevert(MoodNft.MoodNft__CantFlipMoodIfNotOwner.selector);
        moodNft.flipMood(0);
    }

    function testGetErrorIfNonExistentToken() public {
        vm.prank(USER);
        vm.expectRevert(MoodNft.ERC721Metadata__URI_QueryFor_NonExistentToken.selector);
        moodNft.tokenURI(2);
    }

    function testCheckGetSadSvgIsCorrect() public {
        /**
         * @dev This is base64 encode of sad.svg
         */
        string memory expectSvg = "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/Pg0KPHN2ZyB3aWR0aD0iMTAyNHB4IiBoZWlnaHQ9IjEwMjRweCIgdmlld0JveD0iMCAwIDEwMjQgMTAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4NCiAgPHBhdGggZmlsbD0iIzMzMyIgZD0iTTUxMiA2NEMyNjQuNiA2NCA2NCAyNjQuNiA2NCA1MTJzMjAwLjYgNDQ4IDQ0OCA0NDggNDQ4LTIwMC42IDQ0OC00NDhTNzU5LjQgNjQgNTEyIDY0em0wIDgyMGMtMjA1LjQgMC0zNzItMTY2LjYtMzcyLTM3MnMxNjYuNi0zNzIgMzcyLTM3MiAzNzIgMTY2LjYgMzcyIDM3Mi0xNjYuNiAzNzItMzcyIDM3MnoiLz4NCiAgPHBhdGggZmlsbD0iI0U2RTZFNiIgZD0iTTUxMiAxNDBjLTIwNS40IDAtMzcyIDE2Ni42LTM3MiAzNzJzMTY2LjYgMzcyIDM3MiAzNzIgMzcyLTE2Ni42IDM3Mi0zNzItMTY2LjYtMzcyLTM3Mi0zNzJ6TTI4OCA0MjFhNDguMDEgNDguMDEgMCAwIDEgOTYgMCA0OC4wMSA0OC4wMSAwIDAgMS05NiAwem0zNzYgMjcyaC00OC4xYy00LjIgMC03LjgtMy4yLTguMS03LjRDNjA0IDYzNi4xIDU2Mi41IDU5NyA1MTIgNTk3cy05Mi4xIDM5LjEtOTUuOCA4OC42Yy0uMyA0LjItMy45IDcuNC04LjEgNy40SDM2MGE4IDggMCAwIDEtOC04LjRjNC40LTg0LjMgNzQuNS0xNTEuNiAxNjAtMTUxLjZzMTU1LjYgNjcuMyAxNjAgMTUxLjZhOCA4IDAgMCAxLTggOC40em0yNC0yMjRhNDguMDEgNDguMDEgMCAwIDEgMC05NiA0OC4wMSA0OC4wMSAwIDAgMSAwIDk2eiIvPg0KICA8cGF0aCBmaWxsPSIjMzMzIiBkPSJNMjg4IDQyMWE0OCA0OCAwIDEgMCA5NiAwIDQ4IDQ4IDAgMSAwLTk2IDB6bTIyNCAxMTJjLTg1LjUgMC0xNTUuNiA2Ny4zLTE2MCAxNTEuNmE4IDggMCAwIDAgOCA4LjRoNDguMWM0LjIgMCA3LjgtMy4yIDguMS03LjQgMy43LTQ5LjUgNDUuMy04OC42IDk1LjgtODguNnM5MiAzOS4xIDk1LjggODguNmMuMyA0LjIgMy45IDcuNCA4LjEgNy40SDY2NGE4IDggMCAwIDAgOC04LjRDNjY3LjYgNjAwLjMgNTk3LjUgNTMzIDUxMiA1MzN6bTEyOC0xMTJhNDggNDggMCAxIDAgOTYgMCA0OCA0OCAwIDEgMC05NiAweiIvPg0KPC9zdmc+DQo=";
        string memory actualSvg = moodNft.getSadSVG();
        assertEq(keccak256(abi.encodePacked(expectSvg)), keccak256(abi.encodePacked(actualSvg)));
    }

    function testCheckGetHappySvgIsCorrect() public {
        /**
         * @dev This is base64 encode of happy.svg
         */
        string memory expectSvg =
           "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgIGhlaWdodD0iNDAwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPg0KICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIvPg0KICA8ZyBjbGFzcz0iZXllcyI+DQogICAgPGNpcmNsZSBjeD0iNjEiIGN5PSI4MiIgcj0iMTIiLz4NCiAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiLz4NCiAgPC9nPg0KICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7Ii8+DQo8L3N2Zz4=";
        string memory actualSvg = moodNft.getHappySVG();
        assertEq(keccak256(abi.encodePacked(expectSvg)), keccak256(abi.encodePacked(actualSvg)));
    }

    function testEventIsCorrect() public {
        vm.prank(USER);
        console.log("Address of User:", USER);

        vm.expectEmit(true, false, false, false, address(moodNft));
        emit CreatedNFT(0);
        console.log("Address Of Who call Event:", 0);
        moodNft.mintNft();
    }
}
