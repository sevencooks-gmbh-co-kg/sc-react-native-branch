//
//  SCBranchBridge.m
//  scapp
//
//  Created by Piquant Earthqake on 02.07.21.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_REMAP_MODULE(SCBranch, SCBranchManager, NSObject)

RCT_EXTERN_METHOD(initSession);

RCT_EXTERN_METHOD(validateSDKIntegration);

RCT_EXTERN_METHOD(getLatestReferringParams: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject);

RCT_EXTERN_METHOD(getFirstReferringParams: (RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject);

RCT_EXTERN_METHOD(generateShortUrl:(NSDictionary *)branchUniversalObject linkProperties:(NSDictionary *)linkProperties resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject);

@end
