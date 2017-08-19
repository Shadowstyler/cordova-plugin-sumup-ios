#import "CDVSumup.h"
#import <SumupSDK/SumupSDK.h>

@implementation CDVSumup

-(void) login:(CDVInvokedUrlCommand *)command {
    [[NSBundle mainBundle] infoDictionary];
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* apikey = [infoDict objectForKey:@"SUMUP_API_KEY"];

    [SumupSDK setupWithAPIKey:apikey];
    [SumupSDK presentLoginFromViewController:self.viewController
        animated:YES
        completionBlock:^(BOOL success, NSError *error) {

        CDVPluginResult* pluginResult = nil;
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        }
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

-(void) logout:(CDVInvokedUrlCommand *)command {
  [SumupSDK logoutWithCompletionBlock:^(BOOL success, NSError *error) {
      CDVPluginResult* pluginResult = nil;
      if (success) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      } else {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

-(void) checkoutPreferences:(CDVInvokedUrlCommand *)command {
  [SumupSDK presentCheckoutPreferencesFromViewController:self.viewController
      animated:YES
      completion:^(BOOL success, NSError *_Nullable error) {

      CDVPluginResult* pluginResult = nil;
      if (success) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
      } else {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      }
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
  }];
}

-(void) isLoggedIn:(CDVInvokedUrlCommand *)command {
  BOOL isLoggedIn = [SumupSDK isLoggedIn];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isLoggedIn];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) pay:(CDVInvokedUrlCommand *)command {
    NSString* total = [command.arguments objectAtIndex:0];
    NSString* title = [command.arguments objectAtIndex:1];
    NSString* foreignTransactionID = [command.arguments objectAtIndex:2];

    CDVPluginResult* pluginResult = nil;
    SMPCheckoutRequest *request = [SMPCheckoutRequest requestWithTotal:[NSDecimalNumber decimalNumberWithString:total] title:title
        currencyCode:[[SumupSDK currentMerchant] currencyCode]
        paymentOptions:SMPPaymentOptionAny];

    [request setSkipScreenOptions:SMPSkipScreenOptionSuccess];
    [request setForeignTransactionID:[NSString stringWithFormat:foreignTransactionID]];

    [SumupSDK checkoutWithRequest:request fromViewController:self.viewController completion:^(SMPCheckoutResult *result, NSError *error) {
        CDVPluginResult* pluginResult = nil;

        if (result.success) {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result.transactionCode];
        } else {
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:error.code];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

    if (![SumupSDK checkoutInProgress]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
