//
//  SRMaintainCheckingView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/17.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRMaintainCheckingView.h"
#import <CoreText/CoreText.h>
#import <pop/POP.h>

@interface SRMaintainCheckingView ()

@property (nonatomic, assign) CGFloat topPadding;
@property (nonatomic, assign) CGFloat leftPadding;

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *checkingColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *endColor;

@property (nonatomic, assign) CGPoint circleCenter;
@property (nonatomic, assign) CGRect rectBackround;


@property (nonatomic, weak) UILabel *labelTitle;
@property (nonatomic, weak) UILabel *labelDescription;
@property (nonatomic, weak) UILabel *labelResult;

@property (nonatomic, strong) UIImage *checkImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, assign) CGFloat progress;

@end

@implementation SRMaintainCheckingView
{
    BOOL isAnimationing;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultValue];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultValue];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self defaultValue];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    self.rectBackround = CGRectMake(self.circleCenter.x, self.topPadding, self.width-self.circleCenter.x, self.radius*2);
    
    /*  背景  */
    
    //矩形
    //填充颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //画笔颜色
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, self.lineWidth);
    //填充矩形
    CGContextFillRect(context, self.rectBackround);
    //画矩形边框
    CGContextAddRect(context, self.rectBackround);
    //执行绘画
    CGContextStrokePath(context);
    
    //扇形
    //填充颜色
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //画笔颜色
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, self.lineWidth);
    
    //顺时针画扇形
    CGContextMoveToPoint(context, self.circleCenter.x, self.circleCenter.y);
    CGContextAddArc(context,
                    self.circleCenter.x,
                    self.circleCenter.y,
                    self.radius,
                    -M_PI/2,
                    M_PI/2,
                    1);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    //底圆
    //画笔线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor disableColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //线的宽度
    CGContextSetLineWidth(context, self.lineWidth);
    //添加一个圆 x, y, radius, startAngle, endAngle, clockwise 0为顺时针，1为逆时针
    CGContextAddArc(context,
                    self.leftPadding+self.radius,
                    self.topPadding+self.radius,
                    self.radius,
                    0, 2*M_PI,
                    0);
    //绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);

    //画笔线的颜色
    CGContextSetStrokeColorWithColor(context, self.progress<1.0?[UIColor defaultColor].CGColor:self.endColor.CGColor);
    //线的宽度
    CGContextSetLineWidth(context, self.lineWidth);
    //添加一个圆 x, y, radius, startAngle, endAngle, clockwise 0为顺时针，1为逆时针
    CGContextAddArc(context,
                    self.leftPadding+self.radius,
                    self.topPadding+self.radius,
                    self.radius,
                    -M_PI/2,
                    -M_PI/2 + self.progress*2*M_PI,
                    0);
    //绘制路径
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *ic = self.checkImage;
    [ic drawAtPoint:CGPointMake(self.circleCenter.x-ic.size.width/2,
                                self.circleCenter.y-ic.size.height/2)];
    
    [self updateLabelResult];
//    [self updateLabelDescription];
    self.labelDescription.text = self.status;
}

#pragma mark - Public

- (void)startAnimation
{
    if (isAnimationing) {
        return;
    }
    
    isAnimationing = YES;
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.duration = self.duration;
    POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"progress" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            self.progress = values[0];
        };
    }];
    anim.property = prop;
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        [self pop_removeAllAnimations];
//        [self startFlip];
        self->isAnimationing = NO;
    };
    anim.fromValue = @(0.0f);
    anim.toValue = @(1.0f);
    
    [self pop_addAnimation:anim forKey:@"Animation"];
}

- (void)endAnimation
{
    [self pop_removeAllAnimations];
}

- (void)reset
{
    self.progress = 0.0f;
}



#pragma mark - 私有方法

- (void)startFlip
{
    POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationX];
    rotationAnimation.duration = 1.0;//默认的duration是0.4
    rotationAnimation.toValue = @(M_PI*2);
    //把这个animation加到topView的layer,key只是个识别符。
    [self.labelDescription.layer pop_addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)defaultValue
{
    self.leftPadding = 20.0f;
    self.radius = 25.0f * iPhoneScale;
    self.lineWidth = 1.0f;
    self.topPadding = (self.height - 2*self.radius)/2;
    self.circleCenter = CGPointMake(self.leftPadding + self.radius, self.height/2);
    self.rectBackround = CGRectMake(self.circleCenter.x, self.topPadding, self.width-self.circleCenter.x, self.radius*2);
    
    self.checkingColor = [UIColor defaultColor];
    self.lineColor = [UIColor colorWithRed:233.0f/256.0f green:233.0f/256.0f blue:233.0f/256.0f alpha:1.0];
    self.backgroundColor = [UIColor defaultBackgroundColor];
    
//    self.progress = .0f;
//    self.endColor = [UIColor warningColor];
    self.endColor = [UIColor defaultColor];
}

//- (void)updateLabelDescription
//{
//    NSString *str = [NSString stringWithFormat:@"%@\n%@", self.title, self.status];
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
//    
//    NSRange firstRange = [str rangeOfString:self.title];
//    NSRange secondRange = [str rangeOfString:self.status];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:firstRange];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15.0f] range:firstRange];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:secondRange];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:secondRange];
//    
//    self.labelDescription.attributedText = attributedString;
//}

- (void)updateLabelResult {
    if (self.progress == 0) {
        self.labelResult.backgroundColor = [UIColor disableColor];
        self.labelResult.text = @"未检测";
    } else if (self.progress < 1) {
        self.labelResult.backgroundColor = [UIColor defaultColor];
        self.labelResult.text = @"检测中";
    } else {
        self.labelResult.backgroundColor = self.isOK?[UIColor goodColor]:[UIColor warningColor];
        self.labelResult.text = self.isOK?@"良好":@"异常";
    }
}

#pragma mark - Setter

- (void)setIsOK:(BOOL)isOK
{
    _isOK = isOK;
//    self.endColor = isOK?[UIColor goodColor]:[UIColor warningColor];
    self.endColor = [UIColor defaultColor];
    [self setNeedsDisplay];
}

- (void)setType:(SRSystemType)type
{
    _type = type;
    self.labelTitle.text = self.title;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

#pragma mark - Getter

- (UILabel *)labelTitle
{
    if (_labelTitle) {
        return _labelTitle;
    }
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.font = [UIFont boldSystemFontOfSize:15.0f];
    [self addSubview:labelTitle];
    [labelTitle makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(5.0+self.topPadding);
        make.centerY.equalTo(self).with.offset(-10.0f);
        make.left.equalTo(self).with.offset(30.0f+self.radius*2);
        make.right.equalTo(self).with.offset(-90.0f);
        make.height.equalTo(20.0f);
    }];
    
    _labelTitle = labelTitle;
    
    return labelTitle;
    
}

- (UILabel *)labelDescription {
    if (_labelDescription) {
        return _labelDescription;
    }
    
    UILabel *labelDescription = [[UILabel alloc] initWithFrame:CGRectZero];
    labelDescription.textAlignment = NSTextAlignmentLeft;
    labelDescription.backgroundColor = [UIColor clearColor];
    labelDescription.textColor = [UIColor lightGrayColor];
    labelDescription.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:labelDescription];
    [labelDescription makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(5.0+self.topPadding);
        make.left.equalTo(self).with.offset(30.0f+self.radius*2);
        make.right.equalTo(self).with.offset(-70.0f);
        make.centerY.equalTo(self).with.offset(10.0f);
//        make.bottom.equalTo(self).with.offset(-5.0f-self.topPadding);
        make.height.equalTo(20.0f);
    }];
    
    _labelDescription = labelDescription;
    
    return labelDescription;
}

- (UILabel *)labelResult {
    if (_labelResult) {
        return _labelResult;
    }
    
    UILabel *labelResult = [[UILabel alloc] initWithFrame:CGRectZero];
    labelResult.textColor = [UIColor whiteColor];
    labelResult.textAlignment = NSTextAlignmentCenter;
    labelResult.font = [UIFont systemFontOfSize:12.0f];
    labelResult.layer.cornerRadius = 13.0f;
    labelResult.clipsToBounds = YES;
    [self addSubview:labelResult];
    [labelResult makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-20.0f);
        make.centerY.equalTo(self);
        make.size.equalTo(CGSizeMake(50.0f, 25.0f));
    }];
    
    _labelResult = labelResult;
    return labelResult;
}

- (UIImage *)checkImage
{
    if (_checkImage) {
        return _checkImage;
    }
    
    switch (self.type) {
        case SRSystemType_Engine_Transmission:
            _checkImage = [UIImage imageNamed:@"ic_sys_engine_transmission"];
            break;
        case SRSystemType_Chassis:
            _checkImage = [UIImage imageNamed:@"ic_sys_chassis"];
            break;
        case SRSystemType_Bodywork:
            _checkImage = [UIImage imageNamed:@"ic_sys_bodywork"];
            break;
        case SRSystemType_Network:
            _checkImage = [UIImage imageNamed:@"ic_sys_network"];
            break;
            
        default:
            break;
    }
    
    return _checkImage ;
}

- (NSString *)title {
    if (_title) {
        return _title;
    }
    
    switch (self.type) {
        case SRSystemType_Engine_Transmission:
            _title = @"引擎及变速箱";
            break;
        case SRSystemType_Chassis:
            _title = @"底盘控制系统";
            break;
        case SRSystemType_Bodywork:
            _title = @"车身控制系统";
            break;
        case SRSystemType_Network:
            _title = @"网络连接系统";
            break;
            
        default:
            break;
    }
    
    return _title;
}

- (NSString *)status {
    if (self.progress == 0) {
        return @"系统尚未检测，请先进行检测";
    } else if (self.progress < 1) {
        return @"检测中...";
    } else if (self.isOK) {
        return [NSString stringWithFormat:@"%@良好，请注意保持", self.title];
    } else {
        return @"系统异常，请联系专业人员检测";
    }
}

@end
