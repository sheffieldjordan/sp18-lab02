pragma solidity ^0.4.18;

contract concat {
    string concatStr;

    function concat(string _a, string _b) public {
        bytes memory _str1 = bytes(_a);
        bytes memory _str2 = bytes(_b);
        string memory _concat = new string(_str1.length + _str2.length);
        bytes memory _concatMem = bytes(_concat);
        uint strIndex = 0;

        for (uint i = 0; i < _str1.length; i++) {
            _concatMem[strIndex++] = _str1[i];
        }

        for (uint j = 0; j < _str2.length; j++) {
            _concatMem[strIndex++] = _str2[j];
        }

        concatStr = string(_concatMem);
        return;
    }



    function show() public view returns(string) {
        return concatStr;
    }

    function() public {
        revert();
    }
}
