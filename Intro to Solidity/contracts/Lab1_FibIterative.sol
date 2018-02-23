pragma solidity ^0.4.19;

contract FibIterative {
    uint[] terms = [0,1];
    uint numInSequence;
    uint numInSequenceValue;

    function FibIterative(uint _numInSequence) public {
        numInSequence = _numInSequence;
        uint i = 2;
        while (i <= numInSequence) {
            terms.push(terms[i-1] + terms[i-2]);
            i++;
        }
        numInSequenceValue = terms[numInSequence];
    }

    function getNumValue() public view returns (uint) {
        return numInSequenceValue;
    }

    function() {
      revert();
    }
}
