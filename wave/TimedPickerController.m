//
//  TimedViewController.m
//  wave
//
//  Created by GrandSteph on 5/10/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "TimedPickerController.h"


@interface TimedPickerController ()

@property (strong,nonatomic) CLCloudinary *cloud;

@end

@implementation TimedPickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.showsCameraControls = NO;
        
        UIImage *img = [UIImage imageNamed:@"logoWaveIn"];
        UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
        overlay.frame = CGRectMake(120 , 400, img.size.width, img.size.height);
        overlay.alpha = 0;
        
        self.cameraOverlayView = overlay;
    }
    return self;
}

- (id) initBySteph{
    self=[super init];
    if (self) {
        // Custom initialization
        self.delegate = self;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.showsCameraControls = NO;
        
        UIImage *img = [UIImage imageNamed:@"LogoWaveIn"];
        UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
        overlay.frame = CGRectMake(120 , 400, img.size.width, img.size.height);
        overlay.alpha = 0;
        
        self.cameraOverlayView = overlay;
        
        //Cloudinary stuff
        self.cloud = [[CLCloudinary alloc] init];
        [self.cloud.config setValue:@"dviu7tmrq" forKey:@"cloud_name"];
        [self.cloud.config setValue:@"252529254152278" forKey:@"api_key"];
        [self.cloud.config setValue:@"_EEzcqFdOcrv4ENrhroBepzWlMo" forKey:@"api_secret"];
        
    }
    return self;
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    //self.imageView.image = chosenImage;
    
    
    
    UIImage *resizedImage = [self resizeImageWithImage:chosenImage toPixelLongest:320];
    NSData* pictureData = UIImageJPEGRepresentation(resizedImage,60);
    
    self.pictureData = pictureData;
    
    CLUploader *theUploader = [[CLUploader alloc] init:self.cloud delegate:self];
    [theUploader upload:pictureData options:@{@"folder":@"Wave1n-Test"}];
    
    [theUploader upload:pictureData options:nil withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        //completion
        NSLog(@"Upload success. Full result=%@", successResult);
        [picker dismissViewControllerAnimated:YES completion:nil];
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
        //progress
        NSLog(@"Going...");
    }];
    
    
    


    
}

/*- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    //NSString* url = [result valueForKey:@"url"];
    NSLog(@"Upload success. Full result=%@", result);
    
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:(NSNumberFormatterPercentStyle)];
    float uploadProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSString *formattedUploadProgress = [formatter stringFromNumber:[NSNumber numberWithFloat:uploadProgress]];
    NSLog(@"Upload in progress: %@", formattedUploadProgress);
}*/

- (UIImage*)resizeImageWithImage:(UIImage*)image toPixelLongest:(int)newLongest
{
    CGSize newSize = CGSizeMake(newLongest, newLongest / image.size.height * image.size.width);
    
//    if (image.size.width > image.size.height) {
//        newSize = CGSizeMake(newLongest / image.size.height * image.size.width,newLongest);
//    }
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // draw in new context, with the new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
