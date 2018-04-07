contract Crowdfunding {
    address owner;
    uint256 deadline;
    uint256 goal;
    mapping(address => uint256) public pledgeOf;

    function Crowdfunding(uint256 numberOfDays, uint256 _goal) public {
        owner = msg.sender;
        deadline = now + (numberOfDays * 1 days);
        goal = _goal;
    }

    // add withdrawl and claimFunds later.


    //  During the fundraising period, the contract will accept pledges, but it will not allow withdrawals
    function pledge(uint256 amount) public payable {
        require(now < deadline);                // in the fundraising period
        require(msg.value == amount);
        pledgeOf[msg.sender] += amount;
    }

    // This function is for owner, i.e after the deadlines requried amount is gathered.
    function claimFunds() public {
        require(address(this).balance >= goal); // funding goal met
        require(now >= deadline);               // in the withdrawal period
        require(msg.sender == owner);

        msg.sender.transfer(address(this).balance);
    }

    // This function is for funders, i.e after the deadlines requried amount is not gathered so they can claim their money back.
    function getRefund() public {
        require(address(this).balance < goal);  // funding goal not met
        require(now >= deadline);               // in the withdrawal period
        uint256 amount = pledgeOf[msg.sender];
        pledgeOf[msg.sender] = 0;
        msg.sender.transfer(amount);
}

}