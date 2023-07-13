//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundme;
    uint256 supply = 5e18;
    address USER = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, 20 ether);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwner() public {
        assertEq(fundme.getOwner(), msg.sender);
    }

    function testGetVersion() public {
        uint256 version = fundme.getVersion();
        console.log(version);
        assertEq(version, 4);
    }

    function testFundMeShouldRevertWithoutFunds() public {
        vm.expectRevert();
        fundme.fund();
    }

    modifier FundMeMod() {
        vm.prank(USER);
        fundme.fund{value: 10e18}();
        _;
    }

    function testFundMeUpdateDataStructure() public FundMeMod {
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, 10e18);
    }
    function testGetFunders() public  FundMeMod {
        address funder = fundme.getFunder(0);
        assertEq(funder,USER);
    }

    function testOnlyOwnerCanCallWithdraw() public FundMeMod {
        vm.expectRevert();
        fundme.withdraw();
    }
    
    function testWithrawWithOwner() public {
        //Arrange
         uint256 startingOwnerBalance = fundme.getOwner().balance;
         uint256 startingFundmeBalance = address(fundme).balance;
        //act
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        //assert 
         uint256 endingOwnerBalance = fundme.getOwner().balance;
         uint256 endingfundmeBalance = address(fundme).balance;
         assertEq(endingfundmeBalance, 0);
         assertEq(startingFundmeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public {
        uint160 numbersOfFunders = 10;
        uint160 startingIndex = 1;
        for(uint160 i = startingIndex; i < numbersOfFunders; i++){
            hoax(address(i), 10 ether); 
            fundme.fund{value: 10e18}();
        }

         uint256 startingOwnerBalance = fundme.getOwner().balance;
         uint256 startingFundmeBalance = address(fundme).balance;
        //Act
        uint256 gasStart = gasleft(); // gas = 1000
        vm.txGasPrice(1);
        vm.startPrank(fundme.getOwner());
        fundme.withdraw(); // gas =200
        vm.stopPrank();
        uint256 gasEnd = gasleft(); // gas 800
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice ;
        console.log("gas used is ?");
        console.log(gasUsed);
        //Assert
        assertEq(address(fundme).balance, 0);
        assertEq(startingFundmeBalance + startingOwnerBalance, fundme.getOwner().balance);
    
    }

      function testWithdrawFromMultipleFundersMemory1() public {
        uint160 numbersOfFunders = 10;
        uint160 startingIndex = 1;
        for(uint160 i = startingIndex; i < numbersOfFunders; i++){
            hoax(address(i), 10 ether); 
            fundme.fund{value: 10e18}();
        }

         uint256 startingOwnerBalance = fundme.getOwner().balance;
         uint256 startingFundmeBalance = address(fundme).balance;
        //Act
        uint256 gasStart = gasleft(); // gas = 1000
        vm.txGasPrice(1);
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithdraw(); // gas =200
        vm.stopPrank();
        uint256 gasEnd = gasleft(); // gas 800
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice ;
        console.log("gas used is ?");
        console.log(gasUsed);
        //Assert
        assertEq(address(fundme).balance, 0);
        assertEq(startingFundmeBalance + startingOwnerBalance, fundme.getOwner().balance);
    
    }
    function testWithdrawFromMultipleFundersMemory2() public {
        uint160 numbersOfFunders = 10;
        uint160 startingIndex = 1;
        for(uint160 i = startingIndex; i < numbersOfFunders; i++){
            hoax(address(i), 10 ether); 
            fundme.fund{value: 10e18}();
        }

         uint256 startingOwnerBalance = fundme.getOwner().balance;
         uint256 startingFundmeBalance = address(fundme).balance;
        //Act
        uint256 gasStart = gasleft(); // gas = 1000
        vm.txGasPrice(1);
        vm.startPrank(fundme.getOwner());
        fundme.cheaperWithdraww(); // gas =200
        vm.stopPrank();
        uint256 gasEnd = gasleft(); // gas 800
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice ;
        console.log("gas used is ?");
        console.log(gasUsed);
        //Assert
        assertEq(address(fundme).balance, 0);
        assertEq(startingFundmeBalance + startingOwnerBalance, fundme.getOwner().balance);
    
    }
}
