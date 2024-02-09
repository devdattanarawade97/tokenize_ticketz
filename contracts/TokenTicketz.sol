// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./TokenTicketzNFT.sol";
import "./EventNFT.sol";

contract TokenTicketz {
    // contract balance;
    uint256 private contractBalance;
    //token address
    //@dev - visibility must be private
    address public ticketTokenAddress;

    //event token address
    address public eventTokenAddress;
    // //event id
    // uint256 private eventId;

    //struct for event details
    struct eventDetails {
        uint256 eventId;
        string eventName;
        uint256 eventPrice;
        string venueDetails;
        uint256 eventStartTimestamp;
        uint256 eventEndTimestamp;
        uint256 saleStartTimestamp;
        uint256 saleEndTimestamp;
        bool isEventExpired;
        bool isSaleExpired;
        bool isSaleLive;
        address tokenRedeemerAddress;
    }

    //struct ticket details

    struct ticketDetails {
        uint256 tokenId;
        uint256 eventId;
        string eventName;
        uint256 eventPrice;
        string venueDetails;
        uint256 eventStartTimestamp;
        uint256 eventEndTimestamp;
        bool isEventExpired;
        bool isBurned;
        address ticketOwnerAddress;
    }

    //eventDetailsLeadger

    mapping(address => mapping(uint256 => eventDetails))
        private eventDetailsLeadger;

    //allEvents

    mapping(uint256 => eventDetails) private allEventsById;

    //events id leadger
    //address eventManager address=>uint256[] allEventIds
    mapping(address => uint256[]) private eventsIdLeadger;

    //allTickets

    mapping(uint256 => ticketDetails) private allTicketsById;

    //ticektid leadger
    //address eventManager address=>uint256[] allticketIds
    mapping(address => uint256[]) private ticketIdLeadger;
     
     //event managers mapping
     mapping (address=>bool) eventManagersLeadger;
    //constructor

    constructor(address _ticketTokenAddress, address _eventTokenAddress) {
        ticketTokenAddress = _ticketTokenAddress;
        eventTokenAddress = _eventTokenAddress;
    }

    //buy ticketNFT for users
    //@dev - to!=address(0)
    function mintTicketNFT(uint256 _eventId) public payable {
        //ensure sale is live
        require(checkForIsSaleExpired(_eventId) == false, "sale is expired");

        //grab event from eventId
        eventDetails memory checkEvent = allEventsById[_eventId];
        //get event price
        uint256 _eventPrice = checkEvent.eventPrice;

        //1 . evaluate gas cost
        uint256 gasCost = gasleft() * tx.gasprice;

        //2 . calculate total transaction cost

        uint256 totalTransactionCost = _eventPrice + gasCost;
        //ensure user balance>=totalTransactionCost
        require(
            msg.sender.balance >= totalTransactionCost,
            "insufficent balance"
        );
        //require to address !=address(0)
        require(msg.sender != address(0), "invalid address");
        // validate msg.value==eventPrice
        require(msg.value == _eventPrice, "invalid amount");
        //deposit event price to contract address
        contractBalance = contractBalance + msg.value;
        //mint ticketNFT to user
        uint256 _tokenId = TokenTicketzNFT(ticketTokenAddress).safeMint(
            msg.sender
        );

        //generate ticket
        ticketDetails memory ticket = ticketDetails(
            _tokenId,
            _eventId,
            checkEvent.eventName,
            checkEvent.eventPrice,
            checkEvent.venueDetails,
            checkEvent.eventStartTimestamp,
            checkEvent.eventEndTimestamp,
            false , 
            false, 
            msg.sender
        );
        //update allTicektsById
        allTicketsById[_tokenId] = ticket;
        //update ticke details leadger
        uint256[] storage ticketIds = ticketIdLeadger[msg.sender];
        ticketIds.push(_tokenId);
    }

    //redeem nft
    //@dev - validate token burner address before burning token of him

    function redeemTicketNFT(
        uint256 _tokenId,
        address _tokenOwnerAddress,
        uint256 _eventId
    ) public {
         
         //grab ticket

              ticketDetails memory ticket =allTicketsById[_tokenId];
         //ensure ticket is not burned
         require(ticket.isBurned==false, "ticket burned already");
        //ensure event is not expired
        require(checkForIsEventExpiredForRedeemer(_eventId) == false, "event is expired");
        //
        //require token burner address from event nft == msg.sender
        address getTokenBurnerAddress = EventNFT(eventTokenAddress)
            .checkTokenBurnerAddress(_tokenId);

        require(
            getTokenBurnerAddress == msg.sender,
            "Unauthorized token burner"
        );
        //require token owner address from  nft == tokenOwnerAddress
        require(
            TokenTicketzNFT(ticketTokenAddress).checkOwnerOfToken(_tokenId) ==
                _tokenOwnerAddress,
            "Invalid address or token id doesnot exist"
        );
        // get event manager address
        address payable managerAddress = payable(
            EventNFT(eventTokenAddress).checkOwnerOfEvent(_eventId)
        );

        //grab event from eventId
        eventDetails memory checkEvent = allEventsById[_eventId];
        //get event price
        uint256 _eventPrice = checkEvent.eventPrice;
        //update event in all events leadger
        allEventsById[_eventId] = checkEvent;

        //update allEvents leadger

        //transfer event price to manager address
        managerAddress.transfer(_eventPrice);
        //burn token
        TokenTicketzNFT(ticketTokenAddress).burnToken(_tokenId);
        //update ticke burned status

        ticket.isBurned=true;
        //update ticket in all ticket by id 
        allTicketsById[_tokenId]=ticket;
    }

    //gift token
    //@dev validate owner of token id should be sender address

    function giftToken(
        uint256 _tokenId,
        uint256 _eventId,
        address _to
    ) public {
            //grab ticket

              ticketDetails memory ticket =allTicketsById[_tokenId];
         //ensure ticket is not burned
         require(ticket.isBurned==false, "ticket burned already");
        //ensure redeemtion is live
        require(checkForIsSaleExpired(_eventId) == false, "event is expired");
        //require token owner ==msg.sender
        require(
            TokenTicketzNFT(ticketTokenAddress).checkOwnerOfToken(_tokenId) ==
                msg.sender,
            "Invalid address or token doesnot exist"
        );
        //transfer token ownership
        TokenTicketzNFT(ticketTokenAddress).transferToken(msg.sender, _to, _tokenId);
    }

    //checkTotalTicektsSold

    function checkTotalTicektsSold()
        external
        view
        returns (uint256 tokenBalance)
    {
        tokenBalance = TokenTicketzNFT(ticketTokenAddress)
            .totalTicektsRegistered();
    }

    //checkTotalEventsRegistered
    function checkTotalEventsRegistered()
        external
        view
        returns (uint256 tokenBalance)
    {
        tokenBalance = EventNFT(eventTokenAddress).totalEventsRegistered();
    }

    //create event for user
    //input -
    /*
     uint256 eventId;
        string eventName;
        uint256 eventPrice;
        string venueDetails;
        uint256 eventStartTimeStamp;
        uint256 eventEndTimeStamp;
        uint256 saleStartTimestamp;
        uint256 saleEndTimestamp;
        bool isEventExpired;
        bool isSaleExpired;
           address tokenRedeemerAddress;
     */

    function createEventForUser(
        string memory _eventName,
        uint256 _eventPrice,
        string memory _venueDetails,
        uint256 _eventStartTime,
        uint256 _eventEndTime,
        uint256 _saleStartTimestamp,
        uint256 saleEndTimestamp,
        address _TokenRedeemerAddress
    ) public {
        //@dev ensure bytes32(_eventName).length!=0
        //@dev ensure bytes32(_venuDetails).length!=0

        // require(bytes(_eventName).length != 0, "invalid eventName");
        // require(bytes(_venueDetails).length != 0, "invalid eventName");

        //mint new event nft
        //set redeemerAddress
        //and returns __newEventId
        uint256 newEventId = EventNFT(eventTokenAddress).mintEventNFT(
            _TokenRedeemerAddress,
            msg.sender
        );

        //event price in ether
        // uint256 eventPriceInEther=_eventPrice*10**18;
        //@dev create new event
        eventDetails memory newEvent = eventDetails(
            newEventId,
            _eventName,
            _eventPrice * 10**18,
            _venueDetails,
            _eventStartTime,
            _eventEndTime,
            _saleStartTimestamp,
            saleEndTimestamp,
            false,
            false,
            false,
            _TokenRedeemerAddress
        );

        //@dev store event in eventDetailsLeadger

        eventDetailsLeadger[msg.sender][newEventId] = newEvent;

        //@dev store event in all events leadger
        allEventsById[newEventId] = newEvent;
        //@dev store events in events id leadger
        uint256[] storage eventsId = eventsIdLeadger[msg.sender];
        eventsId.push(newEventId);

        //update events id leadger
        eventsIdLeadger[msg.sender] = eventsId;

        //mark user as event manager 
        eventManagersLeadger[msg.sender]=true;
    }

    //check for whether sale is live or not

    function checkForIsSaleExpired(uint256 _eventId)
        public
        returns (bool _isSaleExpired)
    {
        // eventDetails memory checkForEvent = eventDetailsLeadger[msg.sender][
        //     _eventId
        // ];
         
             eventDetails memory checkForEvent = allEventsById[_eventId];
        if ((block.timestamp * 1000) < checkForEvent.saleEndTimestamp) {
            _isSaleExpired = false;
        } else {
            //mark sale is expired for current event id
            checkForEvent.isSaleExpired = true;
            //update current event in eventDetailsLeadger
            eventDetailsLeadger[msg.sender][_eventId] = checkForEvent;
            //update current event in allEventsById
            allEventsById[_eventId] = checkForEvent;

            _isSaleExpired = true;
        }
    }

    // //check is event Expired for manager

    function checkForIsEventExpired(uint256 _eventId)
        public
        returns (bool _isEventExpired)
    {
        //grab event for event id
        eventDetails memory checkForEvent = eventDetailsLeadger[msg.sender][
            _eventId
        ];
        

        if ((block.timestamp * 1000) < checkForEvent.eventEndTimestamp) {
            _isEventExpired = false;
        } else {
            //mark sale is expired for current event id
            checkForEvent.isEventExpired = true;
            //update current event in eventDetailsLeadger
            eventDetailsLeadger[msg.sender][_eventId] = checkForEvent;
            //update current event in allEventsById
            allEventsById[_eventId] = checkForEvent;

            _isEventExpired = true;
        }
    }

    // //check is sale is live

    function checkForIsSaleLive(uint256 _eventId)
        public
        returns (bool _isSaleLive)
    {
        // eventDetails memory checkForEvent = eventDetailsLeadger[msg.sender][
        //     _eventId
        // ];

       eventDetails memory checkForEvent = allEventsById[
            _eventId
        ];

        if (
            (block.timestamp * 1000) < checkForEvent.saleStartTimestamp ||
            (block.timestamp * 1000) > checkForEvent.saleEndTimestamp
        ) {
            checkForEvent.isSaleLive = false;
            //update current event in eventDetailsLeadger
            eventDetailsLeadger[msg.sender][_eventId] = checkForEvent;
            //update current event in allEventsById
            allEventsById[_eventId] = checkForEvent;

            _isSaleLive = false;
        } else if (
            (block.timestamp * 1000) > checkForEvent.saleStartTimestamp &&
            (block.timestamp * 1000) < checkForEvent.saleEndTimestamp
        ) {
            //mark sale is expired for current event id
            checkForEvent.isSaleLive = true;
            //update current event in eventDetailsLeadger
            eventDetailsLeadger[msg.sender][_eventId] = checkForEvent;
            //update current event in allEventsById
            allEventsById[_eventId] = checkForEvent;

            _isSaleLive = true;
        }
    }

    //refresh events

    function refreshEvents() public {
        uint256[] memory _allEvents = eventsIdLeadger[msg.sender];

        //update events
        for (uint256 i = 0; i < _allEvents.length; i++) {
            uint256 _eventId = _allEvents[i];
            checkForIsEventExpired(_eventId);
            checkForIsSaleExpired(_eventId);
            checkForIsSaleLive(_eventId);
        }
    }

    //get all events for event manager

    function getAllEvents() external view returns (eventDetails[] memory) {
        uint256[] memory _allEvents = eventsIdLeadger[msg.sender];

        //make empty eventDetails array
        eventDetails[] memory updatedEvents = new eventDetails[](
            _allEvents.length
        );
        for (uint256 i = 0; i < _allEvents.length; i++) {
            uint256 _eventId = _allEvents[i];

            eventDetails memory updatedEvent = allEventsById[_eventId];
            //push updated event in  updated events
            updatedEvents[i] = updatedEvent;
        }

        //return updated event
        return updatedEvents;
    }

    //get all tickets

    function getAllTickets() external view returns (ticketDetails[] memory) {
        //@dev returns all tickets for user
        uint256[] memory allTicketsId = ticketIdLeadger[msg.sender];

        //create temp ticketsDetails array
        ticketDetails[] memory _allTickets = new ticketDetails[](
            allTicketsId.length
        );

        //iterate over all itckets ids
        for (uint256 i = 0; i < allTicketsId.length; i++) {
            //get each ticket id
            uint256 _ticketId = allTicketsId[i];
            //get ticketDetails for each ticket id
            ticketDetails memory updatedTickets = allTicketsById[_ticketId];
            //push  ticket in  temp arr
            _allTickets[i] = updatedTickets;
        }

        //return updated tickets
        return _allTickets;
    }

    //refresh tickets

    function refreshTickets() public {
        uint256[] memory _allEvents = eventsIdLeadger[msg.sender];

        //update events
        for (uint256 i = 0; i < _allEvents.length; i++) {
            uint256 _eventId = _allEvents[i];
            checkForIsEventExpired(_eventId);
        }
    }

    //function checkTicketById

    function checkTicketById(uint256 _ticketId)
        external
        view
        returns (ticketDetails memory _ticket)
    {
        _ticket = allTicketsById[_ticketId];
    }

    //function checkEventById

    function checkEventById(uint256 _eventId)
        external
        view
        returns (eventDetails memory _event)
    {
        _event = allEventsById[_eventId];
    }


        // //check is event Expired for redeemer

    function checkForIsEventExpiredForRedeemer(uint256 _eventId)
        public view 
        returns (bool )
    {
        //grab event for event id
  

        eventDetails memory checkForEvent=allEventsById[_eventId];
  

        if ((block.timestamp * 1000) < checkForEvent.eventEndTimestamp) {
            return false;
        } else {
     

             return true;
        }
    }


    //function check where user is event manager or not 

    function checkIsUserEventManager() public view returns(bool _isEventManager){

        _isEventManager=eventManagersLeadger[msg.sender];
    }
    
}
