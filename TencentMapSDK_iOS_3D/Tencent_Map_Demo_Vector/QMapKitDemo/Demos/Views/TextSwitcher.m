//
//  TextSwitcher.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TextSwitcher.h"

@interface TextSwitcher ()

@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UISwitch *switcher;

@end

@implementation TextSwitcher

#pragma mark - Action

- (void)handleAction
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textSwitcherDidValueChanged:)])
    {
        [self.delegate textSwitcherDidValueChanged:self];
    }
}

#pragma mark - API

- (NSString *)title
{
    return self.titleView.text;
}

- (void)setTitle:(NSString *)title
{
    self.titleView.text = title;
}

- (BOOL)on
{
    return self.switcher.on;
}

- (void)setOn:(BOOL)on
{
    self.switcher.on = on;
}

#pragma mark - Setup

- (void)setupSwitcher
{
    self.switcher = [[UISwitch alloc] initWithFrame:self.bounds];
    
    CGSize switcherSize = self.switcher.bounds.size;
    
    self.switcher.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - switcherSize.height / 2);
    
    [self.switcher addTarget:self action:@selector(handleAction) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.switcher];
}

- (void)setupTitleView
{
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               CGRectGetWidth(self.bounds),
                                                               CGRectGetHeight(self.bounds) - CGRectGetHeight(self.switcher.bounds))];
    
    self.titleView.font = [UIFont systemFontOfSize:10];
    self.titleView.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.titleView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupSwitcher];
        
        [self setupTitleView];
    }
    
    return self;
}

@end
