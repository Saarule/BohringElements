
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";

contract BohringElements is ERC721Enumerable, Ownable {
  using Strings for uint256;
  
  string[] public elementsValues = ["H", "He", "O", "C", "Ne", "Fe", "N", "Si", "Mg", "Mg", "S", "Ar", "Ca", "Ni", "Al", "Na", "Cr", "Mn", "P", "Co", "Ti", "K", "V", "Cl", "F", "Zn", "Ge", "Cu", "Zr", "Sr", "Kr", "Se", "Sc", "Pb", "Ce", "Ba", "Xe", "Rb", "Ga", "As", "Br", "Li", "Pt", "Sn", "Ir", "Cd", "Pd", "Hg", "I", "B", "Be", "Cs", "Bi", "Au", "Ag", "Rh", "Tl", "W", "In", "U" ];

  mapping (string => uint256[]) public elementsDetails;
  uint256 price = 0.005 ether;

  struct Element { 
      string name;
      string description;
      string num1;
      string num2;
      string num3;
      string num4;
      string symbol;
   }
  mapping (uint256 => Element) public elements;
  
  constructor() ERC721("Bohring Elements", "BOE") {
    elementsDetails["H"] = [1];
    elementsDetails["H"] = [2];
    elementsDetails["O"] = [2, 6];
    elementsDetails["C"] = [2, 4];
    elementsDetails["Ne"] = [2, 8];
    elementsDetails["Fe"] = [2, 8, 14, 2];
    elementsDetails["N"] = [2, 5];
    elementsDetails["Si"] = [2, 8, 4];
    elementsDetails["Mg"] = [2, 8, 2];
    elementsDetails["S"] = [2, 8, 6];
    elementsDetails["Ar"] = [2, 8, 8];
    elementsDetails["Ca"] = [2, 8, 8, 2];
    elementsDetails["Ni"] = [2, 8, 16, 2];
    elementsDetails["Al"] = [2, 8, 3];
    elementsDetails["Na"] = [2, 8, 1];
    elementsDetails["Cr"] = [2, 8, 13, 1];
    elementsDetails["Mn"] = [2, 8, 13, 2];
    elementsDetails["P"] = [2, 8, 5];
    elementsDetails["Co"] = [2, 8, 15, 2];
    elementsDetails["Ti"] = [2, 8, 10, 2];
    elementsDetails["K"] = [2, 8, 8, 1];
    elementsDetails["V"] = [2, 8, 11, 2];
    elementsDetails["Cl"] = [2, 8, 7];
    elementsDetails["F"] = [2, 7];
    elementsDetails["Zn"] = [2, 8, 18, 2];
    elementsDetails["Ge"] = [2, 8, 18, 4];
    elementsDetails["Cu"] = [2, 8, 18, 1];
    elementsDetails["Zr"] = [2, 8, 18, 10, 2];
    elementsDetails["Sr"] = [2, 8, 18, 8, 2];
    elementsDetails["Kr"] = [2, 8, 18, 8];
    elementsDetails["Se"] = [2, 8, 18, 6];
    elementsDetails["Sc"] = [2, 8, 9, 2];
    elementsDetails["Pb"] = [2, 8, 18, 32, 18, 4];
    elementsDetails["Ce"] = [2, 8, 18, 19, 9, 2];
    elementsDetails["Ba"] = [2, 8, 18, 18, 8, 2];
    elementsDetails["Xe"] = [2, 8, 18, 18, 8];
    elementsDetails["Rb"] = [2, 8, 18, 8, 1];
    elementsDetails["Ga"] = [2, 8, 18, 3];
    elementsDetails["As"] = [2, 8, 18, 5];
    elementsDetails["Br"] = [2, 8, 18, 7];
    elementsDetails["Li"] = [2, 1];
    elementsDetails["Pt"] = [2, 8, 18, 32, 17, 1];
    elementsDetails["Sn"] = [2, 8, 18, 18, 4];
    elementsDetails["Ir"] = [2, 8, 18, 32, 15, 2];
    elementsDetails["Cd"] = [2, 8, 18, 18, 2];
    elementsDetails["Pd"] = [2, 8, 18, 18];
    elementsDetails["Hg"] = [2, 8, 18, 32, 18, 2];
    elementsDetails["I"] = [2, 8, 18, 18, 7];
    elementsDetails["B"] = [2, 3];
    elementsDetails["Be"] = [2, 2];
    elementsDetails["Cs"] = [2, 8, 18, 18, 8, 1];
    elementsDetails["Bi"] = [2, 8, 18, 32, 18, 5];
    elementsDetails["Au"] = [2, 8, 18, 32, 18, 1];
    elementsDetails["Ag"] = [2, 8, 18, 18, 1];
    elementsDetails["Rh"] = [2, 8, 18, 16, 1];
    elementsDetails["Tl"] = [2, 8, 18, 32, 18, 3];
    elementsDetails["W"] = [2, 8, 18, 32, 12, 2];
    elementsDetails["In"] = [2, 8, 18, 18, 3];
    elementsDetails["U"] = [2, 8, 18, 32, 21, 9, 2];
  }

  // public
  function mint() public payable {
    uint256 supply = totalSupply();
    // require(supply + 1 <= 10000000); Without this line, there is an infinite number of possible mints.

    Element memory newElement = Element(
    string(abi.encodePacked('Bohring Elements #', uint256(supply + 1).toString())), 
    "Bohring Elements are on-chain generated NFTs",
    randomNum(361, block.difficulty, supply).toString(),
    randomNum(361, block.difficulty, block.timestamp).toString(),
    randomNum(361, block.timestamp, block.difficulty).toString(),
    randomNum(361, block.timestamp, block.difficulty+5).toString(),
    elementsValues[randomNum(elementsValues.length, block.difficulty+9, block.timestamp)]);
  
    if (msg.sender != owner()) {
      require(msg.value >= price);
    }
    
    elements[supply + 1] = newElement;
    _safeMint(msg.sender, supply + 1);
    //This make the price increase by 1% each time
    price = (price * 101) / 100;
  }

  function randomNum(uint256 _mod, uint256 _seed, uint256 _salt) public view returns(uint256) {
      uint256 num = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
      return num;
  }

  function electronShell(uint256 electrons, uint256 radius, uint256 x, uint256 y) public pure returns (string memory) {
    string memory shell = "";
    uint i = 1;
    uint current = 360;
    uint split = 360/electrons;
    uint speed = 6;
    while (i <= electrons) {
      if (i == 1) {
        shell = string(abi.encodePacked(shell, "<g><animateTransform attributeName='transform' type='rotate' values='"));
        shell = string(abi.encodePacked(shell, current.toString(), " ", x.toString(), " ", y.toString()));
        shell = string(abi.encodePacked(shell, ";", " ", (current-split).toString(), " ", x.toString(), " ", y.toString(), "'"));
        shell = string(abi.encodePacked(shell, " ", "dur='", speed.toString(), "s' repeatCount='indefinite' /> <circle class='Earth-orbit' cx='"));
        shell = string(abi.encodePacked(shell, x.toString(), "' cy='", y.toString(), "' r='", (20+(radius*5)).toString(), "'/> <circle class='Earth' cx='"));
        shell = string(abi.encodePacked(shell, ((x-20)-(radius*5)).toString(), "' cy='", y.toString(), "' r='2' /></g>")); 
      } else {
        shell = string(abi.encodePacked(shell, "<g><animateTransform attributeName='transform' type='rotate' values='"));
        shell = string(abi.encodePacked(shell, current.toString(), " ", x.toString(), " ", y.toString()));
        shell = string(abi.encodePacked(shell, ";", " ", (current-split).toString(), " ", x.toString(), " ", y.toString(), "'"));
        shell = string(abi.encodePacked(shell, " ", "dur='", speed.toString(), "s' repeatCount='indefinite' /> <circle stroke='none' fill='none' cx='"));
        shell = string(abi.encodePacked(shell, x.toString(), "' cy='", y.toString(), "' r='", (20+(radius*5)).toString(), "'/> <circle class='Earth' cx='"));
        shell = string(abi.encodePacked(shell, ((x-20)-(radius*5)).toString(), "' cy='", y.toString(), "' r='2' /></g>")); 
      }
      current = current-split;
      i = i + 1;
    }
    return shell;  
  }

  function BohrModel(string memory symbol, uint256 _tokenId, uint256 x, uint256 y) public view returns (string memory) {


    Element memory newElement = elements[_tokenId];
    // console.log(string(abi.encodePacked("Random number 1: ", newElement.num1)));
    // console.log(string(abi.encodePacked("Random number 2: ", newElement.num2)));
    // console.log(string(abi.encodePacked("Random number 3: ", newElement.num3)));
    // console.log(string(abi.encodePacked("Random number 4: ", newElement.num4)));

    string memory text = "";
    text = string(abi.encodePacked(text, "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 500 500'><style>.base { fill: hsl(",newElement.num1,", 50%, 50%); font-family: serif; font-size: 16px; } .sun { fill: hsl(",newElement.num2,", 50%, 50%); opacity: 0.4; } .Earth-orbit { fill: none; stroke: hsl(",newElement.num3,", 50%, 50%); stroke-width: 1; opacity: 0.6;} .Earth { fill: hsl(",newElement.num4,", 50%, 50%); }</style><rect width='100%' height='100%' fill='black' />"));
    // string memory text = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 500 500'><style>.base { fill: white; font-family: serif; font-size: 16px; } .sun { fill: rgb(83,175,255); opacity: 0.4; } .Earth-orbit { fill: none; stroke: rgb(83,175,255); stroke-width: 1; opacity: 0.6;} .Earth { fill: rgb(83,175,255); }</style><rect width='100%' height='100%' fill='black' />";
    // string memory text = string(abi.encodePacked('<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 500 500"><style>.base { fill: white; font-family: serif; font-size: 16px; } .sun { fill: hsl(50, 50%, 75%); opacity: 0.4; } .Earth-orbit { fill: none; stroke: rgb(83,175,255); stroke-width: 1; opacity: 0.6;} .Earth { fill: hsl(70, 50%, 75%); }</style><rect width="100%" height="100%" fill: hsl(60, 50%, 75%) />'));
    uint256 i = 0;
    uint[] memory arr = elementsDetails[symbol];
    while (i < arr.length) {
      text = string(abi.encodePacked(text, "<g id='n", (i+1).toString(), "'>"));
      text = string(abi.encodePacked(text, electronShell(arr[i], i, x, y)));
      text = string(abi.encodePacked(text, "</g>"));
      i = i + 1;
    }
    text = string(abi.encodePacked(text, "<circle class='sun' cx='", x.toString(), "' cy='", y.toString()));
    text = string(abi.encodePacked(text, "' r='15'/> <text x='", x.toString(), "' y='", (y+2).toString()));
    text = string(abi.encodePacked(text, "' alignment-baseline='middle' text-anchor='middle' class='base'>", symbol, "</text>"));
    return string(abi.encodePacked(text, "</svg>"));
  }
  
  function buildMetadata(uint256 _tokenId, string memory symbol) public view returns(string memory) {
      return string(abi.encodePacked(
              'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
                          '{"name":"', 
                          string(abi.encodePacked('Bohring Elements #', _tokenId.toString())),
                          '", "description":"',  
                          "Bohring Elements are on-chain generated NFTs",
                          '", "image": "', 
                          'data:image/svg+xml;base64,', 
                          Base64.encode(bytes(BohrModel(symbol, _tokenId, 250, 250))),
                          '", "attributes": [{"trait_type": "Symbol", "value":"',symbol,'"},',
                          // '{"trait_type": "Color Values", "value":"',elements[_tokenId].num1 ,elements[_tokenId].num2,'"}',
                          ']',
                          '"}')))));
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    Element memory newElement = elements[_tokenId];
    require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
    return buildMetadata(_tokenId, newElement.symbol);
  }

  function withdraw() public payable onlyOwner {
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
  }
}