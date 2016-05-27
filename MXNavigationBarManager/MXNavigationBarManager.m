//
//  MXNavigationBarManager.m
//  MXBarManagerDemo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 desn. All rights reserved.
//

#import "MXNavigationBarManager.h"

static const CGFloat kNavigationBarHeight  = 64.0f;
static const CGFloat kDefaultFullOffset    = 200.0f;
static const float   kMaxAlphaValue        = 1.0f;
static const float   kMinAlphaValue        = 0.0f;
static const float   kDefaultAnimationTime = 0.35f;
static const float   KdefaultDelayTime     = 0.1f;

#define SCREEN_RECT [UIScreen mainScreen].bounds
#define BACKGROUNDVIEW_FRAME CGRectMake(0, -20, CGRectGetWidth(SCREEN_RECT), kNavigationBarHeight)

@interface MXNavigationBarManager ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UINavigationBar *selfNavigationBar;
@property (nonatomic, strong) UINavigationItem *selfNavigationItem;

@property (nonatomic, strong) UIImageView *saveImage;
@property (nonatomic, strong) UIColor *saveTintColor;
@property (nonatomic, strong) NSDictionary *saveTitleAttribute;
@property (nonatomic, assign) UIStatusBarStyle saveBarStyle;

@property (nonatomic, assign) BOOL setFull;
@property (nonatomic, assign) BOOL setZero;
@property (nonatomic, assign) BOOL setChange;

@end

@implementation MXNavigationBarManager

#pragma mark - property set
+ (void)setBarColor:(UIColor *)color {
    [self sharedManager].barColor = color;
    [self sharedManager].backgroundImageView.backgroundColor = color;
}

+ (void)setTintColor:(UIColor *)color {
    [self sharedManager].tintColor = color;
    [self sharedManager].selfNavigationBar.tintColor = color;
    [self setTitleColorWithColor:color];
}

+ (void)setBackgroundImage:(UIImage *)image {
    [self sharedManager].backgroundImageView.image = image;
}

+ (void)setStatusBarStyle:(UIStatusBarStyle)style {
    [self sharedManager].statusBarStyle = style;
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

+ (void)setZeroAlphaOffset:(float)offset {
    [self sharedManager].zeroAlphaOffset = offset;
}

+ (void)setFullAlphaOffset:(float)offset {
    [self sharedManager].fullAlphaOffset = offset;
}

+ (void)setMinAlphaValue:(float)value {
    value = value < kMinAlphaValue ? kMinAlphaValue : value;
    [self sharedManager].minAlphaValue = value;
}

+ (void)setMaxAlphaValue:(float)value {
    value = value > kMaxAlphaValue ? kMaxAlphaValue : value;
    [self sharedManager].maxAlphaValue = value;
}

+ (void)setFullAlphaTintColor:(UIColor *)color {
    [self sharedManager].fullAlphaTintColor = color;
}

+ (void)setFullAlphaBarStyle:(UIStatusBarStyle)style {
    [self sharedManager].fullAlphaBarStyle = style;
}

+ (void)setAllChange:(BOOL)allChange {
    [self sharedManager].allChange = allChange;
}

+ (void)setReversal:(BOOL)reversal {
    [self sharedManager].reversal = reversal;
}

+ (void)setContinues:(BOOL)continues {
    [self sharedManager].continues = continues;
}

#pragma mark - Set NavigationItem
+ (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KdefaultDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sharedManager].selfNavigationItem.rightBarButtonItem = rightBarButtonItem;
    });
}

+ (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KdefaultDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sharedManager].selfNavigationItem.leftBarButtonItem = leftBarButtonItem;
    });
}

+ (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KdefaultDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sharedManager].selfNavigationItem.rightBarButtonItems = rightBarButtonItems;
    });
}

+ (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KdefaultDelayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sharedManager].selfNavigationItem.leftBarButtonItems = leftBarButtonItems;
    });
}

#pragma mark - Public Method
+ (void)managerWithController:(UIViewController *)viewController {
    [self replaceSystemNavigationBarImageView:viewController.navigationController.navigationBar];
    [self sharedManager].selfNavigationBar = viewController.navigationController.navigationBar;
    [self sharedManager].selfNavigationItem = viewController.navigationItem;
}

+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset {
    MXNavigationBarManager *manager = [self sharedManager];
    
    float currentAlpha = [self curretAlphaForOffset:currentOffset];
    
    if (![manager.barColor isEqual:[UIColor clearColor]]) {
        if (!manager.continues) {
            if (currentAlpha == manager.minAlphaValue) {
                [self setNavigationBarColorWithAlpha:manager.minAlphaValue];
            } else if (currentAlpha == manager.maxAlphaValue) {
                [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                    [self setNavigationBarColorWithAlpha:manager.maxAlphaValue];
                }];
                manager.setChange = YES;
            } else {
                if (manager.setChange) {
                    [UIView animateWithDuration:kDefaultAnimationTime animations:^{
                        [self setNavigationBarColorWithAlpha:manager.minAlphaValue];
                    }];
                    manager.setChange = NO;
                }
            }
        } else {
            [self setNavigationBarColorWithAlpha:currentAlpha];
        }
    }
    
    if (manager.allChange) [self changeTintColorWithOffset:currentAlpha];
}

+ (void)saveWithController:(UIViewController *)viewController {
    MXNavigationBarManager *manager = [self sharedManager];
    UINavigationBar *bar = viewController.navigationController.navigationBar;
    for (UIView *view in bar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && CGRectGetHeight(view.frame) == kNavigationBarHeight) {
            manager.saveImage = (UIImageView *)view;
        }
    }
    manager.saveTintColor = bar.tintColor;
    manager.saveTitleAttribute = bar.titleTextAttributes;
    manager.saveBarStyle = [UIApplication sharedApplication].statusBarStyle;
}

+ (void)reStoreWithZeroStatus {
    [self changeAlphaWithCurrentOffset:[self sharedManager].zeroAlphaOffset];
}

+ (void)reStoreWithFullStatus {
    [self changeAlphaWithCurrentOffset:[self sharedManager].fullAlphaOffset];
}

+ (void)reStore {
    MXNavigationBarManager *manager = [self sharedManager];
    for (UIView *view in manager.selfNavigationBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && CGRectGetHeight(view.frame) == kNavigationBarHeight) {
            [view removeFromSuperview];
            [manager.selfNavigationBar addSubview:manager.saveImage];
            [manager.selfNavigationBar sendSubviewToBack:manager.saveImage];
        }
    }
    manager.selfNavigationBar.tintColor = manager.saveTintColor;
    manager.selfNavigationBar.titleTextAttributes = manager.saveTitleAttribute;
    [[UIApplication sharedApplication] setStatusBarStyle:manager.saveBarStyle];
}

#pragma mark - calculation
+ (float)curretAlphaForOffset:(CGFloat)offset {
    MXNavigationBarManager *manager = [self sharedManager];
    float currentAlpha = (offset - manager.zeroAlphaOffset) / (float)(manager.fullAlphaOffset - manager.zeroAlphaOffset);
    currentAlpha = currentAlpha < manager.minAlphaValue ? manager.minAlphaValue : (currentAlpha > manager.maxAlphaValue ? manager.maxAlphaValue : currentAlpha);
    currentAlpha = manager.reversal ? manager.maxAlphaValue + manager.minAlphaValue - currentAlpha : currentAlpha;
    return currentAlpha;
}

+ (void)changeTintColorWithOffset:(float)currentAlpha {
    MXNavigationBarManager *manager = [self sharedManager];
    if (currentAlpha >= manager.maxAlphaValue && manager.fullAlphaTintColor != nil) {
        if (manager.setFull) {
            manager.setFull = NO;
            manager.setZero  = YES;
        } else {
            if (manager.reversal) {
                manager.setFull = YES;
            }
            return;
        }
        manager.selfNavigationBar.tintColor = manager.fullAlphaTintColor;
        [self setTitleColorWithColor:manager.fullAlphaTintColor];
        [self setUIStatusBarStyle:manager.fullAlphaBarStyle];
    } else if (manager.tintColor != nil) {
        if (manager.setZero) {
            manager.setZero = NO;
            manager.setFull = YES;
        } else {
            return;
        }
        manager.selfNavigationBar.tintColor = manager.tintColor;
        [self setTitleColorWithColor:manager.tintColor];
        [self setUIStatusBarStyle:manager.statusBarStyle];
    }
}

#pragma mark - private method
+ (MXNavigationBarManager *)sharedManager {
    static MXNavigationBarManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MXNavigationBarManager alloc] init];
        [self initBaseData:manager];
    });
    return manager;
}

+ (void)initBaseData:(MXNavigationBarManager *)manager {
    manager.backgroundImageView = [[UIImageView alloc] initWithFrame:BACKGROUNDVIEW_FRAME];
    manager.backgroundImageView.backgroundColor = [UIColor whiteColor];
    manager.maxAlphaValue = kMaxAlphaValue;
    manager.minAlphaValue = kMinAlphaValue;
    manager.fullAlphaOffset = kDefaultFullOffset;
    manager.zeroAlphaOffset = -kNavigationBarHeight;
    manager.setZero = YES;
    manager.setFull = YES;
    manager.allChange = YES;
    manager.continues = YES;
}

+ (void)replaceSystemNavigationBarImageView:(UINavigationBar *)navigationBar {
    [self sharedManager].saveImage = navigationBar.subviews.firstObject;
    [navigationBar.subviews.firstObject removeFromSuperview];
    [navigationBar addSubview:[self sharedManager].backgroundImageView];
    [navigationBar sendSubviewToBack:[self sharedManager].backgroundImageView];
}

+ (void)setTitleColorWithColor:(UIColor *)color {
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionaryWithDictionary:[self sharedManager].selfNavigationBar.titleTextAttributes];
    [textAttr setObject:color forKey:NSForegroundColorAttributeName];
    [self sharedManager].selfNavigationBar.titleTextAttributes = textAttr;
}

+ (void)setNavigationBarColorWithAlpha:(float)alpha {
    MXNavigationBarManager *manager = [self sharedManager];
    manager.backgroundImageView.backgroundColor = [manager.barColor colorWithAlphaComponent:alpha];
}

+ (void)setUIStatusBarStyle:(UIStatusBarStyle)style {
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

@end
