//
//  ControlPanelInteractViewController.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/4/2.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "ControlPanelInteractViewController.h"
#import "TextSwitcher.h"

typedef NS_ENUM(NSInteger, ControllType) {
    ControllTypeScale = 0,
    ControllTypeCompass
};
typedef enum : NSUInteger {
    topLeft = 0,
    topRight,
    bottomLeft,
    bottomRight
} LogoPosition;

@interface ControlPanelInteractViewController () <TextSwitcherDelegate>
@property (nonatomic, strong) NSMutableString *count;

@end

@implementation ControlPanelInteractViewController
LogoPosition state = bottomRight;

- (NSString *)testTitle
{
    return @"变更Logo位置";
}

- (void)handleTestAction
{
    //变换logo的位置
    switch (state) {
        case topLeft:
            [self.mapView setLogoMargin:CGPointMake(6, 3) anchor:QMapLogoAnchorRightTop];
            state = topRight;
            break;
            
        case topRight:
            [self.mapView setLogoMargin:CGPointMake(6, 3) anchor:QMapLogoAnchorRightBottom];
            state = bottomRight;
            break;
            
        case bottomRight:
            [self.mapView setLogoMargin:CGPointMake(6, 3) anchor:QMapLogoAnchorLeftBottom];
            state = bottomLeft;
            break;
            
        case bottomLeft:
            [self.mapView setLogoMargin:CGPointMake(6, 3) anchor:QMapLogoAnchorLeftTop];
            state = topLeft;
            break;
        default:
            break;
    }
    
}

- (void)textSwitcherDidValueChanged:(TextSwitcher *)textSwitcher
{
    
    BOOL on = textSwitcher.on;
    
    switch (textSwitcher.idx) {
        case ControllTypeScale:
        {
        self.mapView.showsScale = on;
        
        break;
        }
        case ControllTypeCompass:
        {
        self.mapView.showsCompass = on;
        
        
        break;
        }
        default:
        {
        NSAssert(NO, @"GestureControlType = %ld is Not Supported!", (long)textSwitcher.idx);
        
        break;
        }
            
    }
}

- (TextSwitcher *)constructTextSwitcherWithType:(ControllType)type
                                          title:(NSString *)title
                                             on:(BOOL)on
                                       delegate:(id <TextSwitcherDelegate>)delegate
{
    TextSwitcher *t = [[TextSwitcher alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    t.delegate  = self;
    t.title     = title;
    t.on        = on;
    t.idx       = type;
    
    return t;
}

//设置switch控件
-(void)setUpSwitchers
{
    TextSwitcher *scaleSwitcher = [self constructTextSwitcherWithType:ControllTypeScale title:@"比例尺" on:self.mapView.showsScale delegate:self];
    
    TextSwitcher *compassSwitcher = [self constructTextSwitcherWithType:ControllTypeCompass title:@"指南针" on:self.mapView.showsScale delegate:self];
    compassSwitcher.backgroundColor = [UIColor whiteColor];
    compassSwitcher.layer.cornerRadius = 5;
    compassSwitcher.clipsToBounds = true;
    compassSwitcher.translatesAutoresizingMaskIntoConstraints = false;
    
    scaleSwitcher.backgroundColor = [UIColor whiteColor];
    scaleSwitcher.layer.cornerRadius = 5;
    scaleSwitcher.clipsToBounds = true;
    scaleSwitcher.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:compassSwitcher];
    [self.view addSubview:scaleSwitcher];
    
    //控件布局
    
    //指南针布局
    [compassSwitcher.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:20].active = YES;
    [compassSwitcher.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10].active = YES;
    [compassSwitcher.widthAnchor constraintEqualToConstant:60].active = YES;
    [compassSwitcher.heightAnchor constraintEqualToConstant:50].active = YES;
    
    //比例尺布局
    [scaleSwitcher.topAnchor constraintEqualToAnchor:compassSwitcher.bottomAnchor constant:10].active = YES;
    [scaleSwitcher.rightAnchor constraintEqualToAnchor:compassSwitcher.rightAnchor].active = YES;
    [scaleSwitcher.widthAnchor constraintEqualToConstant:60].active = YES;
    [scaleSwitcher.heightAnchor constraintEqualToConstant:50].active = YES;
    
}


//设置地图放大缩小控件
-(void)setUpZoomPanelView
{
    UIView *rect = [[UIView alloc] init];
    rect.translatesAutoresizingMaskIntoConstraints = false;
    rect.backgroundColor = [UIColor whiteColor];
    
    //放大按钮
    UIButton *increseButton = [[UIButton alloc] init];
    increseButton.translatesAutoresizingMaskIntoConstraints = false;
    [increseButton setTitle:@"➕" forState:UIControlStateNormal];
    increseButton.layer.borderWidth = 0.5;
    increseButton.showsTouchWhenHighlighted = YES;
    [increseButton addTarget:self action:@selector(zoomInAction) forControlEvents:UIControlEventTouchUpInside];
    
    //缩小按钮
    UIButton *decreseButton = [[UIButton alloc] init];
    decreseButton.translatesAutoresizingMaskIntoConstraints = false;
    [decreseButton setTitle:@"➖" forState:UIControlStateNormal];
    decreseButton.layer.borderWidth = 0.5;
    decreseButton.showsTouchWhenHighlighted = YES;
    [decreseButton addTarget:self action:@selector(zoomOutAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rect];
    [rect.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-20].active = YES;
    [rect.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [rect.widthAnchor constraintEqualToConstant:35].active = YES;
    [rect.heightAnchor constraintEqualToConstant:98].active = YES;
    [rect addSubview:increseButton];
    [rect addSubview:decreseButton];
    
    [increseButton.topAnchor constraintEqualToAnchor:rect.topAnchor].active = YES;
    [increseButton.heightAnchor constraintEqualToConstant:49].active = YES;
    [increseButton.leftAnchor constraintEqualToAnchor:rect.leftAnchor].active = YES;
    [increseButton.rightAnchor constraintEqualToAnchor:rect.rightAnchor].active = YES;
    
    [decreseButton.bottomAnchor constraintEqualToAnchor:rect.bottomAnchor].active = YES;
    [decreseButton.heightAnchor constraintEqualToConstant:49].active = YES;
    [decreseButton.leftAnchor constraintEqualToAnchor:rect.leftAnchor].active = YES;
    [decreseButton.rightAnchor constraintEqualToAnchor:rect.rightAnchor].active = YES;
    
    
    
}

//放大地图
-(void)zoomInAction
{
    CGFloat currentZoomLevel = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:currentZoomLevel + 1 animated:YES];
}

//缩小地图
-(void)zoomOutAction
{
    CGFloat currentZoomLevel = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:currentZoomLevel - 1 animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mapView.showsCompass = YES;
    self.mapView.showsScale = YES;
    [self setUpSwitchers];
    [self setUpZoomPanelView];
    
}



@end
