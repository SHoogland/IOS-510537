//
//  TableViewController.m
//  IOS-510537
//
//  Created by Stephan Hoogland on 02/10/14.
//  Copyright (c) 2014 SHoogland. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h"
#import "SVPullToRefresh/UIScrollView+SVPullToRefresh.h"

@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *apiArrayFromAFNetworking;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeAPIRequests];
    
    self.tableView.contentInset = UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f);
    
    __weak TableViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.tableView.pullToRefreshView startAnimating];
        [weakSelf makeAPIRequests];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.tableView.infiniteScrollingView startAnimating];
        [weakSelf addAPIRequests];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.apiArrayFromAFNetworking count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MessageCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //get the messages from the NSMutableArray
    NSDictionary *tempDictionary= [self.apiArrayFromAFNetworking objectAtIndex:indexPath.row];
    
    //insert title field
    cell.titleLabel.text = [tempDictionary objectForKey:@"Title"];
    //insert text field
    cell.apiTextLabel.text = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"Text"]];
   
    //check for an existing image and place this or a template in the view
    id imageObj = [tempDictionary objectForKey:@"ImageUrl"];
    if([imageObj isKindOfClass:[NSString class]] ){
        
        NSURL *url = [[NSURL alloc] initWithString:imageObj];
        [cell.imagePreview setImageWithURL: url];
        
    } else {
        
        NSURL* url=[[NSURL alloc] initWithString:@"http://www.financiereguizot.com/wp-content/themes/twentyeleven/images/img-not-found_600_600.jpg"];
        [cell.imagePreview setImageWithURL: url];
    }
    return cell;
}

-(void)makeAPIRequests {
    //Request url
    NSURL *url = [NSURL URLWithString:@"http://wpinholland.azurewebsites.net/api/messages"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //Executed function after operation completion
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.apiArrayFromAFNetworking = [[NSMutableArray alloc] initWithArray:[responseObject objectForKey:@"Messages"]];
        
        [self.tableView reloadData];
        [self.tableView.pullToRefreshView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //Log the error
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
}

-(void)addAPIRequests {
    //get the id from last object from current messages
    NSString *finalIdString = [[self.apiArrayFromAFNetworking objectAtIndex:self.apiArrayFromAFNetworking.count-1] objectForKey:@"ID"];
    //convert the id to an int
    int finalId = finalIdString.intValue;
    
    //use the id to retrieve the next 20 messages from the API
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wpinholland.azurewebsites.net/api/messages/%d", finalId]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //Executed function after operation completion
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.apiArrayFromAFNetworking addObjectsFromArray:[responseObject objectForKey:@"Messages"]];
        
        [self.tableView reloadData];
        [self.tableView.infiniteScrollingView stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual: @"DetailsSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailsViewController *detailViewController = (DetailsViewController *)segue.destinationViewController;
        detailViewController.messageDetail = [self.apiArrayFromAFNetworking objectAtIndex:indexPath.row];
    }
}

@end
