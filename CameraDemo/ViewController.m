//
//  ViewController.m
//  CameraDemo
//
//  Created by kevin gao on 2017-10-05.
//  Copyright © 2017 Kevin Gao. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

AVCaptureSession *_avCaptureSession;
AVCaptureDevice *_videoDevice;
AVCaptureVideoPreviewLayer *previewLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _avCaptureSession = [[AVCaptureSession alloc] init];
    [_avCaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_videoDevice error:&error];
    
    if([_avCaptureSession canAddInput:deviceInput]) {
        [_avCaptureSession addInput:deviceInput];
    }
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_avCaptureSession];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity: AVLayerVideoGravityResizeAspect];
    CALayer *rootLayer = [self.view layer];
    [rootLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = [self.view bounds];
    [previewLayer setFrame:frame];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [_avCaptureSession startRunning];
}

- (void)viewWillLayoutSubviews {
    previewLayer.frame = self.view.bounds;
    if (previewLayer.connection.supportsVideoOrientation) {
        previewLayer.connection.videoOrientation = [self interfaceOrientationToVideoOrientation:[UIApplication sharedApplication].statusBarOrientation];
    }
}

- (AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        default:
            break;
    }
    return AVCaptureVideoOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
