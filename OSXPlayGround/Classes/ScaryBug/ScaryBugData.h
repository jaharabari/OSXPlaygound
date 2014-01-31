//
//  ScaryBugData.h
//  OSXPlayGround
//
//  Created by Jenei Viktor on 31/01/14.
//  Copyright (c) 2014 victo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaryBugData : NSObject

@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) float rating;

- (instancetype)initWithTitle:(NSString*)title rating:(float)rating;

@end
