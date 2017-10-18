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
        _complete = false;
        _title = @"Default Title";
        _todoDescription = @"Default Description";
        _priority = 100;
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)toDoDescription priority:(NSInteger)priority deadline:(NSDate *)deadline{
    self = [self init];
    if (self) {
        _title = title;
        _todoDescription = toDoDescription;
        _priority = priority;
        _deadline = deadline;
    }
    return self;
}

-(NSComparisonResult)comparePriority:(ToDo *)otherToDo {
    return self.priority < otherToDo.priority;
}


@end
