# WHAT DOES THIS DO?

**Records**:
```
    Wallet
    Money
```
**ENUM**:
```
    Currency
```



**Update Queries**:
    - createWallet: does exactly what it's name says. It creates a wallet with a unique ID ranging from 1 to 8. No user is alllowed a number of wallets greater than 8.

    - addMoney: adds money to the wallet. Takes in the wallet Id and the money record.

**Regular Queries**:
    getBalance: takes in the walletId and returns the total amount of money in that wallet.

**filterByXXX**:
    Two functions of this type.
    *Filter by Currency*
   * Filter by Description*

**seeSize**:
    Returns the size of the wallet.
