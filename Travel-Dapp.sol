pragma solidity ^0.4.23;

contract Travel {
    
    address public owner;
    uint16 public hostingCount;
    uint conversion = 10**18;
    constructor() public {                                                                                                                                                                                                                                                              
        owner = msg.sender;
        hostingCount = 0;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    struct user{
        string userName;
        uint phone;
        string mail;
        string password;
        bool afir;
    }

    mapping (address => user) dataUser;

    function registerUser(string _name, uint _phone, string _mail, string _password) external {
        dataUser[msg.sender].userName = _name;
        dataUser[msg.sender].phone = _phone;
        dataUser[msg.sender].mail = _mail;
        dataUser[msg.sender].password = _password;
        dataUser[msg.sender].afir = true;
    }
    
    struct Host{
        string hostName;
        uint phone;
        string mail;
        string password;
        bool afir;
    }    

    mapping (address => Host) dataHost ;

    function registerHost (string _name, uint _phone, string _mail, string _password) external {
        dataHost[msg.sender].hostName = _name;
        dataHost[msg.sender].phone = _phone;
        dataHost[msg.sender].mail = _mail;
        dataHost[msg.sender].password = _password;
        dataHost[msg.sender].afir = true;
    }
    
    // About Host
    
    modifier onlyHost {
       require(dataHost[msg.sender].afir == true);
       _;
    }
    
    struct hosting {
        string name;
        address hostman;
        address user;
        bool available;
        uint cost;
    }
    
    mapping (uint16 => hosting) dataHosting;
    
    function AddHosting(string _name, uint _cost) external onlyHost {
        dataHosting[hostingCount].hostman = msg.sender;
        dataHosting[hostingCount].available = true;
        dataHosting[hostingCount].cost = _cost;
        dataHosting[hostingCount].name = _name;
        hostingCount++;
    }
    
    function EliminateHosting(uint16 _hostingId) external onlyHost {
        require(dataHosting[_hostingId].hostman == msg.sender);
        dataHosting[_hostingId].available = false;
    }
    
    /*
    function ShowMeMyHostings() external view onlyHost {
        uint16 aux = 0;
        uint16[] myhostings;
        for (uint16 i=0; i<hostingCount; i++){
            if(dataHosting[i].host == msg.sender) {
                myhostings[aux] = i;
                aux++;
            }
        }
    }
    */
    
    // About User
    
    modifier onlyUser {
        require(dataUser[msg.sender].afir == true);
        _;
    }
    
    function payHosting(uint16 _hostingId) external onlyOwner {
        dataHosting[_hostingId].hostman.transfer(dataHosting[_hostingId].cost);
        owner.transfer(dataHosting[_hostingId].cost*2/100);
    }
    
    function reserveHosting(uint16 _hostingId) external payable onlyUser {
        require(dataHosting[_hostingId].available == true);
        require(msg.value == dataHosting[_hostingId].cost*102/100 ether);
        dataHosting[_hostingId].user = msg.sender;
        dataHosting[_hostingId].available = false;
    }
    
    function CancelHosting(uint16 _hostingId) external onlyUser {
        require(dataHosting[_hostingId].user == msg.sender);
        dataHosting[_hostingId].user = owner;
        dataHosting[_hostingId].available = true;
    }
}





