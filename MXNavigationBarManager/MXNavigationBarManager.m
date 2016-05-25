//
//  MXNavigationBarManager.m
//  MXBarManagerDemo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 desn. All rights reserved.
//

#import "MXNavigationBarManager.h"

static const CGFloat kNavigationBarHeight = 64.0f;
static const CGFloat kDefaultFullOffset   = 200.0f;
static const float   kMaxAlphaValue       = 1.0f;
static const float   kMinAlphaValue       = 0.0f;

#define SCREEN_RECT [UIScreen mainScreen].bounds
#define BACKGROUNDVIEW_FRAME CGRectMake(0, -20, CGRectGetWidth(SCREEN_RECT), kNavigationBarHeight)

@interface MXNavigationBarManager ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UINavigationBar *selfNavigationBar;

@end

@implementation MXNavigationBarManager

+ (MXNavigationBarManager *)sharedManager {
    static MXNavigationBarManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXNavigationBarManager alloc] init];
        [self initBaseData:manager];
    });
    return manager;
}


+ (void)setBarColor:(UIColor *)color {
    [self sharedManager].backgroundImageView.backgroundColor = color;
}

+ (void)setBackgroundImage:(UIImage *)image {
    [self sharedManager].backgroundImageView.image = image;
}

+ (void)setFullAlphaOffset:(float)offset {
    [self sharedManager].fullAlphaOffset = offset;
}

+ (void)setZeroAlphaOffset:(float)offset {
    [self sharedManager].zeroAlphaOffset = offset;
}

+ (void)setMaxAlphaValue:(float)value {
    [self sharedManager].maxAlphaValue = value;
}

+ (void)setMinAlphaValue:(float)value {
    [self sharedManager].minAlphaValue = value;
}

+ (void)setZeroAlphaTintColor:(UIColor *)color {
    [self sharedManager].zeroAlphaTintColor = color;
    [self sharedManager].selfNavigationBar.tintColor = color;
    [self setTitleColorWithColor:color];
}

+ (void)setFullAlphaTintColor:(UIColor *)color {
    [self sharedManager].fullAlphaTintColor = color;
}

+ (void)setZeroAlphaBarStyle:(UIStatusBarStyle)style {
    [self sharedManager].zeroAlphaBarStyle = style;
}

+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset {
    MXNavigationBarManager *manager = [self sharedManager];
    float currentAlpha = (currentOffset - manager.zeroAlphaOffset) / (float)(manager.fullAlphaOffset - manager.zeroAlphaOffset);
    currentAlpha = currentAlpha < manager.minAlphaValue ? manager.minAlphaValue : (currentAlpha > manager.maxAlphaValue ? manager.maxAlphaValue : currentAlpha);
    [self sharedManager].backgroundImageView.alpha = currentAlpha;
    
    if (currentAlpha >= manager.maxAlphaValue && manager.fullAlphaTintColor != nil) {
        if (manager.zeroAlphaTintColor == nil) {
            manager.zeroAlphaTintColor = manager.selfNavigationBar.tintColor;
        }
        manager.selfNavigationBar.tintColor = manager.fullAlphaTintColor;
        [self setTitleColorWithColor:manager.fullAlphaTintColor];
        [self setStatusBarStyle:[self styleForFullAlpha:manager]];
    } else if (manager.zeroAlphaTintColor != nil) {
        manager.selfNavigationBar.tintColor = manager.zeroAlphaTintColor;
        [self setTitleColorWithColor:manager.zeroAlphaTintColor];
        [self setStatusBarStyle:manager.zeroAlphaBarStyle];
    }
}

#pragma mark - private method
+ (void)initBaseData:(MXNavigationBarManager *)manager {
    manager.backgroundImageView = [[UIImageView alloc] initWithFrame:BACKGROUNDVIEW_FRAME];
    manager.backgroundImageView.backgroundColor = [UIColor whiteColor];
    manager.maxAlphaValue = kMaxAlphaValue;
    manager.minAlphaValue = kMinAlphaValue;
    manager.fullAlphaOffset = kDefaultFullOffset;
    manager.zeroAlphaOffset = 0;
}

+ (void)managerWithController:(UIViewController *)viewController {
    [self replaceSystemNavigationBarImageView:viewController.navigationController.navigationBar];
}

+ (void)replaceSystemNavigationBarImageView:(UINavigationBar *)navigationBar {
    [navigationBar.subviews.firstObject removeFromSuperview];
    [navigationBar addSubview:[self sharedManager].backgroundImageView];
    [navigationBar sendSubviewToBack:[self sharedManager].backgroundImageView];
    [self sharedManager].selfNavigationBar = navigationBar;
}

+ (void)setTitleColorWithColor:(UIColor *)color {
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionaryWithDictionary:[self sharedManager].selfNavigationBar.titleTextAttributes];
    [textAttr setObject:color forKey:NSForegroundColorAttributeName];
    [self sharedManager].selfNavigationBar.titleTextAttributes = textAttr;
}

+ (void)setStatusBarStyle:(UIStatusBarStyle)style {
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

+ (UIStatusBarStyle)styleForFullAlpha:(MXNavigationBarManager *)manager {
    return manager.zeroAlphaBarStyle == UIStatusBarStyleDefault ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

@end
