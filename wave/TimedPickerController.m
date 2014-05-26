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
@property (strong, nonatomic) IBOutlet UIView *CustomOverlay;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchCameraButton;
@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;
@property (strong, nonatomic) NSNumber *secondsToSnap;
- (IBAction)switchCamera:(id)sender;

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
        
        //UIImage *img = [UIImage imageNamed:@"logoWaveIn"];
        //pickerOverlay *overlay = [[pickerOverlay alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        //self.cameraOverlayView = overlay;
    }
    return self;
}

- (id) initWithCloud:(NSString *) eventID secondsToSnap:(NSNumber *) secondsToSnap {
    self=[super init];
    if (self) {
        // Custom initialization
        self.eventID = eventID;
        
        self.delegate = self;
        self.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.showsCameraControls = NO;
        self.secondsToSnap = secondsToSnap;
        
//        // create button
//        UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [switchButton setTitle:@"Camera switch" forState:UIControlStateNormal];
//        [switchButton sizeToFit];
//        switchButton.center = CGPointMake(250, 40);
//        
//        // create label
//        UILabel *countdown = [[UILabel alloc] init];
//        [countdown setText:@"5"];
//        [countdown sizeToFit];
//        countdown.center = CGPointMake(160, 500);
//        
//        // Creation of overlay
//        //UIImage *img = [UIImage imageNamed:@"LogoWaveIn"];
//        //UIImageView *overlay = [[UIImageView alloc] initWithImage:img];
//        UIImageView *overlay = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height)];
//        overlay.opaque = NO;
//        overlay.backgroundColor = [UIColor clearColor];
//        [overlay addSubview:switchButton];
//        [overlay addSubview:countdown];

        
        [[NSBundle mainBundle] loadNibNamed:@"PickerOverlay" owner:self options:nil];
        self.CustomOverlay.frame = self.cameraOverlayView.frame;
        self.cameraOverlayView = self.CustomOverlay;
        self.CustomOverlay = nil;

        
        //self.cameraOverlayView = overlay;
        
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
    // get image from Picker
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    // resize image, compress and transform NSData for Cloudinary
    UIImage *resizedImage = [self resizeImageWithImage:chosenImage toPixelLongest:320];
    NSData* pictureData = UIImageJPEGRepresentation(resizedImage,60);
    self.pictureData = pictureData;
    
    // Upload avec options
    CLUploader *theUploader = [[CLUploader alloc] init:self.cloud delegate:self];
    [theUploader upload:pictureData options:@{@"public_id":[NSString stringWithFormat:@"%@PHILIPPE",self.eventID]} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
        
        //completion
        NSLog(@"Upload success. Full result=%@", successResult);
        [picker dismissViewControllerAnimated:YES completion:nil];
    
    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
        float total = totalBytesExpectedToWrite;
        float current = totalBytesWritten;
        float percent = (current / total) * 100;
        
        //progress
        self.countDownLabel.text = [NSString stringWithFormat:@" upload %1.0f%% ",percent];
        
    }];
}

- (UIImage*)resizeImageWithImage:(UIImage*)image toPixelLongest:(int)newLongest
{
    //Compute size for lanscape
    CGSize newSize = CGSizeMake(newLongest, newLongest * (image.size.height/image.size.width));
    
    if (image.imageOrientation == UIImageOrientationUp) {
        //portrait
        newSize.width = newLongest * (image.size.width/image.size.height);
        newSize.height = newLongest;
    }
    
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

- (void) countdownTick:(NSTimer *) theTimer {

    self.secondsToSnap = [NSNumber numberWithInt:[self.secondsToSnap intValue] - 1];
    self.countDownLabel.text = [self.secondsToSnap stringValue];
    
    if ([self.secondsToSnap intValue] < 2) {
        self.switchCameraButton.enabled = NO;
    }
    
    if ([self.secondsToSnap intValue] == 0) {
        [theTimer invalidate];
        [self takePicture];
    }
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

- (IBAction)switchCamera:(id)sender {
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    } else {
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
}

@end
