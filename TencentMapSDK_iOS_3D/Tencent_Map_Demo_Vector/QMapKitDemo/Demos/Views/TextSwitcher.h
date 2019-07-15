//
//  TextSwitcher.h
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextSwitcher;
@protocol TextSwitcherDelegate <NSObject>

@optional

- (void)textSwitcherDidValueChanged:(TextSwitcher *)textSwitcher;

@end

@interface TextSwitcher : UIView

@property (nonatomic, weak) id <TextSwitcherDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL on;

@property (nonatomic, assign) NSInteger idx;

@end
