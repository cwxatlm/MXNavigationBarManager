# MXNavigationBarManager
Easy way to change your navigationBar color

![demo](GifPicture/Gif1.gif)

使用  How to Use it
=====

## 安装

### CocoaPods

你可以使用cocapods导入  you can use it in cocoapods
```
pod 'MXNavigationBarManager'   
```

### 使用方式

## 渐变

```objective-c
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1]];
    [MXNavigationBarManager setTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
    [MXNavigationBarManager setZeroAlphaOffset:-64];
    [MXNavigationBarManager setFullAlphaOffset:200];
    [MXNavigationBarManager setFullAlphaTintColor:[UIColor whiteColor]];
    [MXNavigationBarManager setFullAlphaBarStyle:UIStatusBarStyleLightContent];
```

你需要在ScrollviewDidScroll里面实现下面的方法即可渐变导航栏颜色
```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [MXNavigationBarManager changeAlphaWithCurrentOffset:scrollView.contentOffset.y];
}
```

你需要在viewWillAppear 里面和 viewWillDisappear里面设置和取消tableView的代理
```objective-c
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    //optional  退出时改变导航栏状态
    [MXNavigationBarManager reStoreWithZeroStatus];
}
```

### 更多用法请参考Demo
