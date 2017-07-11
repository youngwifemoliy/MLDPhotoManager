# MLDPhotoManager

---
20170628更新说明:更新了api增加了最大张数的参数



---
>基于@gang544043963大神的[LGPhotoBrowser](https://github.com/gang544043963/LGPhotoBrowser)项目再次封装的

![1](http://onazihscc.bkt.clouddn.com/WechatIMG125.png
)![1](http://onazihscc.bkt.clouddn.com/WechatIMG123.png
)![1](http://onazihscc.bkt.clouddn.com/WechatIMG124.png
)

#### 项目初衷
本身[LGPhotoBrowser](https://github.com/gang544043963/LGPhotoBrowser)已经很是完美了,完成了很多我们的需求,但是在我的项目中会多次出现AlertController让用户选择相机还是相册这种需求实例.在这个基础上想到了再次封装.

#### 用法
只需要将`MLDPhotoManager`拖入项目中即可

```obj-c
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
```
基于Block方便管理

#### 说明

```obj-c
+ (void)showPhotoManager:(UIView *)carryView
       withMaxImageCount:(NSInteger)maxCount
         withCameraImage:(void(^)(UIImage *cameraImage))cameraImage
          withAlbumArray:(void(^)(NSArray *albumArray))albumArray
```
其中`(UIView *)carryView`这个参数要说明一下.
方法是直接呼出了`UIAlertController`但是在 *iPad* 中`UIAlertController`不能自下而上的直接弹出,需要一个停靠的`View`所以需要告诉控制器是哪个`View`响应了这个`UIAlertController`.

eg:你是按了一个 *Button* 想呼出`UIAlertController`那么这个 *Button* 就是 *carryView*

#### 注意
[LGPhotoBrowser](https://github.com/gang544043963/LGPhotoBrowser)项目已经集成了[DACircularProgress](https://github.com/danielamitay/DACircularProgress) [SDWebImage](https://github.com/rs/SDWebImage)如果项目中有这两个库的童鞋可以删除.
位置 *LGPhotoBrowser-->Classes-->Third*

本项目应用于iOS 9+

#### 再次鸣谢
再次鸣谢@gang544043963大神的[LGPhotoBrowser](https://github.com/gang544043963/LGPhotoBrowser)项目,从这个项目中学习到了很多东西.👍👍👍


#### 在这里找到我
E-Mail: youngwifemoliy@live.cn

Weibo: [@MoliySDev](http://weibo.com/moliy)
