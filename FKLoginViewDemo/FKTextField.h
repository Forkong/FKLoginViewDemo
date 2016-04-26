//
//  FKTextField.h
//  FKTextField
//
//  Created by Fujun on 16/4/19.
//  Copyright © 2016年 Fujun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKTextField : UITextField

#pragma mark - Line
/**
 *  闲置状态线条颜色 默认为偏灰色
 */
@property (strong, nonatomic) UIColor *idleLineColor;

/**
 *  激活状态线条颜色 默认为偏红色
 */
@property (strong, nonatomic) UIColor *activeLineColor;

/**
 *  线条高度，默认为2个像素点
 */
@property (assign, nonatomic) CGFloat lineHeight;

/**
 *  线条闲置状态透明度 默认为1.0
 */
@property (assign, nonatomic) CGFloat idleLineAlpha;

/**
 *  线条激活状态透明度 默认为1.0
 */
@property (assign, nonatomic) CGFloat activeLineAlpha;

#pragma mark - PlaceHolder
/**
 *  默认等同于idleLineColor
 */
@property (strong, nonatomic) UIColor *idlePlaceHolderColor;

/**
 *  默认等同于activeLineColor
 */
@property (strong, nonatomic) UIColor *activePlaceHolderColor;

@property (strong, nonatomic) UIFont  *placeHolderFont;

#pragma mark - Animation
/**
 *  默认为0.3s
 */
@property (assign, nonatomic) CGFloat placeHolderAnimationDuration;
/**
 *  选中线颜色变淡的时间 默认0.8s
 */
@property (assign, nonatomic) CGFloat lineDismissDuration;

@end
