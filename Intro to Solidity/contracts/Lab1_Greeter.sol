pragma solidity ^0.4.18;

contract Greeter {

    string greeting;

    function Greeter2(string _greeting) public {
        greeting = _greeting;
    }
    
    ///BONUS!! Change the greeting without deploying a new contract //
    function changeGreeting(string _newGreeting) public {
        greeting = _newGreeting;
    }

    function getGreeting() public view returns(string){
        return greeting;
    }
    
    function() {
        revert();
}
