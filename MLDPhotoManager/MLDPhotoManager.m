//
//  MLDPhotoManager.m
//  Photo
//
//  Created by Moliy on 2017/3/23.
//  Copyright © 2017年 Moliy. All rights reserved.
//

#import "MLDPhotoManager.h"

@interface MLDPhotoManager ()<LGPhotoPickerBrowserViewControllerDataSource,LGPhotoPickerBrowserViewControllerDelegate>

@property (nonatomic, assign) LGShowImageType showType;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserPhotoArray;
@property (nonatomic, strong)NSMutableArray *LGPhotoPickerBrowserURLArray;
@property (nonatomic,copy)void(^CameraImage)(UIImage *cameraImage);
@property (nonatomic,copy)void(^AlbumArray)(NSArray *albumArray);
@end

@implementation MLDPhotoManager

+ (void)showPhotoManager:(UIView *)sender
         withCameraImage:(void(^)(UIImage *cameraImage))cameraImage
          withAlbumArray:(void(^)(NSArray *albumArray))albumArray
{
    MLDPhotoManager *objct = [[MLDPhotoManager alloc] init];
    objct.AlbumArray = albumArray;
    objct.CameraImage = cameraImage;
    [objct showAlert:sender];
}


#pragma mark - 懒加载

- (NSMutableArray *)LGPhotoPickerBrowserPhotoArray
{
    if (!_LGPhotoPickerBrowserPhotoArray)
    {
        _LGPhotoPickerBrowserPhotoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _LGPhotoPickerBrowserPhotoArray;
}

- (NSMutableArray *)LGPhotoPickerBrowserURLArray
{
    if (!_LGPhotoPickerBrowserURLArray)
    {
        _LGPhotoPickerBrowserURLArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _LGPhotoPickerBrowserURLArray;
}

#pragma mark - setupUI

- (void)showAlert:(UIView *)view
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"现在拍摄"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self presentCameraSingle];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"相机胶卷"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                }]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = view;
            popover.sourceRect = view.bounds;
            popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
        }
        [[self getCurrentVC] presentViewController:alertController
                                          animated:YES
                                        completion:nil];
    }
    else
    {
        [[self getCurrentVC] presentViewController:alertController
                                          animated:YES
                                        completion:nil];
    }
}

/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style
{
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;   // 最多能选9张图片
    pickerVc.callBack = ^(NSArray *assets)
    {
        NSMutableArray *thumbImageArray = [NSMutableArray array];
        NSMutableArray *originImageArray = [NSMutableArray array];
        NSMutableArray *compressionImageArray = [NSMutableArray array];
        NSMutableArray *fullResolutionImageArray = [NSMutableArray array];
        for (LGPhotoAssets *photo in assets)
        {
            //缩略图
            [thumbImageArray addObject:photo.thumbImage];
            //原图
            [originImageArray addObject:photo.originImage];
            //全屏图
            [fullResolutionImageArray addObject:photo.fullResolutionImage];
            //压缩图片
            [compressionImageArray addObject:photo.compressionImage];
        }
        self.AlbumArray(originImageArray);
    };
    self.showType = style;
    [pickerVc showPickerVc:[self getCurrentVC]];
}

/**
 *  初始化自定义相机（单拍）
 */
- (void)presentCameraSingle
{
    ZLCameraViewController *cameraVC = [[ZLCameraViewController alloc] init];
    // 拍照最多个数
    cameraVC.maxCount = 1;
    // 单拍
    cameraVC.cameraType = ZLCameraSingle;
    cameraVC.callback = ^(NSArray *cameras)
    {
        ZLCamera *canamerPhoto = cameras[0];
        UIImage *image = canamerPhoto.photoImage;
        self.CameraImage(image);
    };
    [cameraVC showPickerVc:[self getCurrentVC]];
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    result = window.rootViewController;
    return result;
}

#pragma mark - LGPhotoPickerBrowserViewControllerDataSource

- (NSInteger)photoBrowser:(LGPhotoPickerBrowserViewController *)photoBrowser
   numberOfItemsInSection:(NSUInteger)section
{
    if (self.showType == LGShowImageTypeImageBroswer)
    {
        return self.LGPhotoPickerBrowserPhotoArray.count;
    }
    else if (self.showType == LGShowImageTypeImageURL)
    {
        return self.LGPhotoPickerBrowserURLArray.count;
    }
    else
    {
        NSLog(@"非法数据源");
        return 0;
    }
}

- (id<LGPhotoPickerBrowserPhoto>)photoBrowser:(LGPhotoPickerBrowserViewController *)pickerBrowser
                             photoAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType == LGShowImageTypeImageBroswer)
    {
        return [self.LGPhotoPickerBrowserPhotoArray objectAtIndex:indexPath.item];
    }
    else if (self.showType == LGShowImageTypeImageURL)
    {
        return [self.LGPhotoPickerBrowserURLArray objectAtIndex:indexPath.item];
    }
    else
    {
        NSLog(@"非法数据源");
        return nil;
    }
}


@end
