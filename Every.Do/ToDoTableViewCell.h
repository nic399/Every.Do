//
//  ToDoTableViewCell.h
//  Every.Do
//
//  Created by Nicholas Fung on 2017-10-17.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
