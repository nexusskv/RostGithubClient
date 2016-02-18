//
//  SetLangViewController.m
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "SetLangViewController.h"
#import "Constants.h"
#import "ApiConnector.h"
#import "RepoListViewController.h"


@interface SetLangViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *languageTextField;
@property (strong, nonatomic) NSString *requestUrl;
@end


@implementation SetLangViewController


#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
    
    self.title = @"Rost Github Test";

    
    // CREATE UI
    UILabel *actionMessageLabel        = [self createLabelWithTitle:@"Please enter a language \nfor request to Guthub."];
    actionMessageLabel.textAlignment   = NSTextAlignmentCenter;
    
    self.languageTextField             = [self createTextFieldWithHolder:[NSString stringWithFormat:@"%@Enter a language", @"  "]];
    self.languageTextField.delegate    = self;
    
    UIButton *githubRequestButton      = [self createButtonWithTitle:@"Send request" andTag:GITHUB_REQUEST_BUTTON_TAG];

    
    // CREATE CONSTRAINTS PARAMS
    NSDictionary *viewsList     = @{@"actionMessageLabel"   : actionMessageLabel,
                                    @"githubRequestButton"  : githubRequestButton,
                                    @"languageTextField"    : self.languageTextField
                                    };
    
    NSArray *constraintsFormats = @[@"H:[actionMessageLabel(250)]",
                                    @"H:[languageTextField(250)]",
                                    @"H:[githubRequestButton(250)]",
                                    @"V:[actionMessageLabel(40)]-(50)-[languageTextField(35)]-(25)-[githubRequestButton(43)]"
                                 ];

    // ADD CONSTRAINTS TO VIEW
    [self addViews:viewsList toView:self.view withConstraints:constraintsFormats];
    
    [self setHorizontalCenterToViews:viewsList inView:self.view];
    [self setVerticalCenterToViews:@{@"githubRequestButton" : githubRequestButton} inView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.languageTextField.text = @"";
}
#pragma mark -


#pragma mark - buttonsSelector:
- (void)buttonsSelector:(id)sender {
    UIButton *tappedButton = (UIButton *)sender;
    
    if (tappedButton.tag == GITHUB_REQUEST_BUTTON_TAG) {
        if (self.languageTextField.text.length > 0) {
            self.requestUrl = [NSString stringWithFormat:@"%@?q=language:%@&%@=1", GITHUB_REPO_URL, self.languageTextField.text, SEARCH_PARAMS];
            
            // SAVE LANGUAGE TO USER DEFAULTS FOR NEXT REQUESTS
            [self saveObject:self.languageTextField.text forKey:ENTERED_LANGUAGE];
            
            [self loadDataByUrl:self.requestUrl andType:kCheckConnection];
        }
    }
}
#pragma mark -
    
    
#pragma mark - loadDataByUrl:andType:
- (void)loadDataByUrl:(NSString *)url andType:(NSUInteger)type {
    ApiConnector *ac = [[ApiConnector alloc] initWithCallback:^(id resultObject) {
        if ((type == kCheckConnection) && ([resultObject boolValue] == YES)) {
            [self loadDataByUrl:url andType:kLoadRepoType];
        } else if ((type == kLoadRepoType) && (resultObject)) {
            if (resultObject[@"total_count"] > 0)
                [self saveObject:resultObject[@"total_count"] forKey:TOTAL_COUNT];
            
            if ([resultObject[@"items"] count] > 0) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSMutableArray *reposMutableArray = [NSMutableArray array];
                    
                    for (NSDictionary *repoObject in resultObject[@"items"]) {
                        if ([[repoObject allValues] count] > 0) {
                            NSMutableDictionary *repoValues = [NSMutableDictionary dictionary];
                            
                            NSArray *keysList = @[@"id",
                                                  @"full_name",
                                                  @"language",
                                                  @"issues_url",
                                                  @"url",
                                                  @"created_at",
                                                  @"size",
                                                  @"watchers",
                                                  @"contributors_url",
                                                  @"description"
                                                  ];
                            
                            for (NSString *keyValue in keysList) {
                                if ([repoObject[keyValue] isKindOfClass:[NSString class]]) {
                                    NSString *checkValue = repoObject[keyValue];
                                    if ((checkValue != NULL) && (checkValue.length > 0)) {
                                        if ([keyValue isEqualToString:@"created_at"]) {
                                            checkValue = [checkValue stringByReplacingOccurrencesOfString:@"Z"
                                                                                               withString:@""];
                                            
                                            checkValue = [checkValue stringByReplacingOccurrencesOfString:@"T"
                                                                                               withString:@" "];
                                        }
                                        
                                        repoValues[keyValue] = checkValue;
                                    }
                                } else if ([repoObject[keyValue] isKindOfClass:[NSNumber class]]) {
                                    if ([repoObject[keyValue] longLongValue] > 0)
                                        repoValues[keyValue] = repoObject[keyValue];
                                }
                            }
                            
                            NSString *checkValue = [repoObject valueForKeyPath:@"owner.avatar_url"];
                            if ((checkValue != NULL) && (checkValue.length > 0)) {
                                repoValues[@"logo"] = checkValue;
                            }
                            
                            if ([[repoValues allValues] count] > 0) {
                                [reposMutableArray addObject:repoValues];
                            }
                        }
                    }
                    
                    if ([reposMutableArray count] > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            RepoListViewController *plVC = [[RepoListViewController alloc] init];
                            plVC.dataArray = reposMutableArray;
                            [self.navigationController pushViewController:plVC animated:YES];
                        });
                    }
                });
            }
        }
    }];
    
    if (type == kCheckConnection)
        [ac checkInternetConnectionForView:self.view];
    else
        [ac loadDataByUrl:url forView:self.view];
}
#pragma mark -


#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 1)
        [textField resignFirstResponder];
    
    return YES;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
