//
//  DetailViewController.m
//  Every.Do
//
//  Created by Nicholas Fung on 2017-10-17.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import "DetailViewController.h"
#import "ToDo.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        ToDo *myToDo = self.detailItem;
        self.navigationItem.title = myToDo.title;
        self.detailDescriptionLabel.text = myToDo.todoDescription;
        self.titleLabel.text = myToDo.title;
        self.priorityLabel.text = [NSString stringWithFormat:@"Priority: %ld", (long)myToDo.priority];
        NSString *toDoCompleted;
        if (myToDo.complete) {
            toDoCompleted = @"ToDo complete!";
        }
        else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MMM d, yyyy h:mm a";
            toDoCompleted = [dateFormatter stringFromDate:myToDo.deadline];
        }
        self.deadlineLabel.text = toDoCompleted;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
