//
//  RazorpayCheckout.m
//  RazorpayCheckout
//
//  Created by Akshay Bhalotia on 29/08/16.
//  Copyright © 2016 Razorpay. All rights reserved.
//

#import "RazorpayCheckout.h"
#import "RazorpayEventEmitter.h"

#import <Razorpay/Razorpay.h>
#import <Razorpay/RazorpayPaymentCompletionProtocolWithData.h>

@interface RazorpayCheckout () <RazorpayPaymentCompletionProtocolWithData>

@end

@implementation RazorpayCheckout

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(open : (NSDictionary *)options) {

  NSString *keyID = (NSString *)[options objectForKey:@"key"];
  id razorpay = [NSClassFromString(@"Razorpay") initWithKey:keyID
                                        andDelegateWithData:self];
  dispatch_sync(dispatch_get_main_queue(), ^{
    [razorpay open:options];
  });
}

- (void)onPaymentSuccess:(nonnull NSString *)payment_id
                 andData:(nullable NSDictionary *)response {
  [RazorpayEventEmitter onPaymentSuccess:payment_id andData:response];
}

- (void)onPaymentError:(int)code
           description:(nonnull NSString *)str
               andData:(nullable NSDictionary *)response {
  [RazorpayEventEmitter onPaymentError:code description:str andData:response];
}

@end
