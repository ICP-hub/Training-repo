// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract Invoice {
    // Variables
    uint256 public originalAmount; // Amount of goods before tax and discount
    uint256 public discount;       // Discount amount
    uint256 public taxRate = 5;    // GST fixed at 5%

    // Constructor to initialize the invoice with original amount and discount
    constructor(uint256 _originalAmount, uint256 _discount) {
        originalAmount = _originalAmount;
        discount = _discount;
    }

    // Function to calculate GST 
    function getGST() public view returns (uint256) {
        return (originalAmount * taxRate) / 100;
    }

    // Function to calculate subtotal (original amount + GST)
    function getSubtotal() public view returns (uint256) {
        return originalAmount + getGST();
    }

    // Function to calculate final amount to pay (subtotal - discount)
    function getFinalAmount() public view returns (uint256) {
        uint256 subtotal = getSubtotal();
        if (subtotal > discount) {
            return subtotal - discount; // Final amount after discount
        } else {
            return 0; // Prevent negative payment
        }
    }
}