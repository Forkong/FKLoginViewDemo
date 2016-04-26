//
//  FKLoadingButton.m
//  FKTextField
//
//  Created by Fujun on 16/4/25.
//  Copyright © 2016年 Fujun. All rights reserved.
//

#import "FKLoadingButton.h"
#import <pop/POP.h>
#import <JRSwizzle.h>

static CGFloat const kAnimationDuration = 1.0f;

@interface FKLoadingButton ()
@property (strong, nonatomic) UIImageView *loadingImageView;
@property (strong, nonatomic) UIView      *maskView;
@property (assign, nonatomic) BOOL        isNeedStop;
@property (assign, nonatomic) BOOL        isAnimating;
@end

@implementation FKLoadingButton

+ (void)load
{
    NSError *error;
    [self jr_swizzleMethod:@selector(setBackgroundColor:)
                withMethod:@selector(fk_setBackgroundColor:)
                     error:&error];
    
    [self jr_swizzleMethod:@selector(sendAction:to:forEvent:)
                withMethod:@selector(fk_sendAction:to:forEvent:)
                     error:&error];
}

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
    self.isNeedStop = NO;
    self.isAnimating = NO;
    self.startWhenTouchEvent = YES;
    
    self.animationDuration = kAnimationDuration;
    
    self.loadingImageView.frame = self.bounds;
    [self addSubview:self.loadingImageView];
    
    self.maskView.frame = self.bounds;
    [self addSubview:self.maskView];
}

- (void)start
{
    if (self.isAnimating)
    {
        return;
    }
    
    self.userInteractionEnabled = NO;
    self.isNeedStop = NO;
    [self startAnimation];
}

- (void)stop
{
    self.isNeedStop = YES;
    self.isAnimating = NO;
}

- (void)startAnimation
{
    [self.maskView pop_removeAllAnimations];
    
    if (self.isNeedStop)
    {
        self.userInteractionEnabled = YES;
        if (self.stopToOriginal)
        {
            self.maskView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
            self.maskView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        }
        return;
    }
    
    self.isAnimating = YES;
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    animation.duration = self.animationDuration;

    if (self.maskView.frame.size.width == self.bounds.size.width)
    {
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(self.bounds.size.width,
                                                                0,
                                                                0,
                                                                self.bounds.size.height)];
        animation.completionBlock = ^(POPAnimation *ani, BOOL state){
            self.maskView.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
            [self startAnimation];
        };
    }
    else if (self.maskView.frame.origin.x == 0)
    {
        animation.toValue = [NSValue valueWithCGRect:self.bounds];
        animation.completionBlock = ^(POPAnimation *ani, BOOL state){
            [self startAnimation];
        };
    }
    animation.removedOnCompletion = YES;
    [self.maskView pop_addAnimation:animation forKey:@"frameAnimation"];
}

#pragma mark - setter and getter
- (UIImageView *)loadingImageView
{
    if (!_loadingImageView)
    {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.userInteractionEnabled = NO;
        _loadingImageView.backgroundColor = [UIColor clearColor];
    }
    return _loadingImageView;
}

- (UIView *)maskView
{
    if (!_maskView)
    {
        _maskView = [[UIView alloc] init];
        _maskView.userInteractionEnabled = NO;
    }
    return _maskView;
}

- (void)setLoadingImage:(UIImage *)loadingImage
{
    _loadingImage = loadingImage;
    self.loadingImageView.image = loadingImage;
}

- (void)fk_setBackgroundColor:(UIColor *)color
{
    self.maskView.backgroundColor = color;
    [self fk_setBackgroundColor:color];
}

- (void)fk_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    if (self.startWhenTouchEvent)
    {
        [self start];
    }
    [self fk_sendAction:action to:target forEvent:event];
}

@end
