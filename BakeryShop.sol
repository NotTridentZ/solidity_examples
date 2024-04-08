// SPDX-License-Identifier: MIT

pragma solidity 0.8.25;

contract BakeryShop {
    address public owner;
    uint256 public purchaseID;
    
    struct Bread{
        string breadName;
        uint256 breadQty;
        uint256 breadPrice;
    }

    enum BreadType{
        Bagel,
        Croissant,
        Muffin
    }

    struct PurchaseDetail{
        address customerAddress;
        BreadType breadType;
        uint256 purchaseQty;
        uint256 totalPrice;
    }

    mapping(BreadType => Bread) public breadStock;
    mapping (uint256 => PurchaseDetail) public purchaseReceipt;

    constructor(){
        owner = msg.sender;
        breadStock[BreadType.Bagel] = Bread("Bagel_One", 100, 10 wei);
        breadStock[BreadType.Croissant] = Bread("Croissant_One",100, 20 wei);
        breadStock[BreadType.Muffin] = Bread("Muffin_One",100, 30 wei);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier checkNumber(uint256 quantity){
        require(quantity > 1, "Must be at least 1 bread");
        _;
    }

    function addBreadStock(BreadType _breadType, uint256 _breadQty)public onlyOwner checkNumber(_breadQty){
        breadStock[_breadType].breadQty += _breadQty;
    }

    function purchaseBread(BreadType _breadType, uint256 _breadQty) public payable checkNumber(_breadQty){
        require(breadStock[_breadType].breadQty >= _breadQty, "Insufficient Bread Stock");

        uint totalPriceToPay = _breadQty * breadStock[_breadType].breadPrice;
        require(msg.value >= totalPriceToPay, "Invalid amount to pay");

        purchaseID++;
        breadStock[_breadType].breadQty -= _breadQty;

        purchaseReceipt[purchaseID] = PurchaseDetail(msg.sender, _breadType, _breadQty, totalPriceToPay);
    }

    function withdraw()public onlyOwner{
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success,"Withdraw Balance Failed");
    }

    function viewPurchaseReceipt(uint256 _purchaseID) public view returns(address, BreadType, uint256, uint256){
        return(
            purchaseReceipt[_purchaseID].customerAddress,
            purchaseReceipt[_purchaseID].breadType,
            purchaseReceipt[_purchaseID].purchaseQty,
            purchaseReceipt[_purchaseID].totalPrice
        );
    }
}