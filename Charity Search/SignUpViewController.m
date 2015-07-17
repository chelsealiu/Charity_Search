//
//  SignUpViewController.m
//  Charity Search
//
//  Created by Chelsea Liu on 7/13/15.
//  Copyright (c) 2015 Chelsea Liu. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SignUpViewController ()

@property NSMutableArray *objects;

@property(nonatomic,retain)IBOutlet UIImageView *imageView;
@property(nonatomic, strong) NSArray *pickerData;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end


@implementation SignUpViewController


-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.pickerData = @[@"Casual Movie Fan", @"Movie Critic"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.navigationItem.hidesBackButton = YES;
    
    [self.navigationController setToolbarHidden:YES];

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //configures the pickerview

    return self.pickerData[row];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageView.image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    //connect to 'Cancel' button
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)selectPhoto:(id)sender {
    
    //connects to + button on UIImageView
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];

}


- (IBAction)saveUserInfo:(id)sender {
    
    User *newUser = [User object]; //returns instance of class
    newUser.favouritesArray = [NSMutableArray array];
    newUser.username = self.usernameTextfield.text;
    newUser.pickerDataIndex = [self.pickerView selectedRowInComponent:0];
    newUser.userType = self.pickerData[newUser.pickerDataIndex];
    newUser.password = self.passwordTextfield.text;
    
    NSData* data = UIImageJPEGRepresentation(self.imageView.image, 0.5f);
    newUser.imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
    
        if (error.code == 202) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:@"Username is taken."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            
        } else if (error) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                             message:error.description
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];

        } else if (succeeded) {
            
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Congrats!"
                                                             message:@"You have successfully made a new account."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cool!"
                                                   otherButtonTitles: nil];
            [alert show];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    
    }];
        
}

- (IBAction)cancelSignUp:(id)sender {
    NSLog(@"action cancelled");
    [self.navigationController popToRootViewControllerAnimated:YES];
}






@end
