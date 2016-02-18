//
//  ApiConnector.h
//  RostGithubTest
//
//  Created by rost on 14.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^ApiConnectorCallback)(id);


@interface ApiConnector : NSObject

@property (nonatomic, copy) ApiConnectorCallback callbackBlock;

- (id)initWithCallback:(ApiConnectorCallback)block;

- (void)loadDataByUrl:(NSString *)url forView:(UIView *)view;

- (void)checkInternetConnectionForView:(UIView *)view;

@end
