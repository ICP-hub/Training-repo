// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderCalculator {
    uint256 public orderAmount;
    uint256 public taxAmount;
    uint256 public couponValue;
    /**
     * @dev Sets the order details
     * @param _orderAmount Total order amount before tax and coupon
     * @param _taxAmount Tax amount (not affected by coupon)
     * @param _couponValue Coupon value to apply
     */
    function setOrderDetails(
        uint256 _orderAmount,
        uint256 _taxAmount,
        uint256 _couponValue
    ) external {
        orderAmount = _orderAmount;
        taxAmount = _taxAmount;
        couponValue = _couponValue;
    }
    
    /**
     * @dev Calculates price after subtracting coupon from order amount
     * @param _orderAmount The initial order amount
     * @param _couponValue The coupon value to apply
     * @return Final amount after coupon discount (never less than 0)
     */
    function finalAmount(uint256 _orderAmount, uint256 _couponValue) public pure returns (uint256) {
        if (_couponValue >= _orderAmount) {
            return 0;
        }
        return _orderAmount - _couponValue;
    }
    
    /**
     * @dev Version of finalAmount that uses stored state variables
     * @return Final amount after coupon discount (never less than 0)
     */
    function finalAmount() public view returns (uint256) {
        return finalAmount(orderAmount, couponValue);
    }
    
    /**
     * @dev Calculates tax on the order amount at the specified rate
     * @param _orderAmount The amount to calculate tax on
     * @param _taxRate The tax rate in percentage (e.g., 12 for 12%)
     * @return Tax amount
     */
    function totalTax(uint256 _orderAmount, uint256 _taxRate) public pure returns (uint256) {
        return (_orderAmount * _taxRate) / 100;
    }
    
    /**
     * @dev Version of totalTax that uses stored order amount with 12% rate
     * @return Tax amount at 12%
     */
    function totalTax() public view returns (uint256) {
        return totalTax(orderAmount, 12);
    }
    
    /**
     * @dev Calculates final amount plus tax with provided parameters
     * @param _orderAmount The initial order amount
     * @param _couponValue The coupon value to apply
     * @param _taxRate The tax rate in percentage
     * @return Final amount after coupon discount plus tax
     */
    function calculateFinalAmountWithTax(
        uint256 _orderAmount,
        uint256 _couponValue,
        uint256 _taxRate
    ) public pure returns (uint256) {
        uint256 discountedAmount = finalAmount(_orderAmount, _couponValue);
        uint256 calculatedTax = totalTax(_orderAmount, _taxRate);
        return discountedAmount + calculatedTax;
    }
    
    /**
     * @dev Calculates final amount plus tax using stored state variables
     * @return Final amount after coupon discount plus tax
     */
    function finalAmountAfterTax() public view returns (uint256) {
        uint256 discountedAmount = finalAmount();
        uint256 calculatedTax = totalTax();
        return discountedAmount + calculatedTax;
    }
}