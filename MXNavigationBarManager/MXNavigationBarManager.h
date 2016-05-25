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

@property (nonatomic, assign) float fullAlphaOffset;
@property (nonatomic, assign) float zeroAlphaOffset;
@property (nonatomic, assign) float maxAlphaValue;
@property (nonatomic, assign) float minAlphaValue;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIColor *zeroAlphaTintColor;
@property (nonatomic, strong) UIColor *fullAlphaTintColor;
@property (nonatomic, assign) UIStatusBarStyle zeroAlphaBarStyle;

+ (void)setBarColor:(UIColor *)color;
+ (void)setBackgroundImage:(UIImage *)image;

+ (void)setZeroAlphaTintColor:(UIColor *)color;
+ (void)setFullAlphaTintColor:(UIColor *)color;

+ (void)setZeroAlphaOffset:(float)offset;
+ (void)setFullAlphaOffset:(float)offset;

+ (void)setMaxAlphaValue:(float)value;
+ (void)setMinAlphaValue:(float)value;

+ (void)setZeroAlphaBarStyle:(UIStatusBarStyle)style;

+ (void)managerWithController:(UIViewController *)viewController;

+ (void)changeAlphaWithCurrentOffset:(CGFloat)currentOffset;

@end
