//
//  RepoCustomCell.h
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoCustomCell : UITableViewCell
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *cellTitleLabel;
@property (strong, nonatomic) UILabel *cellSubtitleLabel;
@property (strong, nonatomic) UILabel *cellDateLabel;
@property (strong, nonatomic) UITextView *cellTextView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier byKey:(NSUInteger)key;

@end
