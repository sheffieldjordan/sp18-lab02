pragma solidity 0.4.20;


contract Betting {
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    address public oracle;
    address public owner;
    address public gamblerA;
    address public gamblerB;

    uint[] possibleOutcomes;

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
        if (_oracle != gamblerA && _oracle != gamblerB) {
        oracle = _oracle;
        }
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        if (msg.sender != oracle &&
            bets[msg.sender].initialized != true &&
            msg.sender != owner) {
            if (gamblerA == 0) {
                gamblerA = msg.sender;
            } else if (gamblerB == 0) {
                gamblerB = msg.sender;
            } else {
                revert();
                return false;
            }

        Bet memory newBet = Bet({
            outcome: _outcome,
            amount: msg.value,
            initialized: true
        });
        bets[msg.sender] = newBet;

        } else {
             revert();
             return false;
        }
        BetMade(msg.sender);
        return true;
    }
    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        require(bets[gamblerA].initialized == true &&
                bets[gamblerB].initialized == true);
        uint aBet = bets[gamblerA].outcome;
        uint bBet = bets[gamblerB].outcome;
        uint aWager = bets[gamblerA].amount;
        uint bWager = bets[gamblerB].amount;

        if (aBet == _outcome || bBet == _outcome) {
            if (aBet == bBet) {
                winnings[gamblerA] = aWager;
                winnings[gamblerB] = bWager;
            } else if (aBet == _outcome && bBet != _outcome) {
                winnings[gamblerA] = aWager + bWager;
            } else if (bBet == _outcome && aBet != _outcome) {
                winnings[gamblerB] = aWager + bWager;
            }
        } else {
            winnings[oracle] = aWager + bWager;
        }
        BetClosed();
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
        delete(bets[gamblerA]);
        delete(bets[gamblerB]);
        delete(gamblerA);
        delete(gamblerB);

    }
      /* Fallback function */
    function() public payable {
        revert();
    }
}
