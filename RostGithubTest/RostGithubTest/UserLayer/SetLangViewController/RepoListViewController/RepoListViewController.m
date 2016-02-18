//
//  RepoListViewController.m
//  RostGithubTest
//
//  Created by rost on 15.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "RepoListViewController.h"
#import "UIImageView+AFNetworking.h"
#import "RepoCustomCell.h"
#import "RepoDetailsViewController.h"
#import "UIImage+ImageEffects.h"
#import "Constants.h"
#import "ApiConnector.h"


@interface RepoListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) NSUInteger currentPage;
@property (assign, nonatomic) NSUInteger totalCount;
@end


@implementation RepoListViewController


#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
    
    self.title = @"List of Repositories";
    
    self.listTable                     = [self createTable];
    self.listTable.delegate            = self;
    self.listTable.dataSource          = self;
    self.listTable.backgroundColor     = [UIColor clearColor];
  
    // CREATE CONSTRAINTS PARAMS
    NSDictionary *viewsList     = @{@"listTable" : self.listTable};
    
    NSArray *constraintsFormats = @[@"H:|[listTable]|",
                                    @"V:|[listTable]|"];
    
    // ADD CONSTRAINTS TO VIEW
    [self addViews:viewsList toView:self.view withConstraints:constraintsFormats];
    
    // VALUES FOR LOAD NEXT REPOS
    self.currentPage = 2;
    self.totalCount  = [[self getObjectForKey:TOTAL_COUNT] intValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view layoutSubviews];
    
    UIColor *tintColor   = [UIColor colorWithRed:134.0f/255.0f green:226.0f/255.0f blue:213.0f/255.0f alpha:0.5f];
    UIImage *bgImage     = [UIImage imageNamed:@"table_bg"];
    UIImage *bluredImage = [bgImage applyBlurWithRadius:7.0f
                                              tintColor:tintColor
                                  saturationDeltaFactor:12.0f
                                              maskImage:bgImage];
    
    UIImageView *blurredImageView = [[UIImageView alloc] initWithFrame:self.listTable.frame];
    blurredImageView.image        = bluredImage;
    blurredImageView.contentMode  = UIViewContentModeScaleToFill;
    
    UIView *blurredBgView = [[UIView alloc] initWithFrame:self.listTable.frame];
    [blurredBgView addSubview:blurredImageView];
    
    self.listTable.backgroundView = blurredBgView;
}
#pragma mark -


#pragma mark - loadDataByUrl:
- (void)loadDataByUrl:(NSString *)url {
    ApiConnector *ac = [[ApiConnector alloc] initWithCallback:^(id resultObject) {
        if ((resultObject) && ([resultObject[@"items"] count] > 0)) {
            self.currentPage++;             // ITERATE TO NEXT PAGE FOR DOWNLOAD REPO
            
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
                    NSMutableArray *prevReposArray = [NSMutableArray arrayWithArray:self.dataArray];
                    [prevReposArray addObjectsFromArray:reposMutableArray];
                    self.dataArray = prevReposArray;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.listTable reloadData];
                    });
                }
            });
        }
    }];

    [ac loadDataByUrl:url forView:nil];
}
#pragma mark -


#pragma mark - TableView dataSource & delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    RepoCustomCell *cell = nil;
    
    if (cell == nil) {
        cell = [[RepoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier byKey:0];
        
        if (self.dataArray[indexPath.row][@"logo"])
            [cell.logoImageView setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"logo"]]];
        
        if (self.dataArray[indexPath.row][@"full_name"])
            cell.cellTitleLabel.text = self.dataArray[indexPath.row][@"full_name"];
        
        NSString *detailValue = nil;
        if (self.dataArray[indexPath.row][@"language"]) {
            detailValue =
            [NSString stringWithFormat:@"Language: %@", self.dataArray[indexPath.row][@"language"]];
        }
        
        if (self.dataArray[indexPath.row][@"size"]) {
            detailValue =
            [NSString stringWithFormat:@"%@ / Size: %@", detailValue, self.dataArray[indexPath.row][@"size"]];
        }
        
        if (self.dataArray[indexPath.row][@"watchers"]) {
            detailValue =
            [NSString stringWithFormat:@"%@\nWatchers: %@", detailValue, self.dataArray[indexPath.row][@"watchers"]];
        }
        
        if (detailValue)
            cell.cellSubtitleLabel.text = detailValue;
        
        if (self.dataArray[indexPath.row][@"created_at"])
            cell.cellDateLabel.text = self.dataArray[indexPath.row][@"created_at"];
    }
    
    
    if  ((self.totalCount > 0) && ([self.dataArray count] < self.totalCount)) {
        if (indexPath.row == [self.dataArray count] - 15) {
            NSString *urlValue = [NSString stringWithFormat:@"%@?q=language:%@&%@=%lu",
                                  GITHUB_REPO_URL,
                                  [self getObjectForKey:ENTERED_LANGUAGE],
                                  SEARCH_PARAMS,
                                  (unsigned long)self.currentPage];
            
            [self loadDataByUrl:urlValue];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        RepoDetailsViewController *rdVC = [[RepoDetailsViewController alloc] init];
        rdVC.dataArray = @[self.dataArray[indexPath.row]];
        [self.navigationController pushViewController:rdVC animated:YES];
    });
}
#pragma mark -

@end
