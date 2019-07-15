//
//  GestureControlViewController.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "GestureControlViewController.h"
#import "TextSwitcher.h"

typedef NS_ENUM(NSUInteger, GestureControlType) {
    GestureControlTypeZoom = 0,       ///<Zoom
    GestureControlTypeScroll,         ///<Scroll
    GestureControlTypeRotate,         ///<Rotate
    GestureControlTypePitch           ///<pitch
};

@interface GestureControlViewController () <TextSwitcherDelegate>

@end

@implementation GestureControlViewController

#pragma mark - TextSwitcherDelegate

- (void)textSwitcherDidValueChanged:(TextSwitcher *)textSwitcher
{
    BOOL on = textSwitcher.on;
    
    switch (textSwitcher.idx) {
        case GestureControlTypeZoom:
        {
            self.mapView.zoomEnabled = on;
            
            break;
        }
        case GestureControlTypeScroll:
        {
            self.mapView.scrollEnabled = on;
            
            break;
        }
        case GestureControlTypeRotate:
        {
            self.mapView.rotateEnabled = on;
            
            break;
        }
        case GestureControlTypePitch:
        {
            self.mapView.overlookingEnabled = on;
            
            break;
        }
        default:
        {
            NSAssert(NO, @"GestureControlType = %ld is Not Supported!", (long)textSwitcher.idx);
            
            break;
        }
            
    }
}

#pragma mark - Helper

- (TextSwitcher *)constructTextSwitcherWithType:(GestureControlType)type
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

#pragma mark - Toolbar

- (void)setupToolbar
{

    NSMutableArray *items = [NSMutableArray array];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [items addObject:flexItem];
    
    // Zoom
    {
        TextSwitcher *textSwitcher = [self constructTextSwitcherWithType:GestureControlTypeZoom title:@"Zoom" on:self.mapView.zoomEnabled delegate:self];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textSwitcher];
        
        [items addObject:item];
    }
    
    [items addObject:flexItem];
    
    // Scroll
    {
        TextSwitcher *textSwitcher = [self constructTextSwitcherWithType:GestureControlTypeScroll title:@"Scroll" on:self.mapView.scrollEnabled delegate:self];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textSwitcher];
        
        [items addObject:item];
    }
    
    [items addObject:flexItem];
    
    // Rotate
    {
        TextSwitcher *textSwitcher = [self constructTextSwitcherWithType:GestureControlTypeRotate title:@"Rotate" on:self.mapView.rotateEnabled delegate:self];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textSwitcher];
        
        [items addObject:item];
    }
    
    [items addObject:flexItem];
    
    // Overlooking
    {
        TextSwitcher *textSwitcher = [self constructTextSwitcherWithType:GestureControlTypePitch title:@"Pitch" on:self.mapView.overlookingEnabled delegate:self];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:textSwitcher];
        
        [items addObject:item];
    }
    
    
    [items addObject:flexItem];
    
    self.toolbarItems = items;
}

#pragma mark - Life Cicle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupToolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

@end
