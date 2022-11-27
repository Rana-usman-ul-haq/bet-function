// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Casino is Ownable {
      using SafeMath for uint256;

    IERC20 public immutable token1;

    uint256 price;
    uint256 amountOut;
    uint256 amountIn;
    address fundAddress;

    
    constructor(address _token1) {
     token1 = IERC20(_token1);
     fundAddress = msg.sender ;

    }

    function setFundAddress(address _fundAddress) external onlyOwner {
        fundAddress = _fundAddress;
    }

    function placeBet (uint256 _amountIn) external {
        require (
            _amountIn > 1, "amount must be greater than 1"
         );    
        token1.transferFrom(msg.sender, address(this), _amountIn * 1e18);
        // 13% fee
        uint256 percentageFee = token1.balanceOf(address(this)) * 13/100 ;

        token1.transfer(fundAddress, percentageFee ); 
         amountIn = token1.balanceOf(address(this));
        
    }
    function checkAmount() external view returns (uint256) {
        return amountIn;
    }

    function claimEarnings() external {
     require (
         token1.balanceOf(address(this)) > 1, "Balance too low to withdraw" 
         );
         token1.transfer(msg.sender, amountIn); 
    }
}
