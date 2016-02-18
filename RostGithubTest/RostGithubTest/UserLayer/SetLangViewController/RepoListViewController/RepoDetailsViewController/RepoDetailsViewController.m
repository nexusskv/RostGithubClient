//
//  RepoDetailsViewController.m
//  RostGithubTest
//
//  Created by rost on 15.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "RepoDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"
#import "ApiConnector.h"
#import "RepoCustomCell.h"


@interface RepoDetailsViewController()

@end


@implementation RepoDetailsViewController


#pragma mark - View life cycle
- (void)loadView {
    [super loadView];
    
    self.title = self.dataArray[0][@"full_name"];
    
    NSString *issuesTopUrl  = nil;
    if (self.dataArray[0][@"issues_url"]) {
        issuesTopUrl = [self.dataArray[0][@"issues_url"] stringByReplacingOccurrencesOfString:@"{/number}"
                                                                                   withString:@""];
        issuesTopUrl = [NSString stringWithFormat:@"%@?%@", issuesTopUrl, TOP_ISSUES_SORT];
        
        [self loadDataByUrl:issuesTopUrl andType:kLoadIssuesType];
    } else if (self.dataArray[0][@"contributors_url"]) {
        [self loadContributors];
    }
    
    self.listTable.allowsSelection = NO;
}
#pragma mark -


#pragma mark - loadDataByUrl:andType:
- (void)loadDataByUrl:(NSString *)url andType:(NSUInteger)type {
    ApiConnector *ac = [[ApiConnector alloc] initWithCallback:^(id resultObject) {
        
        NSMutableDictionary *objectsValues = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[0]];
        
        if (type == kLoadIssuesType) {
            if ((resultObject) && ([resultObject count] > 0)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSArray *keysList = @[@"id",
                                          @"created_at",
                                          @"title",
                                          @"state"
                                          ];
                    
                    NSArray *tempValues = [self getResponseValues:resultObject byKeys:keysList];
                    if ([tempValues count] > 0) {
                        objectsValues[@"Issues"]  = tempValues;
                    }
                    
                    if ([objectsValues[@"Issues"] count] > 0) {
                        NSMutableArray *newObjects = [NSMutableArray arrayWithArray:self.dataArray];
                        newObjects[0] = objectsValues;
                        self.dataArray = newObjects;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (self.dataArray[0][@"contributors_url"]) {
                                [self loadContributors];
                            } else {
                                [self.listTable reloadData];
                            }
                        });
                    }
                    
                });
            }
        } else if (type == kLoadContributorsType) {
            if ((resultObject) && ([resultObject count] > 0)) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSArray *keysList = @[@"id",
                                          @"avatar_url",
                                          @"contributions",
                                          @"login"
                                          ];
                    
                    NSArray *tempValues = [self getResponseValues:resultObject byKeys:keysList];
                    if ([tempValues count] > 0) {
                        objectsValues[@"Contributors"]  = tempValues;
                    }
                    
                    if ([objectsValues[@"Contributors"] count] > 0) {
                        NSMutableArray *newObjects = [NSMutableArray arrayWithArray:self.dataArray];
                        newObjects[0] = objectsValues;
                        self.dataArray = newObjects;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.listTable reloadData];
                        });
                    }
                });

            }
        }
    }];
    
    [ac loadDataByUrl:url forView:self.view];
}
#pragma mark -


#pragma mark - loadContributors
- (void)loadContributors {
    NSString *contribTopUrl =
    [NSString stringWithFormat:@"%@?%@", self.dataArray[0][@"contributors_url"], TOP_CONTRIB_SORT];
    
    [self loadDataByUrl:contribTopUrl andType:kLoadContributorsType];
}
#pragma mark -


#pragma mark - getResponseValues:byKeys:
- (NSArray *)getResponseValues:(id)values byKeys:(NSArray *)keys {
    NSMutableArray *valuesMutableArray = [NSMutableArray array];
    int topCount = 0;
    
    for (NSDictionary *valuesObject in values) {
        if ((topCount < 3) && ([[valuesObject allValues] count] > 0))  {
            NSMutableDictionary *newValues = [NSMutableDictionary dictionary];
            
            for (__strong NSString *keyValue in keys) {
                if ([valuesObject[keyValue] isKindOfClass:[NSString class]]) {
                    NSString *checkValue = valuesObject[keyValue];
                    if ((checkValue != NULL) && (checkValue.length > 0)) {
                        if ([keyValue isEqualToString:@"created_at"]) {
                            checkValue = [checkValue stringByReplacingOccurrencesOfString:@"Z"
                                                                               withString:@""];
                            
                            checkValue = [checkValue stringByReplacingOccurrencesOfString:@"T"
                                                                               withString:@" "];
                        }

                        if ([keyValue isEqualToString:@"avatar_url"]) {
                            keyValue = @"logo";
                        }
                        
                        newValues[keyValue] = checkValue;
                    }
                } else if ([valuesObject[keyValue] isKindOfClass:[NSNumber class]]) {
                    if ([valuesObject[keyValue] longLongValue] > 0)
                        newValues[keyValue] = valuesObject[keyValue];
                }
            }
            
            if ([[newValues allValues] count] > 0) {
                [valuesMutableArray addObject:newValues];
            }
            
            topCount++;
        } else {
            return valuesMutableArray;
        }
    }

    return nil;
}
#pragma mark -


#pragma mark - TableView dataSource & delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger sectionsCount = 1;
    
    if ([self.dataArray[0][@"Issues"] count] > 0) {
        sectionsCount++;
    }
    
    if ([self.dataArray[0][@"Contributors"] count] > 0) {
        sectionsCount++;
    }

    return sectionsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 1))
        return 80.0f;
    else
        return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 2;
        }
            break;
            
        case 1: {
            return [self.dataArray[0][@"Issues"] count];
        }
            break;
            
        case 2: {
            return [self.dataArray[0][@"Contributors"] count];
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 1: {
            if ([self.dataArray[0][@"Issues"] count] > 0)
                return @"Top of Newest Issues";
        }
            break;
            
        case 2: {
            if ([self.dataArray[0][@"Contributors"] count] > 0)
                return @"Top of Contributors";
        }
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    RepoCustomCell *cell = nil;
    
    if (cell == nil) {
        if (indexPath.section == 0) {
            NSUInteger cellKey = 0;
            
            if (indexPath.row > 0)
                cellKey = kDescriptionCellType;
            
            cell = [[RepoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:cellIdentifier
                                                   byKey:cellKey];
            
            switch (indexPath.row) {
                case 0: {
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
                    
                    return cell;
                }
                    break;
                    
                case 1: {
                    if (self.dataArray[0][@"description"]) {
                        cell.cellTextView.text = self.dataArray[0][@"description"];
                        
                        return cell;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        } else if (indexPath.section == 1) {
            if ([self.dataArray[0][@"Issues"] count] > 0) {
                cell = [[RepoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier
                                                       byKey:kIssueCellType];
                
                NSArray *issuesList = self.dataArray[0][@"Issues"];
                
                NSString *checkValue = issuesList[indexPath.row][@"title"];
                if (checkValue.length > 0)
                    cell.cellTitleLabel.text    = [NSString stringWithFormat:@"Title: %@", checkValue];;
                
                checkValue = issuesList[indexPath.row][@"state"];
                if (checkValue.length > 0)
                cell.cellSubtitleLabel.text = [NSString stringWithFormat:@"State: %@", checkValue];
                
                checkValue = issuesList[indexPath.row][@"created_at"];
                if (checkValue.length > 0)
                    cell.cellDateLabel.text = [NSString stringWithFormat:@"Date created: %@", checkValue];;
                
                return cell;
            }
        } else if (indexPath.section == 2) {
            if ([self.dataArray[0][@"Contributors"] count] > 0) {
                cell = [[RepoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier
                                                       byKey:kContributorsCellType];
                
                NSArray *contributList = self.dataArray[0][@"Contributors"];
                
                NSString *checkValue = contributList[indexPath.row][@"logo"];
                if (checkValue.length > 0)
                    [cell.logoImageView setImageWithURL:[NSURL URLWithString:checkValue]];
                
                checkValue = contributList[indexPath.row][@"login"];
                if (checkValue.length > 0)
                    cell.cellTitleLabel.text    = [NSString stringWithFormat:@"User name: %@", checkValue];
                
                checkValue = [NSString stringWithFormat:@"%@", contributList[indexPath.row][@"contributions"]];
                if (checkValue.length > 0)
                    cell.cellSubtitleLabel.text = [NSString stringWithFormat:@"Contributions: %@", checkValue];
                
                return cell;
            }
        }
    }
    
    return nil;
}
#pragma mark -

@end
