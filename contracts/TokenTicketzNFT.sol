// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract TokenTicketzNFT is ERC721, ERC721Burnable, AccessControl {
    //tokenBurnerLeadger
    //eventId=>tokeBurnerAddress
    mapping(uint256 => address) tokenBurnerLeadger;

    uint256 private _nextTokenId;

    //constructor
    constructor() ERC721("TOKENIZETICKETZ", "TTZ") {}

    //safe mint
    //@dev - validate minted token have address of to
    function safeMint(address to) public returns (uint256 _tokenId) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        //validate minted token have address of to
        require(checkOwnerOfToken(tokenId) == to, "minting token failed");
        _tokenId = tokenId;
    }

    //burn token

    function burnToken(uint256 tokenId) public {
        //burn token id
        _burn(tokenId);
    }

    //transfer token

    function transferToken(
        address from,
        address to,
        uint256 tokenId
    ) public {
        _safeTransfer(from, to, tokenId);
    }

         //total tickets registered

    function totalTicektsRegistered()
        public
        view
        returns (uint256 _totalTicekts)
    {
        _totalTicekts = _nextTokenId;
    }

    //owner of tokenId

    function checkOwnerOfToken(uint256 tokenId)
        public
        view
        returns (address tokenOwnerAddress)
    {
        tokenOwnerAddress = _requireOwned(tokenId);
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
