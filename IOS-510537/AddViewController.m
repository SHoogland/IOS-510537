//
//  AddViewController.m
//  IOS-510537
//
//  Created by Stephan Hoogland on 02/10/14.
//  Copyright (c) 2014 SHoogland. All rights reserved.
//

#import "AddViewController.h"
#import "AFNetworking.h"

@interface AddViewController ()

- (IBAction)uploadMessage:(id)sender;
- (IBAction)addImageClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *uploadIndicator;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_uploadIndicator setHidden:YES];
    
    //set up keyboard hiding function
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

//hide keyboard function
-(void)dismissKeyboard {
    [_titleTextField resignFirstResponder];
    [_textTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadMessage:(id)sender {
    [_uploadButton setEnabled:NO];
    [self dismissKeyboard];
    [_uploadIndicator setHidden:NO];
    [_uploadIndicator startAnimating];
    
    if(self.selectedImage.image){
        AFHTTPRequestOperationManager *imageManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://wpinholland.azurewebsites.net/"]];
        NSData *imageData = UIImageJPEGRepresentation(self.selectedImage.image, 0.5);
    
        AFHTTPRequestOperation *op = [imageManager POST:@"API/Images" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"verybeautifulimage" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSString *imageId = [responseObject objectForKey:@"ID"];
            [self uploadMessageWithOrWithoutImage:imageId];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self errorHappenedShowNotification];
            [_uploadButton setEnabled:YES];
            [_uploadIndicator stopAnimating];
            [_uploadIndicator setHidden:YES];

            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            
        }];
        [op start];
    } else {
        NSString *imageId = @"";
        [self uploadMessageWithOrWithoutImage:imageId];
    }
    
}

//submit message with or without image function
- (void)uploadMessageWithOrWithoutImage:(NSString*)imageId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *title = self.titleTextField.text;
    NSString *text = self.textTextField.text;
    
    NSDictionary *params;
    if(![imageId isEqual:@""]){
        params = @{@"Title": title,
                   @"Text": text,
                   @"Image": imageId};
    } else {
        params = @{@"Title": title,
                   @"Text": text};
    }
    
    [manager POST:@"http://wpinholland.azurewebsites.net/api/ios" parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [self succesHappenedShowNotification:[NSString stringWithFormat:@"%@", responseObject]];
              
              [_uploadButton setEnabled:YES];
              [_uploadIndicator stopAnimating];
              [_uploadIndicator setHidden:YES];
              
              self.titleTextField.text = @"";
              self.textTextField.text = @"";
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              [self errorHappenedShowNotification];

              [_uploadButton setEnabled:YES];
              [_uploadIndicator stopAnimating];
              [_uploadIndicator setHidden:YES];
              
              NSLog(@"Error: %@", error);
              
          }];

}

//show notification functions
- (void)succesHappenedShowNotification:(NSString*)messageToShow {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SUCCES!!" message:messageToShow delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)errorHappenedShowNotification {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something went wrong" message:@"Do you have an internet connection?" delegate:nil  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


//Image selection functions
- (IBAction)addImageClick:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.selectedImage.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
