//
//  ViewController.m
//  MLDPhtotManagerDemo
//
//  Created by Moliy on 2017/3/24.
//  Copyright © 2017年 Moliy. All rights reserved.
//

#import "ViewController.h"
#import "MLDPhotoManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)photoManagerClick:(id)sender
{
    [MLDPhotoManager showPhotoManager:sender
                    withMaxImageCount:9
                      withCameraImage:^(UIImage *cameraImage)
    {
        NSLog(@"cameraImage==%@",cameraImage);
    }
                       withAlbumArray:^(NSArray *albumArray)
    {
        NSLog(@"albumArray==%@",albumArray);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
