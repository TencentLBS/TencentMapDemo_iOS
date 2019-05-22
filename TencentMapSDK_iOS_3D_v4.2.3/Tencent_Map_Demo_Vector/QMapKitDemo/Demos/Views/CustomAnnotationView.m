//
//  CustomAnnotationView.m
//  MapMiddlewareDemo
//
//  Created by tabsong on 17/3/22.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "CustomAnnotationView.h"

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation CustomAnnotationView

- (void)setValue:(NSUInteger)value
{
    _value = value;
    
    self.label.text = [NSString stringWithFormat:@"%lu", (unsigned long)_value];
}

#pragma mark - Setup

- (void)setupImageView
{
    UIImage *img = [UIImage imageNamed:@"gps_map"];
    
    self.imageView = [[UIImageView alloc] initWithImage:img];
    
    self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    [self addSubview:self.imageView];
}

- (void)setupLabel
{
#define Label_H 32
    
    CGRect r = CGRectMake(0, 0, CGRectGetWidth(self.imageView.bounds), Label_H);
    
    self.label = [[UILabel alloc] initWithFrame:r];
    
    self.label.textAlignment   = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor       = [UIColor whiteColor];
    
    [self.imageView addSubview:self.label];
}

#pragma mark - Life Cycle

- (instancetype)initWithAnnotation:(id<QAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        [self setupImageView];
        
        [self setupLabel];
        
        self.bounds = self.imageView.bounds;
        
        self.centerOffset = CGPointMake(0, -32);
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

@end
