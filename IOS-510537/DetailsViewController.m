//
//  DetailsViewController.m
//  IOS-510537
//
//  Created by Stephan Hoogland on 02/10/14.
//  Copyright (c) 2014 SHoogland. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.detailTitleLabel.text = [self.messageDetail objectForKey:@"Title"];
    
    //check for an existing image and place this or a template in the view
    id imageObj = [self.messageDetail objectForKey:@"ImageUrl"];
    if([imageObj isKindOfClass:[NSString class]] ){
        
        NSURL *url = [[NSURL alloc] initWithString:imageObj];
        [self.detailImageView setImageWithURL: url];
        
    } else {
        
        NSURL* url=[[NSURL alloc] initWithString:@"http://www.financiereguizot.com/wp-content/themes/twentyeleven/images/img-not-found_600_600.jpg"];
        [self.detailImageView setImageWithURL: url];
    }
    
    self.detailTextLabel.text = [self.messageDetail objectForKey:@"Text"];
    id time = [self.messageDetail objectForKey:@"Timestamp"];
    if ([time isKindOfClass:[NSString class]]) {
        NSString *timeString = [[NSString alloc] initWithString:time];
        self.detailTimeLabel.text = timeString;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
