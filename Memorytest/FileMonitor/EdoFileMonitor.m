//
//  EdoFileMonitor.m
//  File Monitor
//
//  Created by liuhui on 7/2/19.
//  Copyright (c) 2019 Edison. All rights reserved.
//

#import "EdoFileMonitor.h"

@interface EdoFileMonitor ()
{
@private
    dispatch_source_t _source;
    int _fileDescriptor;
    BOOL _keepMonitoringFile;
}

@end

@implementation EdoFileMonitor

- (id)initWithURL:(NSURL *)URL
{
    self = [self init];
    if (self)
    {
        _fileURL = URL;
        _keepMonitoringFile = NO;
        [self __beginMonitoringFile];
    }
    return self;
}

- (void)dealloc
{
    dispatch_source_cancel(_source);
}

- (void)__beginMonitoringFile
{
    // Add a file descriptor for our test file
    _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                           O_EVTONLY);
    
    // Get a reference to the default queue so our file notifications can go out on it
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Create a dispatch source
//    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
//                                     _fileDescriptor,
//                                     DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
//                                     defaultQueue);
    // Create a dispatch source
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                     _fileDescriptor,
                                     DISPATCH_VNODE_EXTEND, //only for monitor file size
                                     defaultQueue);

    // Log one or more messages to the screen when there's a file change event
    dispatch_source_set_event_handler(_source, ^
    {
        unsigned long eventTypes = dispatch_source_get_data(_source);
        [self __alertDelegateOfEvents:eventTypes];
    });
    
    dispatch_source_set_cancel_handler(_source, ^
    {
        close(_fileDescriptor);
        _fileDescriptor = 0;
        _source = nil;
        
        // If this dispatch source was canceled because of a rename or delete notification, recreate it
        if (_keepMonitoringFile)
        {
            _keepMonitoringFile = NO;
            [self __beginMonitoringFile];
        }
    });
    
    // Start monitoring the test file
    dispatch_resume(_source);
}

- (void)__recreateDispatchSource
{
    _keepMonitoringFile = YES;
    dispatch_source_cancel(_source);
}

- (void)__alertDelegateOfEvents:(unsigned long)eventTypes
{
    dispatch_queue_t evnetQueue = dispatch_queue_create("EdoFileMonitorQueue", DISPATCH_QUEUE_CONCURRENT); //DISPATCH_QUEUE_SERIAL
    dispatch_async(evnetQueue, ^
//    dispatch_async(dispatch_get_main_queue(), ^
    {
        BOOL recreateDispatchSource = NO;
        NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:7];
        
        if (eventTypes & DISPATCH_VNODE_ATTRIB)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeMetadata)];
        }
        if (eventTypes & DISPATCH_VNODE_DELETE)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeDeleted)];
            recreateDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_EXTEND)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeSize)];
        }
        if (eventTypes & DISPATCH_VNODE_LINK)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeObjectLink)];
        }
        if (eventTypes & DISPATCH_VNODE_RENAME)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeRenamed)];
            recreateDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_REVOKE)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeRevoked)];
        }
        if (eventTypes & DISPATCH_VNODE_WRITE)
        {
            [eventSet addObject:@(EdoFileMonitorChangeTypeModified)];
        }
        
        for (NSNumber *eventType in eventSet)
        {
            EdoFileMonitorChangeType changeType = (EdoFileMonitorChangeType)[eventType unsignedIntegerValue];
            [self.delegate fileMonitor:self
                          didSeeChange:changeType];
        }
        
        if (recreateDispatchSource)
        {
            [self __recreateDispatchSource];
        }
    });
}

@end
