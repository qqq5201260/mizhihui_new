//
//  SRTirePressureAdjustViewController.m
//  
//
//  Created by zhangjunbo on 15/11/23.
//
//

#import "SRTirePressureAdjustViewController.h"
#import <pop/POP.h>

@interface SRTirePressureAdjustViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lb_wheel;
@property (weak, nonatomic) IBOutlet UILabel *lb_message;
@property (weak, nonatomic) IBOutlet UIImageView *imageAnimation;

@property (weak, nonatomic) IBOutlet UIImageView *wheel_lf;
@property (weak, nonatomic) IBOutlet UIImageView *wheel_rf;
@property (weak, nonatomic) IBOutlet UIImageView *wheel_lb;
@property (weak, nonatomic) IBOutlet UIImageView *wheel_rb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lf_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint_lf_bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;

@end

@implementation SRTirePressureAdjustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"校准";
    
    self.constraint_lf_trailing.constant *= iPhoneScale;
    self.constraint_lf_bottom.constant *= iPhoneScale;
    self.constraintLeading.constant *= iPhoneScale;
    self.constraintTop.constant *= iPhoneScale;
    
    if (iPhone6Plus) {
        self.constraint_lf_trailing.constant -= 5.0f;
        self.constraint_lf_bottom.constant -= 5.0f;
    }
    
    self.lb_wheel.layer.borderColor = [UIColor defaultNavBarTintColor].CGColor;
    self.lb_wheel.layer.borderWidth = 1.0f;
    self.lb_wheel.layer.masksToBounds = YES;
    self.lb_wheel.layer.cornerRadius = 5.0f;
    
    self.lb_message.layer.borderColor = [UIColor defaultNavBarTintColor].CGColor;
    self.lb_message.layer.borderWidth = 1.0f;
    self.lb_message.layer.masksToBounds = YES;
    self.lb_message.layer.cornerRadius = 5.0f;
    
    [self.wheel_lf bk_whenTapped:^{
        [self startAnimation];
    }];
    
    [self.wheel_rf bk_whenTapped:^{
        [self startAnimation];
    }];
    
    [self.wheel_lb bk_whenTapped:^{
        [self startAnimation];
    }];
    
    [self.wheel_rb bk_whenTapped:^{
        [self startAnimation];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Private

- (void)startAnimation {
    POPBasicAnimation *rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.toValue = @(degreesToRadian(360));
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.duration = 1;
    rotation.repeatForever = YES;
    [self.imageAnimation.layer pop_addAnimation:rotation forKey:@"rotation"];
}



@end
