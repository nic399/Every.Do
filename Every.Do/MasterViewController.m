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

@property NSMutableArray <ToDo *> *objects;
@property (nonatomic, strong, readwrite) NSMutableArray <NSMutableArray *> *dataSourceArr;
@property (nonatomic, strong) UISegmentedControl *sortByControl;

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
    self.dataSourceArr = [NSMutableArray new];
    self.dataSourceArr[0] = [NSMutableArray new];
    self.dataSourceArr[1] = [NSMutableArray new];
    
    for (int i = 0; i < 20; i++) {
        ToDo *item = [[ToDo alloc] initWithTitle:[NSString stringWithFormat:@"ToDo %d", i] description:[NSString stringWithFormat:@"Description %d", i] priority:i*91%73 deadline:[[NSDate date] dateByAddingTimeInterval:( (arc4random_uniform(60000)+1) *60)]];
        [self.objects insertObject:item atIndex:0];
    }
    UISegmentedControl *sortViewBy = [[UISegmentedControl alloc] initWithItems:@[@"Priority", @"Deadline"]];
    [sortViewBy addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    sortViewBy.selectedSegmentIndex = 0;
    self.navigationItem.titleView = sortViewBy;
    self.sortByControl = sortViewBy;
    [self sortByParameter:sortViewBy];
    [self.tableView reloadData];
}

-(void)segmentChanged:(UISegmentedControl *)sender {
    NSLog(@"Segment changed");
    

    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.objects = [[self.objects sortedArrayUsingSelector:@selector(comparePriority:)] mutableCopy];
            break;
        }
        case 1: {
            self.objects = [[self.objects sortedArrayUsingSelector:@selector(compareDeadline:)] mutableCopy];
            break;
        }
        default:
            break;
    }
    
    
    [self sortByParameter:sender];
}

-(void)sortByParameter:(UISegmentedControl *) sender {
    self.dataSourceArr[0] = [NSMutableArray new];
    self.dataSourceArr[1] = [NSMutableArray new];
    
    for (ToDo *item in self.objects) {
        if (item.complete) {
            [self.dataSourceArr[1] addObject:item];
        }
        else {
            [self.dataSourceArr[0] addObject:item];
        }
    }
    
    
    
    
    
    switch (sender.selectedSegmentIndex) {
        case 0: {
            self.dataSourceArr[0] = [[self.dataSourceArr[0] sortedArrayUsingSelector:@selector(comparePriority:)] mutableCopy];
            self.dataSourceArr[1] = [[self.dataSourceArr[1] sortedArrayUsingSelector:@selector(comparePriority:)] mutableCopy];

            [self.tableView reloadData];
            break;
        }
        case 1: {
            self.dataSourceArr[0] = [[self.dataSourceArr[0] sortedArrayUsingSelector:@selector(compareDeadline:)] mutableCopy];
            self.dataSourceArr[1] = [[self.dataSourceArr[1] sortedArrayUsingSelector:@selector(compareDeadline:)] mutableCopy];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
    
    
    
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
        [self sortByParameter:self.sortByControl];
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
        ToDo *object = self.dataSourceArr[indexPath.section][indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailItem:object];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSourceArr[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In tableViewCellForRowAtIndexPath");
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self.tableView registerNib:[UINib nibWithNibName:@"ToDoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    ToDoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    
    
    
    NSArray *sectionArr = self.dataSourceArr[indexPath.section];
    ToDo *object = sectionArr[indexPath.row];
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
        [self.objects removeObject:self.dataSourceArr[indexPath.section][indexPath.row]];
        [self sortByParameter:self.sortByControl];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *completed = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDefault) title:@"Done" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ToDo *currentItem = [self.dataSourceArr[indexPath.section] objectAtIndex:indexPath.row];
        currentItem.complete = !currentItem.complete;
        [self sortByParameter:self.sortByControl];
        
        [self.tableView setEditing:false];
        [self.tableView reloadData];
    }];
    completed.backgroundColor = [UIColor greenColor];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
        
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"To Do";
            break;
        }

        case 1: {
            return @"Done";
            break;
        }

        default:
            return @"";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont boldSystemFontOfSize:36];
    CGRect headerFrame = header.frame;
    header.textLabel.frame = headerFrame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    switch (section) {
        case 0: {
            view.tintColor = [UIColor redColor];
            break;
        }
            
        case 1: {
            view.tintColor = [UIColor greenColor];

            break;
        }
            
        default:
            break;
    }

}







@end























