//
//  OneViewController.m
//  AOP_Demo
//
//  Created by muxinjian on 2018/6/2.
//  Copyright © 2018年 muxinjian. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@property (weak, nonatomic) IBOutlet UIView *alert;

@end

@implementation OneViewController

+ (void)initialize {
    [super initialize];
    [NSObject setupOneLogging];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //打点
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //打点
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"组件一";
    
    if (arc4random() % 2 == 1) {
        [self alertShow];
    } else {
        [self alertHidden];
    }
    
}

#pragma mark - private SEL
- (void)alertShow {
    self.alert.hidden = NO;
    //打点
}

- (void)alertHidden {
    self.alert.hidden = YES;
}

- (void)switchOn {
    //xxxxx
    //打点
    
}

- (void)switchOff {
    //xxxxx
    //打点
    
}

#pragma mark - actions

- (IBAction)switchTouched:(id)sender {
    //打点
    UISwitch *testSwitch = (UISwitch *)sender;
    if (testSwitch.on) {
        [self switchOn];
    } else {
        [self switchOff];
    }

}


- (IBAction)blueTouched:(id)sender {
    self.view.backgroundColor = [UIColor blueColor];
    //打点

}
- (IBAction)redTouched:(id)sender {
    self.view.backgroundColor = [UIColor redColor];
    //打点

}
- (IBAction)brownTouched:(id)sender {
    self.view.backgroundColor = [UIColor brownColor];
    //打点

}

- (IBAction)moduleTwoTouched:(id)sender {
    //打点
    UIViewController *vc = [[ModuleRouter sharedInstance] viewControllerWithContentText:@"Module_One"];
    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)moduleThreeTouched:(id)sender {
    //打点
    UIViewController *vc = [[ModuleRouter sharedInstance] viewController];
    [self.navigationController pushViewController:vc animated:YES];

}

@end
