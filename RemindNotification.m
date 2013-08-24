//
//  RemindNotification.m
//
//  Created by Ryu Iwasaki on 2013/07/31.
//  Copyright (c) 2013年 Ryu Iwasaki. All rights reserved.
//

#import "RemindNotification.h"
static NSString *const RNKey = @"reminderId";
static NSString *const RNValue = @"reminder";
static NSInteger const DEFAULT_SECOND = 3600 * 24 * 7; // 1 week

@interface RemindNotification ()

// Private
- (void)requestWithMessage:(NSString *)message intervalSecond:(NSInteger)intervalSecond numberOfStory:(NSInteger)numberOfStory;
- (void)updateIntervalSecond:(NSInteger)interval;
- (id)reminderNowEnter;
- (BOOL)isOverRemindDate;
- (void)updateBadge;

@end

@implementation RemindNotification{
    
    NSInteger _intervalSecond;
}

#pragma mark  - Initalize

- (id)initWithMessage:(NSArray *)messages{
    
    return [self initWithMessage:messages intervalSecond:DEFAULT_SECOND];
}

- (id)initWithMessage:(NSArray *)messages intervalDay:(NSInteger)interval{
    
    self = [super init];
    
    if (self) {
        _messages = messages;
        [self setIntervalDay:interval];
        _badgeHidden = YES;
    }
    
    return self;
    
}

- (id)initWithMessage:(NSArray *)messages intervalSecond:(NSInteger)interval{
    self = [super init];
    
    if (self) {
        _messages = messages;
        [self setIntervalSecond:interval];
        _badgeHidden = YES;
    }
    
    return self;
    
}

#pragma mark  - Setter

- (void)setIntervalDay:(NSInteger)interval{
    [self updateIntervalSecond:interval * 24 * 3600];
}

- (void)setIntervalSecond:(NSInteger)interval{
    [self updateIntervalSecond:interval];
}

- (void)updateIntervalSecond:(NSInteger)interval{
    
    if (interval == 0 ) {
        _intervalSecond = DEFAULT_SECOND;
        return;
    }
    _intervalSecond = interval;
}

#pragma mark  - Request 

- (void)request{
    [self reset];
    
    NSString *message;
    NSInteger numberOfStory = 0;
    
    for (int i = 0; i < _messages.count; i ++) {
        message = _messages[i];
        numberOfStory = i + 1;
        
        [self requestWithMessage:message intervalSecond:_intervalSecond numberOfStory:numberOfStory];
    }
}

- (void)requestWithMessage:(NSString *)message
            intervalSecond:(NSInteger)intervalSecond
             numberOfStory:(NSInteger)numberOfStory{
 
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    
    NSInteger requestInterval = intervalSecond * numberOfStory;
    notification.fireDate = [NSDate dateWithTimeInterval:requestInterval sinceDate:[NSDate date]];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
    notification.alertAction = NSLocalizedStringFromTable(@"RNActionButton", @"RNLocalizable", nil);
    notification.userInfo = [self userInfo];
    notification.applicationIconBadgeNumber = numberOfStory;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSInteger)badgeNumber{
    
    NSInteger badgeNumber = -1;
    if (_badgeHidden == YES) {
        return badgeNumber;
    }
    
    badgeNumber = 1;
    
    return badgeNumber;
}

- (void)updateBadge{
    if (_badgeHidden == YES) {
        return;
    }
    
}

- (NSDictionary *)userInfo{
    return @{RNKey:RNValue};
}

#pragma mark  - Reset

+ (void)reset{
    [[RemindNotification alloc] reset];
}

// 

- (void)reset{
    
    if ([[UIApplication sharedApplication] scheduledLocalNotifications].count == 0) {

        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
    
    NSArray *notifications = [[[UIApplication sharedApplication] scheduledLocalNotifications] copy];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for( UILocalNotification *notification in notifications ) {
        
        NSComparisonResult result = [notification.fireDate compare:[NSDate date]];
        if (result == NSOrderedDescending) {
            [[UIApplication sharedApplication]scheduleLocalNotification:notification];
        }
        
        if( [[notification.userInfo objectForKey:RNKey] isEqualToString:RNValue] ) {
            [self badgeReset];
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            

        }
        
    }
    
}

- (void)badgeReset{
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [UIApplication sharedApplication].applicationIconBadgeNumber = number - 1;
    
    if (number <= 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }
}

- (BOOL)isOverRemindDate{
    
    if ( ![self isFoundNotification]){
        return NO;
    }
    
    UILocalNotification *notification = [self reminderNowEnter];
    NSDate *nextFireDate = [NSDate dateWithTimeInterval:_intervalSecond sinceDate:[NSDate date]];
    NSComparisonResult result = [notification.fireDate compare:nextFireDate];
    
    switch (result) {
        case NSOrderedSame: // =
            return NO;
            break;
        case NSOrderedAscending: // <
            return NO;
            break;
        case NSOrderedDescending: // >
            return YES;
            break;
        default:
            break;
    }
}

- (id)reminderNowEnter{
    
    for( UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications] ) {
        
        if( [[notification.userInfo objectForKey:RNKey] isEqualToString:RNValue] ) {
            return notification;
        }
        
    }
    return nil;
}

- (BOOL)isFoundNotification{
    
    for(UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        if([[notification.userInfo objectForKey:RNKey] isEqualToString:RNValue] ) {
            return YES;
        }
        
    }
    
    return NO;
}



@end
