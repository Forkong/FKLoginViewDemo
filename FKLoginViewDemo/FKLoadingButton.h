//
//  FKLoadingButton.h
//  FKTextField
//
//  Created by Fujun on 16/4/25.
//  Copyright © 2016年 Fujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKLoadingButton : UIButton
@property (strong, nonatomic) UIImage *loadingImage;
/**
 *  动画时间，默认为1.0f
 */
@property (assign, nonatomic) CGFloat animationDuration;

/**
 *  是否点击Button后开始动画，默认为YES
 */
@property (assign, nonatomic) BOOL    startWhenTouchEvent;
/**
 *  停止时回到初始状态 默认为YES
 */
@property (assign, nonatomic) BOOL    stopToOriginal;

- (void)start;

- (void)stop;

@end
