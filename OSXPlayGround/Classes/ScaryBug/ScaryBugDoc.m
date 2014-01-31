//
//  ScaryBugDoc.m
//  OSXPlayGround
//
//  Created by Jenei Viktor on 31/01/14.
//  Copyright (c) 2014 victo. All rights reserved.
//

#import "ScaryBugDoc.h"
#import "ScaryBugData.h"

@implementation ScaryBugDoc

- (id)initWithTitle:(NSString*)title rating:(float)rating thumbImage:(NSImage *)thumbImage fullImage:(NSImage *)fullImage {
    self = [super init];
    if (self) {
        _data = [[ScaryBugData alloc] initWithTitle:title rating:rating];
        _thumbImage = thumbImage;
        _fullImage = fullImage;
    }
    return self;
}

@end
