//
//  MXNavigationBarManager.h
//  MXBarManagerDemo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 desn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MXNavigationBarManager : NSObject

@property (nonatomic, strong) UIColor *barColor; //NavigationBar background color, default is white
@property (nonatomic, strong) UIColor *tintColor; //NavigationBar subviews color
@property (nonatomic, strong) UIImage *backgroundImage; //default is nil
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle; // default is UIStatusBarStyleDefault

@property (nonatomic, assign) float zeroAlphaOffset;//color will changed begin this offset, default is -64
@property (nonatomic, assign) float fullAlphaOffset;//color alpha will be 1 in this offset, default is 200
@property (nonatomic, assign) float minAlphaValue;//bar minAlpha, default is 0
@property (nonatomic, assign) float maxAlphaValue;//bar maxAlpha, default is 1

@property (nonatomic, strong) UIColor *fullAlphaTintColor;//if you set this property, the tintColor will changed in fullAlphaOffset
@property (nonatomic, assign) UIStatusBarStyle fullAlphaBarStyle;//if you set this property, the barStyle will changed in fullAlphaOffset

@property (nonatomic, assign) BOOL allChange;//if allchange = yes, the tintColor will changed with the barColor change, default is yes, if you only want to change barColor, set allChange = NO
@property (nonatomic, assign) BOOL reversal;//this will cause that if currentAlpha = 0.3,it will be 1 - 0.3 = 0.7
@property (nonatomic, assign) BOOL continues;//when continues = YES, bar color will changed whenever you scroll, if you set continues = NO,it only be changed in the fullAlphaOffset


+ (void)setBarColor:(UIColor *)color;
+ (void)setTintColor:(UIColor *)color;
+ (void)setBackgroundImage:(UIImage *)image;
+ (void)setStatusBarStyle:(UIStatusBarStyle)style;

+ (void)setZeroAlphaOffset:(float)offset;
+ (void)setFullAlphaOffset:(float)offset;
+ (void)setMaxAlphaValue:(float)value;
+ (void)setMinAlphaValue:(float)value;

+ (void)setFullAlphaTintColor:(UIColor *)color;
+ (void)setFullAlphaBarStyle:(UIStatusBarStyle)style;

+ (void)setAllChange:(BOOL)allChange;
+ (void)setReversal:(BOOL)reversal;
+ (void)setContinues:(BOOL)continues;

+ (void)managerWithController:(UIViewController *)viewController;//you should use this method to init MXNavigationManager

+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset;// implemention this method in @selectot(scrollView: scrollViewDidScroll)

+ (void)saveWithController:(UIViewController *)viewController;//save now navigationBar status, use reStore to recover it

+ (void)reStoreWithZeroStatus;//recover status in zeroAlpha status

+ (void)reStoreWithFullStatus;//recover status in fullAlpha status

+ (void)reStore;// recover status which you had saved in @selector(saveWithController:)

@end
