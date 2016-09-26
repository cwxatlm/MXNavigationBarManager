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
static const float   kMaxAlphaValue        = 0.995f;
static const float   kMinAlphaValue        = 0.0f;
static const float   kDefaultAnimationTime = 0.35f;

#define SCREEN_RECT [UIScreen mainScreen].bounds
#define BACKGROUNDVIEW_FRAME CGRectMake(0, -20, CGRectGetWidth(SCREEN_RECT), kNavigationBarHeight)

@interface MXNavigationBarManager ()

@property (nonatomic, strong) UINavigationBar *selfNavigationBar;
@property (nonatomic, strong) UINavigationController *selfNavigationController;

@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, strong) UIColor *saveColor;
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
}

+ (void)setTintColor:(UIColor *)color {
    [self sharedManager].tintColor = color;
    [self sharedManager].selfNavigationBar.tintColor = color;
    [self setTitleColorWithColor:color];
}

+ (void)setBackgroundImage:(UIImage *)image {
    [[self sharedManager].selfNavigationBar setBackgroundImage:image
                                                 forBarMetrics:UIBarMetricsDefault];
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

+ (void)reStoreToSystemNavigationBar {
    [[self sharedManager].selfNavigationController setValue:[UINavigationBar new] forKey:@"navigationBar"];
}

#pragma mark - Public Method
+ (void)managerWithController:(UIViewController *)viewController {
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    [self sharedManager].selfNavigationController = viewController.navigationController;
    [self sharedManager].selfNavigationBar = navigationBar;
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
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
    manager.maxAlphaValue = kMaxAlphaValue;
    manager.minAlphaValue = kMinAlphaValue;
    manager.fullAlphaOffset = kDefaultFullOffset;
    manager.zeroAlphaOffset = -kNavigationBarHeight;
    manager.setZero = YES;
    manager.setFull = YES;
    manager.allChange = YES;
    manager.continues = YES;
}

+ (void)setTitleColorWithColor:(UIColor *)color {
    NSMutableDictionary *textAttr = [NSMutableDictionary dictionaryWithDictionary:[self sharedManager].selfNavigationBar.titleTextAttributes];
    [textAttr setObject:color forKey:NSForegroundColorAttributeName];
    [self sharedManager].selfNavigationBar.titleTextAttributes = textAttr;
}

+ (void)setNavigationBarColorWithAlpha:(float)alpha {
    MXNavigationBarManager *manager = [self sharedManager];
    NSLog(@"alpha = %f", alpha);
    [self setBackgroundImage:[self imageWithColor:[manager.barColor colorWithAlphaComponent:alpha]]];
}

+ (void)setUIStatusBarStyle:(UIStatusBarStyle)style {
    [[UIApplication sharedApplication] setStatusBarStyle:style];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}

@end
