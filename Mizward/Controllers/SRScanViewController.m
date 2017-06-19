//
//  SRScanViewController.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRScanViewController.h"
#import "SRPortal+Regist.h"
#import "SRPortal+Login.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRPortalResponse.h"
#import "SRVehicleInfo.h"
#import <pop/POP.h>
#import <AVFoundation/AVFoundation.h>

@interface SRScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ic_border;
@property (weak, nonatomic) IBOutlet UIImageView *ic_line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ic_line_top;
@property (weak, nonatomic) IBOutlet UILabel *lb_scan;
@property (weak, nonatomic) IBOutlet UILabel *lb_register;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;

@end

@implementation SRScanViewController
{
    SRScanViewControllerType vcType;
    BOOL isParserScanResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.type) {
        vcType = self.type.integerValue;
    }
    
    self.title = @"扫一扫";
    
    self.lb_scan.backgroundColor = RGBAlpaColor(0, 0, 0, 0.4);
    self.lb_scan.layer.cornerRadius = 2.0f;
    self.lb_scan.clipsToBounds = YES;
    
    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startScanAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
    [self.ic_line pop_removeAllAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0 && !isParserScanResult) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        if (metadataObject.stringValue.length>0) {
            //输出扫描字符串
            SRLogDebug(@"%@", metadataObject.stringValue);
            [self parserScanResult:metadataObject.stringValue];
        }
        
    }
}

#pragma mark - Getter

- (AVCaptureDevice *)device
{
    if (_device) {
        return _device;
    }
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _device = device;
    
    return _device;
}

- (AVCaptureSession *)session
{
    if (_session) {
        return _session;
    }
    
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    //设置扫描的范围
    CGSize size = self.view.bounds.size;
    CGRect cropRect = self.ic_border.frame;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.; //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                            cropRect.origin.x/size.width,
                                            cropRect.size.height/fixHeight,
                                            cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                            (cropRect.origin.x + fixPadding)/fixWidth,
                                            cropRect.size.height/size.height,
                                            cropRect.size.width/fixWidth);
    }
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    _session = session;
    
    return _session;
}

#pragma mark - 私有方法

- (void)addViews
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.ic_border.mas_top);
    }];
    [self.view sendSubviewToBack:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:bottomView];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.ic_border.mas_bottom);
    }];
    [self.view sendSubviewToBack:bottomView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectZero];
    leftView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:leftView];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.ic_border.mas_top);
        make.bottom.equalTo(self.ic_border.mas_bottom);
        make.right.equalTo(self.ic_border.mas_left);
    }];
    [self.view sendSubviewToBack:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectZero];
    rightView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:rightView];
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.top.equalTo(self.ic_border.mas_top);
        make.bottom.equalTo(self.ic_border.mas_bottom);
        make.left.equalTo(self.ic_border.mas_right);
    }];
    [self.view sendSubviewToBack:rightView];
    
}

- (void)startScanAnimation {
    POPBasicAnimation *position = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    position.toValue = @(self.ic_border.bottom);
    position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    position.duration = 3.0;
    position.repeatForever = YES;
    [self.ic_line.layer pop_addAnimation:position forKey:@"position"];
}

- (void)parserScanResult:(NSString *)result
{
    
    isParserScanResult = YES;

    if (vcType == SRScanViewControllerType_Visitor && [result hasPrefix:@"exhibition"]) {
        //登陆
        NSArray *array = [result componentsSeparatedByString:@"_"];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:array[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSArray *infoArray = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] componentsSeparatedByString:@"_"];
        
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestExhibitionLogin *request = [[SRPortalRequestExhibitionLogin alloc] init];
        request.userName = infoArray[0];
        request.passWord = infoArray[1];
        request.qrCodeID = infoArray[2];
        [SRPortal exhibitionLoginWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseLogin *responseObject) {
            [SRUIUtil dissmissLoadingHUD];
            if (error) {
                [SRUIUtil showAlertWithTitle:@"提示" message:error.domain doneButton:@"确定" andDoneBlock:^{
                    self->isParserScanResult = NO;
                }];
            } else {
                [self.session stopRunning];
                if ([responseObject.updateVersion compare:CurrentAPPVersion]!=NSOrderedDescending
                    || !responseObject.needUpdate) {
                    [SRUIUtil DissmissSRLoginViewControllerPopToRoot];
                }
            }
        }];
    } else if (vcType == SRScanViewControllerType_Terminal) {
        //绑定
        [SRUIUtil showLoadingHUDWithTitle:nil];
        SRPortalRequestValidateIMEI *request = [[SRPortalRequestValidateIMEI alloc] init];
        request.imei = result;
        @weakify(self)
        [SRPortal validateIMEIWithRequest:request andCompleteBlock:^(NSError *error, SRPortalResponseValideIMEI *info) {
            [SRUIUtil dissmissLoadingHUD];
            @strongify(self)
            if (error) {
                [SRUIUtil showAlertWithTitle:@"提示" message:error.domain doneButton:@"确定" andDoneBlock:^{
                    self->isParserScanResult = NO;
                }];
            } else {
                [self.session stopRunning];
                
                SRVehicleInfo *vehicleInfo = [[SRVehicleInfo alloc] init];
                vehicleInfo.vehicleName = info.vmname;
                vehicleInfo.vehicleModelID = info.vmid;
                
                if (self.delegate) {
                    [self.delegate scanResult:result withVehicleInfo:vehicleInfo];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        isParserScanResult = NO;
    }
}

@end
