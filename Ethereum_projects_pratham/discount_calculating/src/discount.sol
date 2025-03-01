// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BillCalculator {
    uint256 public basePrice;
    uint256 public appliedDiscount;
    uint256 public appliedTax;

    /**
     * @dev Sets initial order values.
     * @param _basePrice Initial order price before any discount or tax.
     * @param _taxRate Tax applied on the final price after discount.
     * @param _discountValue Discount amount applied.
     */
    function initializeOrder(
        uint256 _basePrice,
        uint256 _taxRate,
        uint256 _discountValue
    ) external {
        basePrice = _basePrice;
        appliedTax = _taxRate;
        appliedDiscount = _discountValue;
    }

    /**
     * @dev Computes net price after applying discount.
     * @param _basePrice The original price before discount.
     * @param _discount The discount value.
     * @return Net price after discount (never negative).
     */
    function computeDiscountedPrice(
        uint256 _basePrice,
        uint256 _discount
    ) public pure returns (uint256) {
        if (_discount >= _basePrice) {
            return 0;
        }
        return _basePrice - _discount;
    }

    /**
     * @dev Computes net price after discount using stored values.
     * @return Net price after discount.
     */
    function getDiscountedAmount() public view returns (uint256) {
        return computeDiscountedPrice(basePrice, appliedDiscount);
    }

    /**
     * @dev Computes tax based on the amount after discount.
     * @param _priceAfterDiscount The discounted price on which tax is applied.
     * @param _taxRate The percentage tax to apply.
     * @return Tax amount.
     */
    function calculateTax(
        uint256 _priceAfterDiscount,
        uint256 _taxRate
    ) public pure returns (uint256) {
        return (_priceAfterDiscount * _taxRate) / 100;
    }

    /**
     * @dev Computes tax on stored discounted price.
     * @return Tax amount on discounted price.
     */
    function getTaxOnDiscountedAmount() public view returns (uint256) {
        return calculateTax(getDiscountedAmount(), appliedTax);
    }

    /**
     * @dev Computes the final payable amount (Discounted Price + Tax).
     * @param _basePrice Initial order price.
     * @param _discount Discount applied.
     * @param _taxRate Tax percentage.
     * @return Final payable amount.
     */
    function computeTotalPayable(
        uint256 _basePrice,
        uint256 _discount,
        uint256 _taxRate
    ) public pure returns (uint256) {
        uint256 netAmount = computeDiscountedPrice(_basePrice, _discount);
        uint256 computedTax = calculateTax(netAmount, _taxRate);
        return netAmount + computedTax;
    }

    /**
     * @dev Computes the final payable amount using stored values.
     * @return Final price after discount and tax.
     */
    function getTotalBill() public view returns (uint256) {
        uint256 netAmount = getDiscountedAmount();
        uint256 computedTax = getTaxOnDiscountedAmount();
        return netAmount + computedTax;
    }
}
