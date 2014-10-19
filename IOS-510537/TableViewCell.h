//
//  TableViewCell.h
//  IOS-510537
//
//  Created by Stephan Hoogland on 02/10/14.
//  Copyright (c) 2014 SHoogland. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *apiTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
