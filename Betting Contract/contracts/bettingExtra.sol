pragma solidity 0.4.20;


contract Betting {
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    address public oracle;
    address public owner;

    address[] public gamblerArray;
    address[] public winners;

    uint[] possibleOutcomes;
    uint public amountTotal;

    mapping (address => bool) public gamblers;
    mapping (address => Bet) private bets;
    mapping (address => uint) winnings;
    mapping (uint => uint) public outcomes;

    event BetMade(address gambler);
    event BetClosed();

    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    modifier oracleOnly() {
        require(msg.sender == oracle);
        _;}
    modifier outcomeExists(uint outcome) {
        require(outcome != 0);
        _;
    }


    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        owner = msg.sender;
        possibleOutcomes = _outcomes;
        uint i = 0;
        while (i < _outcomes.length) {
            outcomes[_outcomes[i]] = 1;
            i++;
        }
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() {
        if (gamblers[_oracle] != true && _oracle != owner) {
        oracle = _oracle;
        }
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        require(msg.sender != 0);
        if (msg.sender != oracle &&
            msg.sender != owner) {

            Bet memory newBet = Bet({
                outcome: _outcome,
                amount: msg.value,
                initialized: true
            });
        bets[msg.sender] = newBet;
        gamblerArray.push(msg.sender);

        } else {
             revert();
             return false;
        }
        BetMade(msg.sender);
        return true;
    }
    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        uint i;
        for (i=0; i < gamblerArray.length; i++) {
            require(bets[gamblerArray[i]].initialized == true);
            amountTotal += bets[gamblerArray[i]].amount;
            if(bets[gamblerArray[i]].outcome == _outcome) {
                winners.push(gamblerArray[i]);
                continue;
            } else {
                continue;
            }

        if (winners[0] == 0) {
            winnings[oracle] = amountTotal;
            } else {
                for (i=0; i < winners.length; i++) {
            winnings[winners[i]] = amountTotal / winners.length;
                }
            }

        BetClosed();
        }
    }
    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount >= winnings[msg.sender]);
            winnings[msg.sender] -= withdrawAmount;
            msg.sender.transfer(withdrawAmount);
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes() public view returns (uint[]) {
        return possibleOutcomes;
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        uint i;
        delete(winners);
        for (i=0; i <= gamblerArray.length; i++) {
            delete(bets[gamblerArray[i]]);
        delete(gamblerArray);
        }
    }
      /* Fallback function */
    function() public payable {
        revert();
    }
}
