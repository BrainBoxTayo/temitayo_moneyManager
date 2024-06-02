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

  // Get the balance in the user's wallet
  public query func getBalance() : async Nat {
    let balance = List.foldLeft<Money, Nat>(
      wallet,
      0,
      func(acc, elem) {
        acc + elem.amount;
      },
    );
    return balance;
  };

  // Get a list of money by property
  public query func filterByCurrency(currency : Currency) : async List.List<Money> {
    let matches = List.filter<Money>(
      wallet,
      func(walletElem) {
        if (walletElem.currency == currency) { return true } else {
          return false;
        };
      },
    );
    return matches;
  };

  public query func filterByDescription(property : Text) : async List.List<Money> {
    let matches = List.filter<Money>(
      wallet,
      func(walletElem) {
        if (walletElem.description == property) { return true } else {
          return false;
        };
      },
    );
    return matches;
  };

  public query func seeSize() : async Nat {
    let size = List.size<Money>(wallet);
    return size;
  };
};
