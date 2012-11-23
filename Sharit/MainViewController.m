//
//  ViewController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "NSStringAdditions.h"
#import "MainViewController.h"
#import "Helper.h"
#import "Iface.h"
#import "SharesProvider.h"
#import "ShareCell.h"
#import "Share.h"
#import "ShareController.h"
#import "GlobalDefaults.h"
#import "TableModel.h"
#import "SectionModel.h"
#import "CellModel.h"

const NSInteger SEC_IFACES = 1;
const NSInteger SEC_SHARED = 2;
const NSInteger SEC_BONJOUR = 3;

@interface MainViewController ()
@property (nonatomic,strong) TableModel* tableModel;
@property (nonatomic,strong) NSArray* ifaces;
@end

@implementation MainViewController
@synthesize mainTableView;
@synthesize ifaces;
@synthesize sharesProvider;
@synthesize tableModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Finch";
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
    self.tableModel = [[TableModel alloc] init];
    if ([Helper instance].isBonjourPublished) {
        SectionModel* secBonjour = [[SectionModel alloc] init];
        secBonjour.titleForHeader = @"Either use a Bonjour enabled browser:";
        secBonjour.tag = SEC_BONJOUR;
        CellModel* cell = [[CellModel alloc] init];
        cell.model = [Helper instance].bonjourName;
        cell.cellIdentifier = @"Bonjour";
        cell.tag = SEC_BONJOUR;
        [secBonjour addCellModel:cell];
        [self.tableModel.sections addObject:secBonjour];
    }
    self.ifaces = [[Helper instance] interfaces];

    SectionModel* secInterfaces = [[SectionModel alloc] init];
    if ([self.ifaces count]>0) {
        SectionModel* prevSection = [self.tableModel.sections lastObject];
        NSString* enterUrlString = @"enter an URL (WiFi preferable) in the browser address bar:";
        if (prevSection.tag==SEC_BONJOUR)
            secInterfaces.titleForHeader=[@"or " stringByAppendingString:enterUrlString];
        else
            secInterfaces.titleForHeader=[enterUrlString capitalized1WordString];
        for (Iface* iface in self.ifaces) {
            CellModel* cellModel = [[CellModel alloc] initWithCellClass:[UITableViewCell class] model:iface identifier:@"Interfaces"];
            cellModel.cellStyle = UITableViewCellStyleSubtitle;
            cellModel.tag = SEC_IFACES;
            [secInterfaces addCellModel:cellModel];
        }
    } else {
        secInterfaces.titleForHeader=@"There are no wireless links available. Please check your settings.";
    }
    [self.tableModel.sections addObject:secInterfaces];
    
    if ([[SharesProvider instance].shares count]) {
        SectionModel* sharesSection = [[SectionModel alloc] init];
        sharesSection.titleForHeader = @"You are sharing:";
        
        for (Share* share in [SharesProvider instance].shares) {
            CellModel* cellModel = [[CellModel alloc] initWithCellClass:[ShareCell class] model:share identifier:@"ShareCell"];
            cellModel.nibNameToLoad = @"ShareCell";
            cellModel.tag = SEC_SHARED;
            [sharesSection addCellModel:cellModel];
        }

        [self.tableModel.sections addObject:sharesSection];
    }

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

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];

    Share* share = (Share*)[self.tableModel cellModelForIndexPath:indexPath].model;
    if ([share isKindOfClass:[Share class]]) {
        ShareController* shareController = [ShareController controllerWithShare:share];
        if (shareController) {
            [self.navigationController pushViewController:shareController animated:YES];
        }
    }
}

#pragma mark - 
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel* cellModel = [self.tableModel cellModelForIndexPath:indexPath];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[cellModel cellIdentifier]];
    if (nil==cell) {
        cell = [cellModel createCell];
    }

    if (cellModel.tag == SEC_IFACES) {
        Iface* iface = (Iface*)cellModel.model;
        cell.textLabel.text = [iface url];
        cell.detailTextLabel.text = iface.name;
    } else if (cellModel.tag == SEC_SHARED) {
        ShareCell* shareCell = (ShareCell*)cell;
        shareCell.share = (Share*) cellModel.model;
        [shareCell refresh];
    } else if (cellModel.tag == SEC_BONJOUR) {
        cell.textLabel.text = (NSString*)cellModel.model;
    }
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel* sectionModel = [self.tableModel sectionModelForSection:section];
    return sectionModel.titleForHeader;
}

@end