//
//  RemindNotification.h
//
//  Created by Ryu Iwasaki on 2013/07/31.
//  Copyright (c) 2013年 Ryu Iwasaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindNotification : NSObject

@property (nonatomic)NSArray *messages;
@property (nonatomic)BOOL badgeHidden;

- (id)initWithMessage:(NSArray *)messages;
- (id)initWithMessage:(NSArray *)messages intervalDay:(NSInteger)interval;
- (id)initWithMessage:(NSArray *)messages intervalSecond:(NSInteger)interval;

- (void)setIntervalDay:(NSInteger)interval;
- (void)setIntervalSecond:(NSInteger)interval;

- (void)request; // handler
+ (void)reset;

- (BOOL)isFoundNotification;

@end
