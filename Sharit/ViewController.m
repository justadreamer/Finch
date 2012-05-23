//
//  ViewController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "NSStringAdditions.h"
#import "ViewController.h"
#import "Helper.h"
#import "Iface.h"
#import "SharesProvider.h"
#import "ShareCell.h"
#import "Share.h"
#import "ShareController.h"

const NSInteger SEC_IFACES = 0;
const NSInteger SEC_SHARED = 1;

@interface ViewController ()
@property (nonatomic,strong) NSArray* ifaces;
@property (nonatomic,assign) UInt16 port;

- (NSString*) urlFromIPAddress:(NSString*)ipAddress;
@end

@implementation ViewController
@synthesize mainTableView;
@synthesize ifaces;
@synthesize port;
@synthesize sharesProvider;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SharIt";
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewWillAppear:(BOOL)animated {
    [self.mainTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) refresh {
    self.ifaces = [Helper interfaces];
    self.port = [Helper port];
    [self.mainTableView reloadData];
}

- (void) sharesRefreshed {
    if (self.navigationController.topViewController == self) {
        [self.mainTableView reloadData];
    } else {
        if ([self.navigationController.topViewController respondsToSelector:@selector(sharesRefreshed)]) {
            [(id)self.navigationController.topViewController sharesRefreshed];
        }
    }
}

- (NSString*) urlFromIPAddress:(NSString*)ipAddress {
    return [NSString stringWithFormat:@"http://%@:%d",ipAddress,self.port];
}

- (NSString*) interfaceNameFromLinkName:(NSString*)name {
    NSString* ifaceName = @"WWAN";
    if ([name contains:@"en"]) {
        ifaceName = @"Local WiFi";
    }
    return ifaceName;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];

    if (SEC_SHARED == indexPath.section) {
        Share* share = [[[SharesProvider instance] shares] objectAtIndex:indexPath.row];
        ShareController* shareController = [ShareController controllerWithShare:share];
        if (shareController) {
            [self.navigationController pushViewController:shareController animated:YES];
        }
    }
}

#pragma mark - 
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (SEC_IFACES==section) {
        count = [self.ifaces count];
    } else if (SEC_SHARED==section) {
        count = [self.sharesProvider.shares count];
    }
    return count;
}

- (UITableViewCell*) createCellForSection:(NSInteger)section reuseIdentifier:(NSString*)identifier{
    UITableViewCell* cell = nil;
    if (SEC_IFACES==section) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    } else if (SEC_SHARED==section) {
        NSArray* nibArray = [[NSBundle mainBundle] loadNibNamed:@"ShareCell" owner:nil options:nil];
        if ([nibArray count]>0) {
            cell = [nibArray objectAtIndex:0];
        }
    }
    return cell;
}

- (void) setupCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == SEC_IFACES) {
        Iface* iface = [self.ifaces objectAtIndex:indexPath.row];
        cell.textLabel.text = [self urlFromIPAddress:iface.ipAddress];
        cell.detailTextLabel.text = [self interfaceNameFromLinkName:iface.name];
    } else if (indexPath.section == SEC_SHARED) {
        ShareCell* shareCell = (ShareCell*)cell;
        shareCell.share = [[SharesProvider instance].shares objectAtIndex:indexPath.row];
        [shareCell refresh];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* const identifier = [NSString stringWithFormat:@"Cell%d",indexPath.section];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil==cell) {
        cell = [self createCellForSection:indexPath.section reuseIdentifier:identifier];
    }
    [self setupCell:cell forIndexPath:indexPath];

    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* title = nil;
    if (SEC_IFACES==section) {
        if ([self.ifaces count]>0) {
            title=@"Enter an URL (WiFi preferable) in the browser address bar on another device:";
        } else {
            title=@"There are no wireless links available. Please check your settings.";
        }
    } else if (SEC_SHARED==section) {
        title=@"You are sharing:";
    }
    return title;
}

@end