//
//  ScanFacesViewController.m
//  人脸识别照相机
//
//  Created by 曹宇明 on 2019/3/1.
//  Copyright © 2019 kys-24. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScanFacesViewController.h"
#import "FaceContrastTool.h"
#import "UIImage+Clip.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ScanFacesViewController ()<AVCaptureMetadataOutputObjectsDelegate>
// 捕获会话
@property (nonatomic,strong)AVCaptureSession *session;
// 捕获视频流预览层
@property (nonatomic,strong)AVCaptureVideoPreviewLayer *preview;
// 存放人脸信息字典
@property (nonatomic,strong)NSMutableDictionary *layerDictionary;
// 照片输出流——>此处应该替换为最新的AVCapturePhotoOutput
@property (nonatomic,strong)AVCaptureStillImageOutput *imageOutput;
// 相机显示界面
@property (nonatomic,strong)UIView *cameraView;

@end

@implementation ScanFacesViewController
/**
 懒加载初始化数据字典

 @return 存放人脸信息字典
 */
-(NSMutableDictionary *)layerDictionary{
    if (!_layerDictionary) {
        _layerDictionary = [NSMutableDictionary new];
    }
    return _layerDictionary;
}

/**
 LifeCycle
 这里把事件全写在了viewWillAppear中
 @param animated animated description
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUI];
    [self startDataflow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 获取捕获视频设备->注意方法更新，为了版本向下兼容

 @return AVCaptureDevice
 */
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *deviceSelect = nil;
    NSUInteger cameraCounts = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCounts > 1) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if (device.position == AVCaptureDevicePositionFront) {
                deviceSelect = device;
            }
        }
    }
    return deviceSelect;
}

/**
 初始化变量并开始捕获视频流
 */
-(void)startDataflow{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        // 提示开启权限 //读取摄像头授权状态
        return;
    }
    NSError *error; // 错误指针
    // 获取捕获设备
    AVCaptureDevice *captureDevice = [self inactiveCamera];
    // 设置输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        // 设置错误提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // 设置输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置会话并添加输入输出
    _session = [[AVCaptureSession alloc] init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    if ([_session canAddInput:input]) {
        [_session addInput:input];
    }
    if ([_session canAddOutput:output]) {
        [_session addOutput:output];
    }
    // 初始化图片输出->注意方法更新，此处向下做版本兼容
    _imageOutput = [[AVCaptureStillImageOutput alloc] init];
    // 图片输出设置
    [_imageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecTypeJPEG}];
    // 将设备输出添加到会话中
    if ([_session canAddOutput:_imageOutput]) {
        [_session addOutput:_imageOutput];
    }
    // 设置输出流识别类型为人脸
    output.metadataObjectTypes = @[AVMetadataObjectTypeFace];
    // 获取主线程并把输出流加入到线程中
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    [output setMetadataObjectsDelegate:self queue:mainQueue];
    // 设置预览图层
    _preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [_preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_preview setFrame:self.cameraView.bounds];
    [UIView animateWithDuration:2 animations:^{
        [self.cameraView.layer addSublayer:self->_preview];
    }];
    // 开启会话
    [_session startRunning];
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSMutableArray *faceArray = [NSMutableArray arrayWithCapacity:10];
    for (AVMetadataFaceObject *face in metadataObjects) {
        //将摄像头捕捉的人脸位置转换到屏幕位置
        AVMetadataObject *tranformFace = [_preview  transformedMetadataObjectForMetadataObject:face];
        [faceArray addObject:tranformFace];
    }
    //将获取的人脸数据进行处理
    [self processDataWith:faceArray];
    
}
#pragma mark - PersonalFunc

/**
 处理人脸数据，添加方框

 @param faceArray 人脸数据
 */
-(void)processDataWith:(NSArray *)faceArray{
    
    if (self.layerDictionary.count<1) {
        CALayer *layer = [CALayer layer];
        for (AVMetadataFaceObject *face in faceArray) {
            layer = [self makeFaceLayer];
            NSNumber *faceID = @(face.faceID);
            [_preview addSublayer:layer];
            self.layerDictionary[faceID] = layer;
            layer.frame = face.bounds;
        }
    }else{
        NSMutableArray *leaveFaceArray = [self.layerDictionary.allKeys mutableCopy];
        for (AVMetadataFaceObject *face in faceArray) {
            NSNumber *faceID = @(face.faceID);
            [leaveFaceArray removeObject:faceID];
            CALayer *layer = self.layerDictionary[faceID];
            if(!layer){
                [_preview addSublayer:layer];
                self.layerDictionary[faceID] = layer;
            }
            layer.frame = face.bounds;
        }
        for (NSNumber *faceID in leaveFaceArray) {
            CALayer *layer = self.layerDictionary[faceID];
            [layer removeFromSuperlayer];
            [self.layerDictionary removeObjectForKey:faceID];
        }
    }
}

/**
 返回方法

 @param sender 返回按钮
 */
- (void)backBtnOnClick:(UIButton *)sender{
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 拍照方法

 @param sender 拍照按钮
 */
- (void)captureBtnOnClick:(UIButton *)sender
{
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    //根据连接取得设备输出的数据
    [_imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            if([self faceDetectWithImage:image]){
                if (self.scanFaceType == ScanFaceTypeRegist) {
                    // 设置弹窗
                    UIAlertController *alert = [self setImageAlertControllerWithImage:image];
                    // 设置按钮并添加事件
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"重拍" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        // 将图片保存到本地
                        [FaceContrastTool saveUserPicture:image];
                        // 向外回调
                        !self.imageBlock?:self.imageBlock(image);
                        // 停止会话
                        [self->_session stopRunning];
                        // 返回界面
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    // 直接将图片返回
                    !self.imageBlock?:self.imageBlock(image);
                    // 停止会话
                    [self->_session stopRunning];
                    // 返回界面
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前照片中未检测到人脸，请重新拍照！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}

/**
 打开预览图片的方法

 @param sender 按钮
 */
- (void)previewBtnOnClick:(UIButton *)sender{
    if ([FaceContrastTool showUserPicture]) {
        UIAlertController *alert = [self setImageAlertControllerWithImage:[FaceContrastTool showUserPicture]];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 判断是否存在人脸

 @param image 需要检测的UIImage
 @return BOOL
 */
- (BOOL)faceDetectWithImage:(UIImage *)image {
    // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择
    NSDictionary *opts = [NSDictionary dictionaryWithObject:
                          CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    // 将图像转换为CIImage
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    if(features.count>0){
        return YES;
    }else{
        return NO;
    }
}

/**
 设置一个带UIImage的提示框

 @param image 需要展示的UIImage
 @return 提示框
 */
- (UIAlertController *)setImageAlertControllerWithImage:(UIImage *)image{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    CGFloat aWidth = 260;
    CGFloat aHeight = aWidth*SCREEN_HEIGHT/SCREEN_WIDTH;
    CGSize aSize = CGSizeMake(aWidth, aHeight);
    // 视图反转并缩小
    UIImage *img = [[image rotateWithOrientation:UIImageOrientationLeftMirrored] thumWithSize:aSize];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(5, 10, aWidth, aHeight);
    [alertCtr.view addSubview:imageView];
    return alertCtr;
}
/**
 设置红色检测框

 @return CALayer
 */
- (CALayer *)makeFaceLayer{
    CALayer *layer = [CALayer layer];
    layer.borderWidth = 2.0f;
    layer.borderColor = [UIColor redColor].CGColor;
    return layer;
}

/**
 界面UI
 */
- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat cWidth = self.view.frame.size.width;
    CGFloat cHeight = self.view.frame.size.height;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, 39, 39);
    imageView.center = CGPointMake(cWidth*0.5, cHeight*0.05+15);
    imageView.image = [UIImage imageNamed:@"face_icon"];
    [self.view addSubview:imageView];
    UILabel *imageLabel = [[UILabel alloc]init];
    imageLabel.frame = CGRectMake(0, 0, 60, 20);
    imageLabel.center = CGPointMake(cWidth*0.5, cHeight*0.05+50);
    imageLabel.text = @"人脸检测";
    imageLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:imageLabel];
    
    // 相机视图
    _cameraView = [UIView new];
    _cameraView.frame = CGRectMake(0, cHeight*0.15, cWidth, cHeight*0.65);
    [self.view addSubview:_cameraView];
    
    // 返回按钮
    UIButton *backBtn = [UIButton new];
    backBtn.frame = CGRectMake(0, 0, cWidth*0.25, cWidth*0.25);
    backBtn.center = CGPointMake(cWidth*0.25, cHeight*0.9);
    backBtn.layer.cornerRadius = cWidth*0.125;
    [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 拍照按钮
    UIButton *captureBtn = [UIButton new];
    captureBtn.frame = CGRectMake(0, 0, cWidth*0.25, cWidth*0.25);
    captureBtn.center = CGPointMake(cWidth*0.5, cHeight*0.9);
    [captureBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    captureBtn.layer.cornerRadius = cWidth*0.125;
    [self.view addSubview:captureBtn];
    [captureBtn addTarget:self action:@selector(captureBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    // 预览按钮
    UIButton *photoBtn = [UIButton new];
    photoBtn.frame = CGRectMake(0, 0, cWidth*0.25, cWidth*0.25);
    photoBtn.center = CGPointMake(cWidth*0.75, cHeight*0.9);
    photoBtn.layer.cornerRadius = cWidth*0.125;
    [photoBtn setImage:[UIImage imageNamed:@"photo_icon"] forState:UIControlStateNormal];
    [self.view addSubview:photoBtn];
    [photoBtn addTarget:self action:@selector(previewBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
}
@end
