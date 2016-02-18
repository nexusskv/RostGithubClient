//
//  BaseViewController.m
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:16.0f/255.0f
                                                                             green:189.0f/255.0f
                                                                              blue:187/255.0f
                                                                             alpha:1.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.view.backgroundColor = [UIColor colorWithRed:219.0f/255.0f
                                                green:227.0f/255.0f
                                                 blue:227/255.0f
                                                alpha:1.0f];
}
#pragma mark -


#pragma mark - createLabelWithTitle:
- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    if ((title) && (title.length > 0)) {
        newLabel.text            = title;
    }
    
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.textColor       = [UIColor blackColor];
    newLabel.textAlignment   = NSTextAlignmentLeft;
    newLabel.font            = [UIFont boldSystemFontOfSize:16.0f];
    newLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    newLabel.numberOfLines   = 0;
    
    return newLabel;
}
#pragma mark -


#pragma mark - createTextFieldWithHolder:
- (UITextField *)createTextFieldWithHolder:(NSString *)holder {
    UITextField *newTextField             = [[UITextField alloc] initWithFrame:CGRectZero];
    newTextField.placeholder              = holder;
    newTextField.textColor                = [UIColor blackColor];
    newTextField.backgroundColor          = [UIColor whiteColor];
    newTextField.returnKeyType            = UIReturnKeyDone;
    newTextField.textAlignment            = NSTextAlignmentLeft;
    newTextField.clearButtonMode          = UITextFieldViewModeWhileEditing;
    newTextField.borderStyle              = UITextBorderStyleNone;
    newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextField.text                     = @"";
    newTextField.keyboardType             = UIKeyboardTypeASCIICapable;
    newTextField.autocapitalizationType   = UITextAutocapitalizationTypeNone;
    newTextField.autocorrectionType       = UITextAutocorrectionTypeNo;
    newTextField.font                     = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    newTextField.layer.cornerRadius       = 5;
    newTextField.clipsToBounds            = YES;
    newTextField.layer.borderColor        = [UIColor whiteColor].CGColor;
    
    return newTextField;
}
#pragma mark -


#pragma mark - createButtonWithTitle:andTag:
- (UIButton *)createButtonWithTitle:(NSString *)title andTag:(NSUInteger)tag {
    UIButton *newButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (tag > 0)
        newButton.tag = tag;
    
    if (title) {
        [newButton setTitle:title forState:UIControlStateNormal];
        [newButton setTitle:title forState:UIControlStateHighlighted];
    }
    
    newButton.titleLabel.font = [UIFont fontWithName:@"Verdana" size:14];
    
    [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [newButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [newButton setBackgroundColor:[UIColor colorWithRed:16.0f/255.0f green:189.0f/255.0f blue:187/255.0f alpha:1.0f]];
    
    newButton.layer.cornerRadius    = 5;
    newButton.clipsToBounds         = YES;
    
    [newButton addTarget:self action:@selector(buttonsSelector:) forControlEvents:UIControlEventTouchUpInside];
    newButton.frame = CGRectZero;
    
    return newButton;
}
#pragma mark -


#pragma mark - getRssTableByRect:
- (UITableView *)createTable {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor   = [UIColor clearColor];
    tableView.scrollEnabled     = YES;
    
    return tableView;
}
#pragma mark -


#pragma mark - showAlert:withMessage:
- (void)showAlert:(NSString *)title withMessage:(NSString *)message {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
#else
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
#endif
}
#pragma mark -


#pragma mark - addViews:withConstraints:
- (void)addViews:(NSDictionary *)views toView:(UIView *)superView withConstraints:(NSArray *)formats {
    for (UIView *view in views.allValues) {
        [superView addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    for (NSString *formatString in formats) {
        [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
}
#pragma mark -


#pragma mark - setHorizontalCenterToViews:inView:
- (void)setHorizontalCenterToViews:(NSDictionary *)views inView:(UIView *)superView {
    for (UIView *view in views.allValues) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
    }
}
#pragma mark -


#pragma mark - setVerticalCenterToViews:inView:
- (void)setVerticalCenterToViews:(NSDictionary *)views inView:(UIView *)superView {
    for (UIView *view in views.allValues) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0]];
    }
}
#pragma mark -


#pragma mark - buttonsSelector:
- (void)buttonsSelector:(id)sender {
}
#pragma mark -


#pragma mark - NSUserDefaults methods
- (id)getObjectForKey:(NSString *)key {
    if (key)
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        return nil;
}

- (void)saveObject:(id)object forKey:(id)key {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -

@end
