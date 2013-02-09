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
#import "TableModelConstants.h"
#import "IfaceBaseCellAdapter.h"
#import "BaseCell.h"
#import "ShareCellAdapter.h"

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
    self.ifaces = [[Helper instance] interfaces];

    NSMutableArray* cellsIfaces = [NSMutableArray array];
    IfaceBaseCellAdapter* ifaceCellModelAdapter = [IfaceBaseCellAdapter new];
    for (Iface* iface in self.ifaces) {
        [cellsIfaces addObject:@{
                   kCellStyle : @(UITableViewCellStyleSubtitle),
                   kCellModel : iface,
                 kCellAdapter : ifaceCellModelAdapter
         }];
    }

    ShareCellAdapter* shareCellModelAdapter = [ShareCellAdapter new];
    NSMutableArray* cellsShares = [NSMutableArray array];
    for (Share* share in [SharesProvider instance].shares) {
        [cellsShares addObject:@{
                 kCellNibName : @"ShareCell",
            kCellAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
                   kCellModel : share,
                 kCellAdapter : shareCellModelAdapter}];
    }

    NSArray* sections = @[
        @{kSectionTitleForHeader : @"Enter an URL (WiFi preferable) in the browser address bar:", kSectionCellModels:cellsIfaces},
        @{kSectionTitleForHeader : @"You are sharing:", kSectionCellModels:cellsShares}
    ];

    self.tableModel = [TableModel new];
    [self.tableModel setSectionsFromArray:sections];

    [self.mainTableView reloadData];

    //walk navigation stack to refresh the shares:
    for (UIViewController* controller in self.navigationController.viewControllers) {
        if (controller!=self && [controller respondsToSelector:@selector(refresh)]) {
            [controller performSelector:@selector(refresh)];
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

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tableModel tableView:tableView titleForHeaderInSection:section];
}

@end