pragma solidity ^0.4.19;

contract XorFunction {
    uint public num1;
    uint public num2;
    bool public result;

    function XorFunction(uint _num1, uint _num2) public {
        require(_num1 == 1 || _num1 == 0);
        require(_num2 == 1 || _num2 == 0);
        num1 = _num1;
        num2 = _num2;
        if (num1 != num2) {
            result = true;
        } else {
            result = false;
        }
    }

    function calculate() public view returns(bool){
        return result;
    }

    function() {
        revert();
    }
}
