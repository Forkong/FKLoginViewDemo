//
//  ViewController.m
//  FKLoginViewDemo
//
//  Created by Fujun on 16/4/26.
//  Copyright © 2016年 Fujun. All rights reserved.
//

#import "ViewController.h"
#import "FKTextField.h"
#import "FKLoadingButton.h"

@interface ViewController ()
@property (strong, nonatomic) FKTextField *textField;
@property (strong, nonatomic) FKLoadingButton *loadingButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[FKTextField alloc] initWithFrame:CGRectMake(30, 60, self.view.frame.size.width-30*2, 60)];
    self.textField.placeholder = @"测试placeholder";
    [self.view addSubview:self.textField];
    
    
    FKTextField *ptextField = [[FKTextField alloc] initWithFrame:CGRectMake(30, 150, self.view.frame.size.width-30*2, 30)];
    ptextField.placeholder = @"密码";
    ptextField.placeHolderFont = [UIFont systemFontOfSize:10.0f];
    ptextField.secureTextEntry = YES;
    [self.view addSubview:ptextField];
    
    self.loadingButton = [[FKLoadingButton alloc]
                          initWithFrame:CGRectMake(ptextField.frame.origin.x,
                                                   ptextField.frame.origin.y+ptextField.frame.size.height+60,
                                                   ptextField.frame.size.width,
                                                   60)];
    self.loadingButton.loadingImage = [UIImage imageNamed:@"1"];
    [self.loadingButton setBackgroundColor:[UIColor redColor]];
    [self.loadingButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
    self.loadingButton.layer.cornerRadius = 6.0f;
    self.loadingButton.layer.masksToBounds = YES;
    [self.view addSubview:self.loadingButton];
    
    [self.loadingButton addTarget:self
                           action:@selector(doSomething)
                 forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [self.view addGestureRecognizer:tap];
}

- (void)doSomething
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingButton stop];
    });
}

- (void)endEdit
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
