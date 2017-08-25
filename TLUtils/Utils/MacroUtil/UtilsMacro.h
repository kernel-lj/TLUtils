//
//  UtilsMacro.h
//  InvestChina
//
//  Created by gcz on 14-8-26.
//  Copyright (c) 2014年 gcz. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//方便使用的工具宏
/*########################屏幕尺寸&&系统版本####################*/
//3.5寸屏幕
#define ThreePointFiveInch ([UIScreen mainScreen].bounds.size.height == 480.0)
//4.0寸屏幕
#define FourInch ([UIScreen mainScreen].bounds.size.height == 568.0)
//4.7寸屏幕
#define FourPointSevenInch ([UIScreen mainScreen].bounds.size.height == 667.0)
//5.5寸屏幕
#define FivePointFiveSevenInch ([UIScreen mainScreen].bounds.size.height == 736.0)

#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242.0f, 2208.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750.0f, 1334.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 1136.0f), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640.0f, 960.0f), [[UIScreen mainScreen] currentMode].size) : NO)

//iOS7系统
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0  && [UIDevice currentDevice].systemVersion.doubleValue < 8.0)
//iOS8系统
#define iOS8 ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0  && [UIDevice currentDevice].systemVersion.doubleValue < 9.0)
//iOS9系统
#define iOS9 ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0 && [UIDevice currentDevice].systemVersion.doubleValue < 10.0)
//iOS10系统
#define iOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0 && [UIDevice currentDevice].systemVersion.doubleValue < 11.0)
//iOS11系统
#define iOS10 ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)

//设备的宽高
#define HScreen [[UIScreen mainScreen] bounds].size.height
#define WScreen [[UIScreen mainScreen] bounds].size.width


//定义屏幕尺寸及中心坐标 定义高清屏
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kScreen_CenterX  kSCREEN_WIDTH/2
#define kScreen_CenterY  kSCREEN_HEIGHT/2
#define isRetina ([[UIScreen mainScreen] scale]==2)

//可拉伸的图片
#define PNGIMAGE(name)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(name) ofType:@"png"]]
#define ResizableImage(name,top,left,bottom,right) [IMAGE(name) resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableScaleImage(name,zoom,top,left,bottom,right) [[UIImage imageWithCGImage:IMAGE(name).CGImage scale:zoom orientation:UIImageOrientationUp] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]

//获取view的frame某值
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y

// 创建rect
#define Rect(x,y,width,height)              CGRectMake(x, y, width,height)

//获取rect中某值
#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height

//设置rect中某值
#define RectSetWidth(rect, w)                  CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                 CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                      CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                      CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))

#define RectSetSize(rect, w, h)                CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)              CGRectMake(x, y, RectWidth(rect), RectHeight(rect))

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }
#define MoveViewTo(v, deltaX, deltaY) { CGRect f = v.frame; f.origin.x += deltaX ;f.origin.y += deltaY; v.frame = f; }
#define MakeHeightTo(v, h) { CGRect f = v.frame; f.size.height = h; v.frame = f; }
#define MakeXTo(v, vx) { CGRect f = v.frame; f.origin.x = vx; v.frame = f; }
#define MakeYTo(v, vy) { CGRect f = v.frame; f.origin.y = vy; v.frame = f; }
#define MakeWidthTo(v,w)  { CGRect f = v.frame; f.size.width = w; v.frame = f; }

//  主要单例
#define TL_UserDefaults                        [NSUserDefaults standardUserDefaults]
#define TL_NotificationCenter                  [NSNotificationCenter defaultCenter]

//收到通知后执行什么操作
#define TL_RecevieNotification(name,expression) [[TL_NotificationCenter rac_addObserverForName:name object:nil] subscribeNext:^(NSNotification *noteification) {expression;}];

// 应用程序代理
#define APP_DELEGATE SharedApplication.delegate

// 沙盒路径
#define PATH_FOR_CACHE    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
#define PATH_FOR_DOC      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define FILE_PATH_AT_CACHE(fileName)    [PATH_FOR_CACHE stringByAppendingPathComponent:fileName]
#define FILE_PATH_AT_DOC(fileName)      [PATH_FOR_DOC stringByAppendingPathComponent:fileName]


//输出frame(frame是结构体，没法%@) BOOL NSInteger
#define LOGFRAME(f) NSLog(@"\nx:%f\ny:%f\nwidth:%f\nheight:%f\n",f.origin.x,f.origin.y,f.size.width,f.size.height)
#define LOGBOOL(b)  NSLog(@"%@",b?@"YES":@"NO");
#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define LOGINT(i) NSLog(@"%@",NSStringFromInt(i))

//弹出信息
#define ALERT(msg) [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
// 带占字符弹出信息(format, ## __VA_ARGS__)
#define ALERT_FORMAT(format, ...) [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:format, ## __VA_ARGS__] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]
#define ALERT_TITLE(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show]


//color
#define RGB(r, g, b)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]


//转换
#define I2S(number) [NSString stringWithFormat:@"%d",number]
#define F2S(number) [NSString stringWithFormat:@"%.0f",number]
#define DATE(stamp) [NSDate dateWithTimeIntervalSince1970:[stamp intValue]];

//GCD （子线程、主线程定义）
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define MAIN_DELAY(s,block) \
    double delayInSeconds = s;   \
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC); \
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);\
    dispatch_after(delayInNanoSeconds, concurrentQueue, block);


#define TL_subThread(expression) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ expression; })

#define  TL_mainThread(expression)\
dispatch_async(dispatch_get_main_queue(), ^{expression});


//打开URL
#define canOpenURL(appScheme) ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appScheme]])

#define TL_OpenURL(URLString) ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]])

// 获取版本号

#ifdef DEBUG
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#else
#define LOCAL_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]
#endif

#define LOCAL_DEBUG_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"]
#define LOCAL_RELEASE_VER_STR [[NSBundle mainBundle]infoDictionary][@"CFBundleShortVersionString"]

// NSLog(...)
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

// 获取手机型号
#define Phone_Model [[UIDevice currentDevice] model]

//获取UDID
#define DEVICE_ID [SvUDIDTools UDID]

// 系统版本号
#define System_Version [[UIDevice currentDevice] systemVersion]

//add by ltl 2015.08.21
#define TL_ANIMATION(time,expression)\
[UIView animateWithDuration:time animations:^{expression}];

#define TL_ANIMATION_COMPLETION(time,expresiion,COMPLETION)\
[UIView animateWithDuration:time animations:^{expresiion} completion:^(BOOL finished){COMPLETION}];

#define TL_AFTER(time,expression)\
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{expression;});

#define TL_RAC_AFTER(time,expression)\
[[RACScheduler mainThreadScheduler] afterDelay:time schedule:^{expression;}];

#define TL_FONT(FLOAT) [UIFont systemFontOfSize:FLOAT]
#define TL_FONT_NAME(NAME,SIZE)  [UIFont fontWithName:NAME size:SIZE]

//颜色
#define TL_COLOR(COLOR) [UIColor COLOR]
#define TL_COLOR_Hex(STRING) [UIColor colorWithHex:STRING]
#define TL_COLOR_Hex_ALPHA(string,ALPHA)  [UIColor colorWithHex:string alpha:ALPHA];


//添加点击手势1
#define TL_TapGesture(view,funcName)\
[view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(funcName)]]

//添加点击手势2:这种方法要先创建一个tap -> UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init]; 让后把tap传到 Gesture
#define TL_Gesture(view,Gesture,funcName) \
[[Gesture  rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *tap) { funcName; }];\
[view addGestureRecognizer:Gesture];

#define TL_PanGesture(view,funcName)\
[view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(funcName)]]

// 按钮点击事件1
#define TL_RAC_BUTTON(button,expression) [[button rac_signalForControlEvents:UIControlEventTouchUpInside]\
subscribeNext:^(UIButton *btn) { expression ;}];

// 按钮点击事件2
#define TL_RAC_COMMAND(expression) [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {\
expression; \
return [RACSignal empty];\
}]



// storyboard实例化
#define TL_STORYBOARD(storyboardName)          [UIStoryboard storyboardWithName:storyboardName bundle:nil]
#define TL_INSTANT_VC_WITH_ID(storyboardName,vcIdentifier)  [TL_STORYBOARD(storyboardName) instantiateViewControllerWithIdentifier:vcIdentifier]

#define TL_INSTANT_VC_WITH_MIAN(vcIdentifier)  [TL_STORYBOARD(@"Main") instantiateViewControllerWithIdentifier:vcIdentifier]


#define TL_Bundle                    [NSBundle mainBundle]
#define TL_BundleToObj(nibName)      [Bundle loadNibNamed:nibName owner:nil options:nil][0]
#define TL_BundlePath(name,type)     [Bundle pathForResource:name ofType:type]
#define TL_DICFromBundlePath(name)       [[NSMutableDictionary alloc] initWithContentsOfFile:TL_BundlePath(name, @"plist")];

//图片
#define TL_IMAGE(name) [UIImage imageNamed:name]
#define TL_IMAGE_FRAME(Rect) [[UIImageView alloc]initWithFrame:Rect]


//Application
#define TL_Application  [UIApplication sharedApplication]

//keyWindow
#define TL_KEYWINDOW [UIApplication sharedApplication].keyWindow

//textField
#define TL_PLACEHOLDER_COLOR(textField,color) [textField setValue:[UIColor color] forKeyPath:@"_placeholderLabel.textColor"];
#define TL_PLACEHOLDER_COLOR_Hex(textField,color_Hex) [textField setValue:[UIColor colorWithHex:color_Hex] forKeyPath:@"_placeholderLabel.textColor"];

#define TL_PLACEHOLDER_FONT(textField,TL_FONT)    [textField setValue:TL_FONT forKeyPath:@"_placeholderLabel.font"];

//根据textfield的长度决定某个按钮颜色
#define TL_BUTTON_ENABLE_FROM_TEXTFIELD(TEXTFIELD,NUM,BUTTON) [[TEXTFIELD.rac_textSignal map:^id(NSString *text) {\
return @((text.length > NUM));\
}]\
subscribeNext:^(NSNumber *value) {\
if ([value boolValue]) {\
BUTTON.selected = YES;\
}else {\
BUTTON.selected = NO;\
}\
}];\

//view
//添加view
#define  TL_ADDVIEW(aView)  [self.view addSubview:aView]

#define TL_DoucumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define TL_filePath(fileName)  [TL_DoucumentPath stringByAppendingPathComponent:fileName]

/**
 *  获取版本号
 */
#define VersionStr(version) [NSString stringWithFormat:@"V %@",version]

/**
 *  NSMutableArray
 */
#define TL_mArray   [NSMutableArray arrayWithCapacity:0];

#endif
