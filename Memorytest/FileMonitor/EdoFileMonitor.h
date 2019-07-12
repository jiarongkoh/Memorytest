//
//  EdoFileMonitor.h
//  File Monitor
//
//  Created by liuhui on 7/2/19.
//  Copyright (c) 2019 Edison. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EdoFileMonitorChangeType)
{
    EdoFileMonitorChangeTypeModified,
    EdoFileMonitorChangeTypeMetadata,
    EdoFileMonitorChangeTypeSize,
    EdoFileMonitorChangeTypeRenamed,
    EdoFileMonitorChangeTypeDeleted,
    EdoFileMonitorChangeTypeObjectLink,
    EdoFileMonitorChangeTypeRevoked
};

@protocol EdoFileMonitorDelegate;

@interface EdoFileMonitor : NSObject
{
//    NSURL *_fileURL;

}
@property (nonatomic, weak) id<EdoFileMonitorDelegate> delegate;
@property (nonatomic, strong) NSURL *fileURL;
- (id)initWithURL:(NSURL *)URL;

@end

@protocol EdoFileMonitorDelegate <NSObject>
@optional

- (void)fileMonitor:(EdoFileMonitor *)fileMonitor didSeeChange:(EdoFileMonitorChangeType)changeType;

@end
