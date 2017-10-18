//
//  MasterViewController.m
//  Every.Do
//
//  Created by Nicholas Fung on 2017-10-17.
//  Copyright © 2017 Nicholas Fung. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ToDo.h"
#import "ToDoTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150.0;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.objects = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        ToDo *item = [[ToDo alloc] initWithTitle:[NSString stringWithFormat:@"ToDo %d", i] description:[NSString stringWithFormat:@"Description %d", i] priority:i*91%73 deadline:[NSDate date]];
        [self.objects insertObject:item atIndex:0];
    }
    UISegmentedControl *sortViewBy = [[UISegmentedControl alloc] initWithItems:@[@"Priority", @"Deadline"]];
    [sortViewBy addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    sortViewBy.selectedSegmentIndex = 0;
    self.navigationItem.titleView = sortViewBy;
    
    [self.tableView reloadData];
}

-(void)segmentChanged:(UISegmentedControl *)sender {
    NSLog(@"Segment changed");
}

- (void)viewWillAppear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)insertNewObject:(id)sender {
    // Called when the '+' on the top right of the navigation bar is tapped
    NSLog(@"In insertNewObject");
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    ToDo *newToDo = [[ToDo alloc] init];
    
    UIDatePicker *myDatePicker = [[UIDatePicker alloc] init];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New ToDo" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ToDo Title";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ToDo Description";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ToDo Priority";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Deadline";
        [textField setInputView:myDatePicker];
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        newToDo.title = alert.textFields[0].text;
        newToDo.todoDescription = alert.textFields[1].text;
        newToDo.priority = [alert.textFields[2].text integerValue];
        newToDo.deadline = myDatePicker.date;
        [self.objects insertObject:newToDo atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.objects = [[self.objects sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        [alert dismissViewControllerAnimated:true completion:nil];
        NSLog(@"Alert completed");

        [self.tableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailItem:object];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In tableViewCellForRowAtIndexPath");
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self.tableView registerNib:[UINib nibWithNibName:@"ToDoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    
    
    
    ToDo *object = self.objects[indexPath.row];
    if (object.complete) {
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString *myAttrTitle = [[NSAttributedString alloc] initWithString:object.title attributes:attributes];
        cell.titleLabel.attributedText = myAttrTitle;
        
        NSAttributedString* myAttrDetail = [[NSAttributedString alloc] initWithString:object.todoDescription attributes:attributes];
        cell.descriptionLabel.attributedText = myAttrDetail;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.titleLabel.text = object.title;
        cell.descriptionLabel.text = object.todoDescription;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.priorityLabel.text = [NSString stringWithFormat:@"%ld", (long)object.priority];

    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In tableViewCommitEditingStyleForRowAtIndexPath");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *completed = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"Done" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ToDo *currentItem = [self.objects objectAtIndex:indexPath.row];
        currentItem.complete = !currentItem.complete;
        [self.tableView setEditing:false];
        [self.tableView reloadData];
    }];
    completed.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    
    return @[completed, delete];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ToDo *temp = [self.objects objectAtIndex:sourceIndexPath.row];
    [self.objects removeObjectAtIndex:sourceIndexPath.row];
    [self.objects insertObject:temp atIndex:destinationIndexPath.row];
    [tableView reloadData];
    
}












@end























