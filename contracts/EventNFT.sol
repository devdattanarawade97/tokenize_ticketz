// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract EventNFT is ERC721, AccessControl {
    //event tokenId
    uint256 private _nextEventId;

    //tokenBurnerLeadger
    //eventId=>eventOwnerAddress=>tokenBurnerAddress
    mapping(uint256 => mapping(address => address)) internal tokenBurnerLeadger;

    //constructor
    constructor() ERC721("TOKENIZEEVENTZ", "TENFT") {}

    //mint event id
    //@dev - validate minted token have address of to
    function mintEventNFT(address _tokenBurnerAddress , address _to)
        public
        returns (uint256 _eventId)
    {
        uint256 nextEventId = _nextEventId++;
        _safeMint(_to, nextEventId);
        // //validate minted token have address of to
        // require(
        //     checkOwnerOfEvent(nextEventId) == _msgSender(),
        //     "minting token failed"
        // );
        //set tokenBurnerAddress
        tokenBurnerLeadger[nextEventId][msg.sender] = _tokenBurnerAddress;
        //return tokenId
        _eventId = nextEventId;
    }

    //transfer event ownership

    function transferEventOwnerShip(
        address from,
        address to,
        uint256 tokenId
    ) public {
        //require only event manager can transfer ownership
        require(
            checkOwnerOfEvent(tokenId) == msg.sender,
            "you are not event owner"
        );
        //safe trasnfer event ownership
        _safeTransfer(from, to, tokenId);
    }

    //changer token burner address

    function changeTokenBurnerAddress(
        uint256 tokenId,
        address _newTokenBurnerAddress
    ) public {
        //require only event manager can transfer ownership
        require(
            checkOwnerOfEvent(tokenId) == msg.sender,
            "you are not event owner"
        );
        //change token burner address for current event
        tokenBurnerLeadger[tokenId][msg.sender] = _newTokenBurnerAddress;
    }

    //owner of eventId

    function checkOwnerOfEvent(uint256 tokenId)
        public
        view
        returns (address tokenOwnerAddress)
    {
        tokenOwnerAddress = _requireOwned(tokenId);
    }

       //total events registered

    function totalEventsRegistered()
        public
        view
        returns (uint256 _totalEvents)
    {
        _totalEvents = _nextEventId;
    }

    //checkTokenRedeemer address

    function checkTokenBurnerAddress(uint256 tokenId)
        public
        view
        returns (address _tokenBurnerAddress)
    {
        //         //require only event manager can transfer ownership
        //  require(checkOwnerOfEvent(tokenId)==msg.sender, "you are not event owner");
        _tokenBurnerAddress = tokenBurnerLeadger[tokenId][msg.sender];
    }

    //token name

    function name()
        public
        view
        virtual
        override
        returns (string memory tokenName)
    {
        tokenName = name();
    }

    //symbol
    function symbol()
        public
        view
        virtual
        override
        returns (string memory symbolName)
    {
        symbolName = symbol();
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


  
}
