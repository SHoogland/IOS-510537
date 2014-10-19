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
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.detailTitleLabel.text = [self.messageDetail objectForKey:@"Title"];
    
    //check for an existing image and place this or a template in the view
    id imageObj = [self.messageDetail objectForKey:@"ImageUrl"];
    if([imageObj isKindOfClass:[NSString class]] ){
        
        NSURL *url = [[NSURL alloc] initWithString:imageObj];
        [self.detailImageView setImageWithURL: url];
        
    } else {
        
        NSURL* url=[[NSURL alloc] initWithString:@"http://www.silvermorgandollar.com/images/no_image.gif"];
        [self.detailImageView setImageWithURL: url];
    }
    
    self.detailTextView.text = [self.messageDetail objectForKey:@"Text"];
    
    id time = [self.messageDetail objectForKey:@"Timestamp"];
    double unixTimeStamp =[time doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    self.detailTimeLabel.text = [_formatter stringFromDate:date];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
