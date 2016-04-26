//
//  FKTextField.m
//  FKTextField
//
//  Created by Fujun on 16/4/19.
//  Copyright © 2016年 Fujun. All rights reserved.
//

#import "FKTextField.h"
#import <POP.h>

#define kDefaultIdleLineColor    [UIColor colorWithRed:231/255.0 green:224/255.0 blue:227/255.0 alpha:1.0f]
#define kDefaultActiveLineColor  [UIColor colorWithRed:251/255.0 green:62/255.0  blue:86/255.0  alpha:1.0f]
#define kSingleLineHeight        (1 / [UIScreen mainScreen].scale)

static CGFloat const kPlaceHolderLabelOffset         = 2.0f;
static CGFloat const kPlaceHolderLabelContractScale  = 0.7f;

@interface FKTextField ()
@property (strong, nonatomic) UIView  *lineView;
@property (strong, nonatomic) UIView  *animteLineView;

@property (strong, nonatomic) UILabel *placeHolderLabel;

@property (assign, nonatomic) CGPoint placeHolderDefaultCenter;
@end

@implementation FKTextField

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //默认配置
    self.idleLineColor = kDefaultIdleLineColor;
    self.activeLineColor = kDefaultActiveLineColor;
    
    self.lineHeight = kSingleLineHeight*2;
    
    self.idleLineAlpha = 1.0f;
    self.activeLineAlpha = 1.0f;
    
    self.placeHolderAnimationDuration = 0.3f;
    self.lineDismissDuration = 0.8f;
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UITextFieldTextDidBeginEditingNotification
     object:self
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * _Nonnull note) {
         {
             [self.placeHolderLabel pop_removeAllAnimations];
             
             POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
             positionAnimation.toValue =
             [NSValue valueWithCGPoint:CGPointMake(self.placeHolderDefaultCenter.x * kPlaceHolderLabelContractScale,
                                                   self.placeHolderLabel.frame.size.height)];
             positionAnimation.dynamicsTension = 10.f;
             positionAnimation.dynamicsFriction = 1.0f;
             positionAnimation.springBounciness = 12.0f;
             [self.placeHolderLabel pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
             
             POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
             scaleAnimation.toValue =
             [NSValue valueWithCGPoint:CGPointMake(kPlaceHolderLabelContractScale,
                                                   kPlaceHolderLabelContractScale)];
             scaleAnimation.dynamicsTension = 10.f;
             scaleAnimation.dynamicsFriction = 1.0f;
             scaleAnimation.springBounciness = 12.0f;
             [self.placeHolderLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
             
             POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
             colorAnimation.toValue = self.activePlaceHolderColor?:self.activeLineColor;
             colorAnimation.duration = self.placeHolderAnimationDuration;
             [self.placeHolderLabel pop_addAnimation:colorAnimation forKey:@"colorAnimation"];
         }
         
         {
             //从小到大
             [self.animteLineView pop_removeAllAnimations];
             
             self.animteLineView.alpha = 1.0f;
             
             POPSpringAnimation *frameAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
             frameAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(self.lineView.frame.size.width/2.,
                                                                            self.lineView.frame.origin.y,
                                                                            0,
                                                                            self.lineView.frame.size.height)];
             frameAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(self.lineView.frame.origin.x,
                                                                          self.lineView.frame.origin.y,
                                                                          self.lineView.frame.size.width,
                                                                          self.lineView.frame.size.height)];
             frameAnimation.dynamicsTension = 10.f;
             frameAnimation.dynamicsFriction = 1.0f;
             frameAnimation.springBounciness = 12.0f;
             [self.animteLineView pop_addAnimation:frameAnimation forKey:@"frameAnimation"];
         }
     }];
    
//    [[NSNotificationCenter defaultCenter]
//     addObserverForName:UITextFieldTextDidChangeNotification
//     object:self
//     queue:[NSOperationQueue mainQueue]
//     usingBlock:^(NSNotification * _Nonnull note) {
//         
//         
//     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UITextFieldTextDidEndEditingNotification
     object:self
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification * _Nonnull note) {
         {
             [self.placeHolderLabel pop_removeAllAnimations];
             
             POPBasicAnimation *colorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
             colorAnimation.toValue = self.idlePlaceHolderColor?:self.idleLineColor;
             colorAnimation.duration = self.placeHolderAnimationDuration;
             [self.placeHolderLabel pop_addAnimation:colorAnimation forKey:@"colorAnimation"];
             
             if (self.text.length == 0)
             {
                 POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
                 positionAnimation.toValue =
                 [NSValue valueWithCGPoint:self.placeHolderDefaultCenter];
                 positionAnimation.dynamicsTension = 10.f;
                 positionAnimation.dynamicsFriction = 1.0f;
                 positionAnimation.springBounciness = 12.0f;
                 [self.placeHolderLabel pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
                 
                 POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
                 scaleAnimation.toValue =
                 [NSValue valueWithCGPoint:CGPointMake(1,1)];
                 scaleAnimation.dynamicsTension = 10.f;
                 scaleAnimation.dynamicsFriction = 1.0f;
                 scaleAnimation.springBounciness = 12.0f;
                 [self.placeHolderLabel pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
             }
         }
         
         {
             [self.animteLineView pop_removeAllAnimations];
             
             POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
             alphaAnimation.toValue = @(0.0f);
             alphaAnimation.duration = self.lineDismissDuration;
             
             __weak typeof(self) weakSelf = self;
             alphaAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){
                 __strong typeof(weakSelf) strongSelf = self;
                 strongSelf.animteLineView.alpha = 0.0f;
             };
             [self.animteLineView pop_addAnimation:alphaAnimation forKey:@"alphaAnimation"];
         }
     }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [super setValue:@(YES) forKeyPath:@"_placeholderLabel.hidden"];
    
    [self addSubview:self.lineView];
    [self addSubview:self.animteLineView];

    self.lineView.frame = CGRectMake(0,
                                     self.frame.size.height - self.lineHeight,
                                     self.frame.size.width,
                                     self.lineHeight);
    self.lineView.alpha = self.idleLineAlpha;
    self.lineView.backgroundColor = self.idleLineColor;
    
    self.animteLineView.backgroundColor = self.activeLineColor;
    
    //将输入框固定于底部
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    //将输入框固定于底部
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [super drawPlaceholderInRect:rect];
    
    [self addSubview:self.placeHolderLabel];
    [self bringSubviewToFront:self.placeHolderLabel];
    
    self.placeHolderLabel.frame = CGRectMake(rect.origin.x,
                                             self.lineView.frame.size.height,
                                             rect.size.width,
                                             self.placeHolderFont.pointSize?:self.font.pointSize);
    
    self.placeHolderDefaultCenter = CGPointMake(self.placeHolderLabel.center.x,
                                                self.frame.size.height
                                                - self.lineHeight
                                                - (self.placeHolderFont.pointSize?:self.font.pointSize) / 2.
                                                - kPlaceHolderLabelOffset);
    
    self.placeHolderLabel.center = self.placeHolderDefaultCenter;
}

#pragma mark - setter and getter
- (UIView *)lineView
{
    if (!_lineView)
    {
        _lineView = [[UIView alloc] init];
    }
    return _lineView;
}

- (UIView *)animteLineView
{
    if (!_animteLineView)
    {
        _animteLineView = [[UIView alloc] init];
        _animteLineView.alpha = 1.0f;
    }
    return _animteLineView;
}

- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel)
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.font = self.placeHolderFont ?: self.font;
        _placeHolderLabel.text = self.placeholder;
        _placeHolderLabel.textColor = self.idlePlaceHolderColor?:self.idleLineColor;
        _placeHolderLabel.font = self.placeHolderFont;
    }
    return _placeHolderLabel;
}

- (void)setPlaceHolderFont:(UIFont *)placeHolderFont
{
    _placeHolderFont = placeHolderFont;
    self.placeHolderLabel.font = placeHolderFont;
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    if (_lineHeight == lineHeight)
    {
        return;
    }
    _lineHeight = lineHeight;
    CGRect lineViewFrame = self.lineView.frame;
    self.lineView.frame = CGRectMake(lineViewFrame.origin.x,
                                     self.frame.size.height - self.lineHeight,
                                     lineViewFrame.size.width,
                                     lineHeight);
}

@end
