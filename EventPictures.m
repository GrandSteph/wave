//
//  EventView.m
//  wave
//
//  Created by GrandSteph on 5/15/14.
//  Copyright (c) 2014 GrandSteph. All rights reserved.
//

#import "EventPictures.h"

@interface EventPictures ()

@end

@implementation EventPictures

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.eventDescLabel.text = self.eventID;
    
    //Cloudinary stuff
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    [cloudinary.config setValue:@"dviu7tmrq" forKey:@"cloud_name"];
    [cloudinary.config setValue:@"252529254152278" forKey:@"api_key"];
    [cloudinary.config setValue:@"_EEzcqFdOcrv4ENrhroBepzWlMo" forKey:@"api_secret"];

    NSString *url1 = [cloudinary url:[NSString stringWithFormat:@"%@STEPHANE.jpg",self.eventID]];
    NSString *url2 = [cloudinary url:[NSString stringWithFormat:@"%@PHILIPPE.jpg",self.eventID]];
    NSString *url3 = [cloudinary url:[NSString stringWithFormat:@"%@SOPHIE.jpg",self.eventID]];
    
    self.image1.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url1]]];
    self.image2.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url2]]];
    self.image3.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url3]]];
    
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
