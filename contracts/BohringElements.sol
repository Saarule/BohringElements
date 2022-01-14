
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BohringElements is ERC721Enumerable, Ownable {
  using Strings for uint256;
  
  string[] public elementsValues = ["H","He","O","C","Al","Fe","Br","Au","U"];
  
   struct Element { 
      string name;
      string description;
      string bgHue;
      string sunHue;
      string earthHue;
      string textHue;
      string value;
   }
  
  mapping (uint256 => Element) public elements;
  
  constructor() ERC721("Bohring Elements", "BOE") {}

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 100000);
    
    Element memory newElement = Element(
        string(abi.encodePacked('Bohring Elements #', uint256(supply + 1).toString())), 
        "Bohring Elements are on-chain generated NFTs",
        randomNum(361, block.difficulty, supply).toString(),
        randomNum(361, block.difficulty, block.timestamp).toString(),
        randomNum(361, block.timestamp, block.difficulty).toString(),
        randomNum(361, block.timestamp, supply).toString(),
        elementsValues[randomNum(elementsValues.length, block.difficulty, supply)]);
    
    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    }
    
    elements[supply + 1] = newElement;
    _safeMint(msg.sender, supply + 1);
  }

  function randomNum(uint256 _mod, uint256 _seed, uint _salt) public view returns(uint256) {
      uint256 num = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
      return num;
  }
  
  function buildImage(uint256 _tokenId) public view returns(string memory) {
      Element memory currentElement = elements[_tokenId];
      return Base64.encode(bytes(
          abi.encodePacked(
              '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500">',
              '<rect width="50%" height="50%" fill="hsl(',currentElement.bgHue,', 40%, 35%)" />',
              '<g id="n1">',
              '<g>',
              '<animateTransform attributeName="transform" type="rotate" values="360 125 125;0.0 125 125" dur="1s" repeatCount="indefinite" />',
              '<circle class="Earth-orbit" cx="125" cy="125" r="20" fill="none" stroke="hsl(',currentElement.earthHue,', 80%, 15%)" stroke-width="1"/>',
              '<circle class="Earth" cx="105" cy="125" r="2" fill="hsl(',currentElement.earthHue,', 50%, 75%)"/>',
              '</g>',
              '</g>',
              '<circle class="sun" cx="125" cy="125" r="15" />',
              '<text x="125" y="126" alignment-baseline="middle" text-anchor="middle" class="base" fill="white" font-family="helvetica" font-size="16px">H</text>',
              '</svg>'
          )
      ));
    //   return Base64.encode(bytes(
    //       abi.encodePacked(
    //           '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
    //           '<rect height="500" width="500" fill="hsl(',currentElement.bgHue,', 50%, 25%)"/>',
    //           '<text x="50%" y="50%" dominant-baseline="middle" fill="hsl(',currentElement.textHue,', 100%, 80%)" text-anchor="middle" font-size="41">',currentElement.value,'</text>',
    //           '</svg>'
    //       )
    //   ));
      


  }
  
  function buildMetadata(uint256 _tokenId) public view returns(string memory) {
      Element memory currentElement = elements[_tokenId];
      return string(abi.encodePacked(
              'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
                          '{"name":"', 
                          currentElement.name,
                          '", "description":"', 
                          currentElement.description,
                          '", "image": "', 
                          'data:image/svg+xml;base64,', 
                          buildImage(_tokenId),
                          '"}')))));
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
      require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
      return buildMetadata(_tokenId);
  }

  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}



///////////////////////////////////**********************************************///////////////////////////////////

//Base64 Part of the code//
pragma solidity ^0.8.0;

/// @title Base64
/// @author Brecht Devos - <brecht@loopring.org>
/// @notice Provides a function for encoding some bytes in base64
library Base64 {
    string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

    function encode(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return '';
        
        // load the table into memory
        string memory table = TABLE;

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((data.length + 2) / 3);

        // add some extra buffer at the end required for the writing
        string memory result = new string(encodedLen + 32);

        assembly {
            // set the actual output length
            mstore(result, encodedLen)
            
            // prepare the lookup table
            let tablePtr := add(table, 1)
            
            // input ptr
            let dataPtr := data
            let endPtr := add(dataPtr, mload(data))
            
            // result ptr, jump over length
            let resultPtr := add(result, 32)
            
            // run over the input, 3 bytes at a time
            for {} lt(dataPtr, endPtr) {}
            {
               dataPtr := add(dataPtr, 3)
               
               // read 3 bytes
               let input := mload(dataPtr)
               
               // write 4 characters
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
               resultPtr := add(resultPtr, 1)
               mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
               resultPtr := add(resultPtr, 1)
            }
            
            // padding with '='
            switch mod(mload(data), 3)
            case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
            case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
        }
        
        return result;
    }
}