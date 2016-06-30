//
//  AboutTableViewController.m
//  BrainFights
//
//  Created by Artem Demidovich on 12/11/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import "AboutTableViewController.h"

#import "AboutInformationHeaderTableViewCell.h"
#import "AboutInformationContentTableViewCell.h"
#import "AboutInformationFooterTableViewCell.h"


@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)showMenuAction:(UIBarButtonItem *)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        AboutInformationHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationHeaderCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AboutInformationHeaderTableViewCell" bundle:nil]forCellReuseIdentifier:@"AboutInformationHeaderCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationHeaderCell"];
        }
        return cell;
    }
    
    if (indexPath.row == 1) {
        AboutInformationContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationContentCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AboutInformationContentTableViewCell" bundle:nil]forCellReuseIdentifier:@"AboutInformationContentCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationContentCell"];
        }
        return cell;
    }

    if (indexPath.row == 2) {
        AboutInformationContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationFooterCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AboutInformationFooterTableViewCell" bundle:nil]forCellReuseIdentifier:@"AboutInformationFooterCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"AboutInformationFooterCell"];
        }
        return cell;
    }
    
    return nil;
}

static CGFloat HEIGHT = 504;
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat proportion = tableView.bounds.size.height / HEIGHT;
    if (indexPath.row == 0)
        return 160*proportion;
    if (indexPath.row == 1)
        return 260*proportion;
    if (indexPath.row == 2) {
        //CGFloat proportion = tableView.bounds.size.height / HEIGHT;
        return tableView.bounds.size.height - 160*proportion - 260*proportion; // AUTO SIZE TO FULL SCREEN
    }
    return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
