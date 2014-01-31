//
//  ScaryBugData.m
//  OSXPlayGround
//
//  Created by Jenei Viktor on 31/01/14.
//  Copyright (c) 2014 victo. All rights reserved.
//

#import "ScaryBugData.h"

@implementation ScaryBugData

- (instancetype)initWithTitle:(NSString*)title rating:(float)rating {
    self = [super init];
    if (self) {
        _title = title;
        _rating = rating;
    }
    return self;
}

@end
