# Cordova Sumup Plugin

Cordova plugin for a native integration with the [SumUp iOS SDK](https://github.com/sumup/sumup-ios-sdk).

## Installation

```
cordova plugin add https://github.com/Shadowstyler/cordova-plugin-sumup-ios --variable SUMUP_API_KEY="YOUR_AFFILIATION_KEY"
```

You can generate your affiliation key in your merchant account on SumUp website in the developer menu.

## Usage

### login

```javascript
cordova.exec(function success() {}, function failure() {}, 'Sumup', 'login');
```

Calling this method will show a modal with a login prompt.
The `success` callback is fired when the user is successfully logged in.
The `failure` callback will be triggered when the user presses the "cancel" button.

### logout

```javascript
cordova.exec(function success() {}, function failure() {}, 'Sumup', 'logout');
```

Calling this method will logout the user. Nothing is shown to the user. It will fail if the user is not logged in yet.

### isLoggedIn

```javascript
cordova.exec(function success(isLoggedIn) {}, null, 'Sumup', 'isLoggedIn');
```

This method will always trigger the `success` callback with a boolean that indicates if the user is logged in to SumUp.

### checkoutPreferences

```javascript
cordova.exec(function success() {}, function failure() {}, 'Sumup', 'checkoutPreferences');
```

This method will show the checkout preferences modal if the user is logged in to SumUp. It will trigger the `failure` callback if the user is not logged in. It will trigger the `success` callback when the user has pressed "done".

### pay

```javascript
cordova.exec(function success(transactionCode) {}, function failure(code) {}, 'Sumup', 'pay', [total, title, foreignTransactionID]);
```

This method opens a modal with a new payment. If the payment is successfully finished, the `success` callback will be triggered with the `transactionCode` of the payment. If the payment fails, because the transaction fails or because the user is not logged in with sumup, it will trigger the `failure` callback. It is required to pass the `total` amount as a decimal string, as well as a string `title` and a string `foreignTransactionID` that can be anything.
