//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;
//importing ERC20 from the installed openzeppelin library/module
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
//creating a contract of ERC20
contract EkoxyToken is ERC20Capped , ERC20Burnable{
address payable public owner;
uint256 public blockReward;
uint256 public initialSupply;
string private tokenName = "EkoxyToken";
string private tokenSymbol = "ETC";
 constructor(uint cap,uint256 reward) ERC20(tokenName,tokenSymbol) ERC20Capped(cap*(10**decimals())){
owner = payable(msg.sender);
initialSupply = 40000000 * (10 ** decimals());
_mint(owner,initialSupply);
blockReward = reward * (10**decimals());
 }
function _mint(address account, uint256 amount) internal virtual override(ERC20Capped,ERC20) {
    require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
    super._mint(account, amount);
    }
function _mintMinerReward() internal {
  _mint(block.coinbase,blockReward);
 }
 function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override{
    if (from != address(0) && to != block.coinbase && block.coinbase != address(0)) {
         _mintMinerReward();
    }
    super._beforeTokenTransfer(from,to,amount);
 }
 function setBlockReward(uint256 reward) public onlyOwner{
    blockReward = reward * (10**decimals());
 }
 function destroy() public onlyOwner{
    selfdestruct(owner);
 }
 modifier onlyOwner(){
    require(msg.sender == owner,"Unauthorized access");
    _;
 }
}

