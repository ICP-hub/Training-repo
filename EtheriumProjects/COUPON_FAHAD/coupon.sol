// SPDX-License-Identifier: MIT
pragma solidity >=0.8.12 <0.9.0;

contract coupon{
    uint tax = 5;
    mapping(string => uint) couponCodes;
    mapping(uint => uint) menuList;
    uint totalVal;
    address owner;

    constructor(){
        owner = msg.sender;
        totalVal = 0;
    }

    function addCoupons(string memory couponCode, uint discount) public {
        require(msg.sender == owner , "Not authorised");
        couponCodes[couponCode] = discount;
    }
    function addItems(uint _id, uint amount) public {
        require(msg.sender == owner , "Not authorised");
        menuList[_id] = amount;
    }

    function addToOrder(uint _itemId) public{
        uint itemValue = menuList[_itemId];
        totalVal = totalVal + itemValue;
    }
    function calculateOrderVal(uint _orderAmount, string memory _coupon) public view returns(uint){
        uint orderTax = (_orderAmount * tax) / 100;
        uint couponDiscount = couponCodes[_coupon];

        if(couponDiscount >= _orderAmount)
        {
            return orderTax;
        }
        else{
            return(_orderAmount - couponDiscount + orderTax);
        }
    }
}