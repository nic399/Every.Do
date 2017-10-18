//
//  ToDo.h
//  Every.Do
//
//  Created by Nicholas Fung on 2017-10-17.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDo : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *todoDescription;
@property (nonatomic) NSInteger priority;
@property (nonatomic) BOOL complete;
@property (nonatomic) NSDate *deadline;

-(instancetype)initWithTitle:(NSString *)title description:(NSString *)toDoDescription priority:(NSInteger)priority deadline:(NSDate *)deadline;

-(NSComparisonResult)comparePriority:(ToDo *)otherToDo;

@end
