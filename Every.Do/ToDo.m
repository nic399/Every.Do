//
//  ToDo.m
//  Every.Do
//
//  Created by Nicholas Fung on 2017-10-17.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import "ToDo.h"

@implementation ToDo

-(instancetype)init {
    self = [super init];
    if (self) {
        _status = false;
        _title = @"Default Title";
        _todoDescription = @"Default Description";
        _priority = 100;
    }
    return self;
}




@end
