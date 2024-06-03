import List "mo:base/List";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

actor {

  var Id = 0;
  // Type definitions
  type Wallet = {
    id : Int;
    money : List.List<Money>;
  };

  type Money = {
    amount : Nat;
    description : Text;
    currency : Currency;
  };

  type Currency = {
    #EUR;
    #GBP;
    #NGN;
    #USD;
  };

  // Variables
  var wallets = List.nil<Wallet>();

  //This functionis used to create the wallet. The wallet houses the money and the id of the wallet
  public func createWallet() : async Result.Result<Wallet, Text> {
    Id := Id + 1;
    if (Id == 8) {
      return #err "You have reached the maximum number of wallets";
    } else {
      var wallet : Wallet = {
        id = Id;
        money = List.nil<Money>();
      };
      wallets := List.push<Wallet>(wallet, wallets);
      return #ok wallet;
    };

  };

  // Update queries
  //ADDS money to the wallet of choice
  public func addMoney(walletId : Int, amount : Money) : async Result.Result<Text, Text> {
    let wallet = List.find<Wallet>(
      wallets,
      func(wallet) {
        wallet.id == walletId;
      },
    );
    switch (wallet) {
      case (null) { return #err "Wallet not found" };

      case (?wallet) {
        let updatedMoney = List.push<Money>(amount, wallet.money);
        let updatedWallet = {
          id = wallet.id;
          money = updatedMoney;
        };
        wallets := List.map<Wallet, Wallet>(
          wallets,
          func(wallet) {
            if (wallet.id == walletId) {
              updatedWallet;
            } else {
              wallet;
            };
          },
        );
        return #ok "Money added to wallet";
      };
    };

  };

  // Regular queries
  // Get the balance of a specific wallet
  public query func getBalance(walletId : Int) : async Result.Result<Nat, Text> {
    let wallet = List.find<Wallet>(wallets, func(wallet) { wallet.id == walletId });
    switch (wallet) {
      case (null) { return #err "Wallet not found" };

      case (?wallet) {
        let balance = List.foldLeft<Money, Nat>(
          wallet.money,
          0,
          func(base, elem) {
            (base + elem.amount);
          },
        );
        return #ok balance;
      };
    };
  };
  
  // Filter money in a specific wallet by currency
  public query func filterByCurrency(walletId : Int, currency : Currency) : async Result.Result<List.List<Money>, Text> {
    let wallet = List.find<Wallet>(wallets, func(wallet) { wallet.id == walletId });
    switch (wallet) {
      case (null) {
        return #err("Wallet not found");
      };
      case (?wallet) {
        let matches = List.filter<Money>(
          wallet.money,
          func(walletElem) {
            walletElem.currency == currency;
          },
        );
        return #ok(matches);
      };
    };
  };

  // Filter money in a specific wallet by description
  public query func filterByDescription(walletId : Int, description : Text) : async Result.Result<List.List<Money>, Text> {
    let wallet = List.find<Wallet>(wallets, func(wallet) { wallet.id == walletId });
    switch (wallet) {
      case (null) {
        return #err("Wallet not found");
      };
      case (?wallet) {
        let matches = List.filter<Money>(
          wallet.money,
          func(walletElem) {
            walletElem.description == description;
          },
        );
        return #ok(matches);
      };
    };
  };

  // Get the size of a specific wallet
  public query func seeSize(walletId : Int) : async Result.Result<Nat, Text> {
    let wallet = List.find<Wallet>(wallets, func(wallet) { wallet.id == walletId });
    switch (wallet) {
      case (null) {
        return #err("Wallet not found");
      };
      case (?wallet) {
        let size = List.size<Money>(wallet.money);
        return #ok(size);
      };
    };
  };
};
