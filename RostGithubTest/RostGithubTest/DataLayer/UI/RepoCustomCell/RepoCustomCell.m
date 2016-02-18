//
//  RepoCustomCell.m
//  RostGithubTest
//
//  Created by rost on 13.02.16.
//  Copyright © 2016 Rost. All rights reserved.
//

#import "RepoCustomCell.h"
#import "Constants.h"


@interface RepoCustomCell()

@end


@implementation RepoCustomCell


#pragma mark - Constructor
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier byKey:(NSUInteger)key {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSDictionary *viewsList = nil;
        NSArray *viewsFormats   = nil;

        if (key > 0) {
            switch (key) {
                case kIssueCellType: {
                    self.cellTitleLabel              = [self createLabelByType:kTitleType];
                    
                    self.cellSubtitleLabel           = [self createLabelByType:kSubtitleType];
                    self.cellSubtitleLabel.font      = [UIFont boldSystemFontOfSize:14.0f];
                    
                    self.cellDateLabel               = [self createLabelByType:kDateType];
                    self.cellDateLabel.font          = [UIFont boldSystemFontOfSize:14.0f];
                    
                    viewsList = @{@"cellTitleLabel"    : self.cellTitleLabel,
                                  @"cellSubtitleLabel" : self.cellSubtitleLabel,
                                  @"cellDateLabel"     : self.cellDateLabel
                                  };
                    
                    viewsFormats   = @[@"H:|-(10)-[cellTitleLabel]-(25)-|",
                                       @"H:|-(10)-[cellSubtitleLabel]-(25)-|",
                                       @"H:|-(10)-[cellDateLabel]",
                                       @"V:|-(5)-[cellTitleLabel(17)]-(5)-[cellSubtitleLabel(17)]",
                                       @"V:[cellDateLabel(13)]-(7)-|"
                                       ];
                    
                }
                    break;
                    
                case kContributorsCellType: {
                    self.logoImageView               = [self createImageView];
                    self.cellTitleLabel              = [self createLabelByType:kTitleType];
                    self.cellSubtitleLabel           = [self createLabelByType:kSubtitleType];
                    
                    viewsList = @{@"logoImageView"     : self.logoImageView,
                                  @"cellTitleLabel"    : self.cellTitleLabel,
                                  @"cellSubtitleLabel" : self.cellSubtitleLabel,
                                  };
                    
                    viewsFormats   = @[@"H:|-(5)-[logoImageView(60)]",
                                       @"H:|-(75)-[cellTitleLabel]-(25)-|",
                                       @"H:|-(75)-[cellSubtitleLabel]-(25)-|",
                                       @"V:|-(5)-[logoImageView]-(5)-|",
                                       @"V:|-(5)-[cellTitleLabel(17)]-(3)-[cellSubtitleLabel(30)]"
                                       ];
                }
                    break;
                    
                case kDescriptionCellType: {
                    self.cellTextView = [self createTextView];
                    
                    viewsList = @{@"cellTextView"     : self.cellTextView
                                  };
                    
                    viewsFormats   = @[@"H:|-(5)-[cellTextView]-(5)-|",
                                       @"V:|-(5)-[cellTextView]-(5)-|"
                                       ];
                }
                    break;
                    
                default:
                    break;
            }
        } else {
            self.logoImageView                      = [self createImageView];
            
            self.cellTitleLabel                     = [self createLabelByType:kTitleType];
            self.cellSubtitleLabel                  = [self createLabelByType:kSubtitleType];
            self.cellDateLabel                      = [self createLabelByType:kDateType];            
            
            viewsList = @{@"logoImageView"     : self.logoImageView,
                          @"cellTitleLabel"    : self.cellTitleLabel,
                          @"cellSubtitleLabel" : self.cellSubtitleLabel,
                          @"cellDateLabel"     : self.cellDateLabel
                          };
            
            viewsFormats   = @[@"H:|-(5)-[logoImageView(60)]",
                               @"H:|-(75)-[cellTitleLabel]-(25)-|",
                               @"H:|-(75)-[cellSubtitleLabel]-(25)-|",
                               @"H:[cellDateLabel]-(25)-|",
                               @"V:|-(5)-[logoImageView]-(5)-|",
                               @"V:|-(5)-[cellTitleLabel(17)]-(3)-[cellSubtitleLabel(30)]",
                               @"V:[cellDateLabel(13)]-(2)-|",
                               ];
        }
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        separatorView.backgroundColor = [UIColor lightGrayColor];
        
        NSMutableArray *finViewFormats = [NSMutableArray arrayWithArray:viewsFormats];
        [finViewFormats addObject:@"H:|-(10)-[separatorView]-(10)-|"];
        [finViewFormats addObject:@"V:[separatorView(1)]-(1)-|"];
        
        NSMutableDictionary *finViewsList = [NSMutableDictionary dictionaryWithDictionary:viewsList];
        finViewsList[@"separatorView"]    = separatorView;
        
        [self addViews:finViewsList withConstraints:finViewFormats];
    }
    
    return self;
}
#pragma mark -


#pragma mark - createImageView
- (UIImageView *)createImageView {
    UIImageView *newImageView        = [[UIImageView alloc] initWithFrame:CGRectZero];
    newImageView.contentMode         = UIViewContentModeScaleAspectFit;
    newImageView.layer.cornerRadius  = 10;
    newImageView.clipsToBounds       = YES;

    return newImageView;
}
#pragma mark -


#pragma mark - createLabelByType:
- (UILabel *)createLabelByType:(NSUInteger)type {
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.backgroundColor  = [UIColor clearColor];
    newLabel.textAlignment    = NSTextAlignmentLeft;
    newLabel.lineBreakMode    = NSLineBreakByWordWrapping;
    newLabel.textColor        = [UIColor whiteColor];
    
    switch (type) {
        case kTitleType: {
            newLabel.font             = [UIFont boldSystemFontOfSize:16.0f];
            newLabel.numberOfLines    = 1;
        }
            break;
            
        case kSubtitleType: {
            newLabel.font             = [UIFont boldSystemFontOfSize:12.0f];
            newLabel.numberOfLines    = 2;
        }
            break;
            
        case kDateType: {
            newLabel.font             = [UIFont boldSystemFontOfSize:10.0f];
            newLabel.textAlignment    = NSTextAlignmentRight;
            newLabel.numberOfLines    = 1;
        }
            break;

        default:
            break;
    }
    
    return newLabel;
}
#pragma mark -


#pragma mark - createTextView
- (UITextView *)createTextView {
    UITextView *newTextView                = [[UITextView alloc] initWithFrame:CGRectZero];
    newTextView.autocorrectionType         = UITextAutocorrectionTypeNo;
    newTextView.keyboardType               = UIKeyboardTypeDefault;
    newTextView.returnKeyType              = UIReturnKeyDone;
    newTextView.scrollEnabled              = YES;
    newTextView.userInteractionEnabled     = YES;
    newTextView.font                       = [UIFont boldSystemFontOfSize:14.0f];
    newTextView.textColor                  = [UIColor whiteColor];
    newTextView.editable                   = NO;
    newTextView.backgroundColor            = [UIColor clearColor];
    newTextView.layer.borderColor          = newTextView.backgroundColor.CGColor;
    newTextView.layer.borderWidth          = 0.3f;
    newTextView.layer.cornerRadius         = 3.0f;
    
    return newTextView;
}
#pragma mark -


#pragma mark - addViews:withConstraints:
- (void)addViews:(NSDictionary *)views withConstraints:(NSArray *)formats {
    for (UIView *view in views.allValues) {
        [self addSubview:view];
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    for (NSString *formatString in formats) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:formatString
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
    }
}
#pragma mark -

@end
