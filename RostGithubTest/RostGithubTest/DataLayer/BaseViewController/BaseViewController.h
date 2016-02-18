//
//  BaseViewController.h
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITableView *listTable;

- (UILabel *)createLabelWithTitle:(NSString *)title;

- (UITextField *)createTextFieldWithHolder:(NSString *)holder;

- (UIButton *)createButtonWithTitle:(NSString *)title andTag:(NSUInteger)tag;

- (UITableView *)createTable;

- (void)showAlert:(NSString *)title withMessage:(NSString *)message;

- (void)addViews:(NSDictionary *)views toView:(UIView *)superView withConstraints:(NSArray *)formats;

- (void)setHorizontalCenterToViews:(NSDictionary *)views inView:(UIView *)superView;
- (void)setVerticalCenterToViews:(NSDictionary *)views inView:(UIView *)superView;

- (id)getObjectForKey:(NSString *)key;
- (void)saveObject:(id)object forKey:(id)key;

@end
