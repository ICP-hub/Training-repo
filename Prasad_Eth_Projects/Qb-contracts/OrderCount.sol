// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderCalculator {
    uint256 public orderAmount;
    uint256 public taxAmount;
    uint256 public couponValue;

    event OrderDetailsUpdated(uint256 orderAmount, uint256 taxAmount, uint256 couponValue);

    function setOrderDetails(
        uint256 _orderAmount,
        uint256 _taxAmount,
        uint256 _couponValue
    ) external {
        orderAmount = _orderAmount;
        taxAmount = _taxAmount;
        couponValue = _couponValue;
        
        emit OrderDetailsUpdated(_orderAmount, _taxAmount, _couponValue);
    }

    function calculateDiscountedAmount() public view returns (uint256) {
        return orderAmount > couponValue ? orderAmount - couponValue : 0;
    }

    function calculateTotalAmount() external view returns (uint256) {
        return calculateDiscountedAmount() + taxAmount;
    }
}
