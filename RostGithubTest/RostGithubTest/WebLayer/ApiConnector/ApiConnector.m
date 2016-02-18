//
//  ApiConnector.m
//  RostGithubTest
//
//  Created by rost on 14.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "ApiConnector.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "Constants.h"


@implementation ApiConnector


#pragma mark - initWithCallback:
- (id)initWithCallback:(ApiConnectorCallback)block {
    if (self = [super init])
        self.callbackBlock = block;
    
    return self;
}
#pragma mark -


#pragma mark - loadDataByUrl:forView:
- (void)loadDataByUrl:(NSString *)url forView:(UIView *)view {
    if (view)
        [MBProgressHUD showHUDAddedTo:view animated:YES];

    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [newRequest setHTTPMethod:@"GET"];
    [newRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [newRequest setValue:CLIENT_ID forHTTPHeaderField:@"client_id"];

    
    AFHTTPRequestOperation *newOperation = [[AFHTTPRequestOperation alloc] initWithRequest:newRequest];
    newOperation.responseSerializer = [AFJSONResponseSerializer serializer];    
    newOperation.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    [newOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (view)
            [MBProgressHUD hideHUDForView:view animated:YES];
        
        self.callbackBlock(responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (view)
            [MBProgressHUD hideHUDForView:view animated:YES];
        
        NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
        NSData *errorData = mutableUserInfo[@"com.alamofire.serialization.response.error.data"];
        if (errorData) {
            NSString *errorBody = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
            NSLog(@"Request error: %@", errorBody);
        }
    }];
    
    [newOperation start];
}
#pragma mark -


#pragma mark - checkInternetConnectionForView:
- (void)checkInternetConnectionForView:(UIView *)view {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    if (view)
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (view)
            [MBProgressHUD hideHUDForView:view animated:YES];
        
        if ((status == AFNetworkReachabilityStatusReachableViaWWAN) ||
            (status == AFNetworkReachabilityStatusReachableViaWiFi)) {
            self.callbackBlock(@(YES));
        } else {
            self.callbackBlock(@(NO));
        }        
    }];
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
#pragma mark -

@end
