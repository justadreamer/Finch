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
#import "IfaceCellModelAdapter.h"
#import "BaseCell.h"
#import "ShareCellModelAdapter.h"

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
    BOOL isBonjour = [Helper instance].isBonjourPublished;

    NSArray* cellsBonjour = isBonjour ? @[
        @{kModel : [Helper instance].bonjourName, kCellId:@"Bonjour", kTag:@(SEC_BONJOUR)}
    ] : @[];

    NSMutableArray* cellsIfaces = [NSMutableArray array];
    IfaceCellModelAdapter* ifaceCellModelAdapter = [IfaceCellModelAdapter new];
    for (Iface* iface in self.ifaces) {
        [cellsIfaces addObject:@{
                      kCellId : @"Interfaces",
                   kCellStyle : @(UITableViewCellStyleSubtitle),
                       kModel : iface,
                     kAdapter : ifaceCellModelAdapter
         }];
    }
    
    ShareCellModelAdapter* shareCellModelAdapter = [ShareCellModelAdapter new];
    NSMutableArray* cellsShares = [NSMutableArray array];
    for (Share* share in [SharesProvider instance].shares) {
        [cellsShares addObject:@{
                      kCellId : @"ShareCell",
               kNibNameToLoad : @"ShareCell",
               kCellClassName : @"ShareCell",
                       kModel : share,
                    kAdapter  : shareCellModelAdapter}];
    }

    NSString* enterUrlString = @"enter an URL (WiFi preferable) in the browser address bar:";
    
    NSArray* sections = @[
        isBonjour ?
        @{kTitle : @"Either use a Bonjour enabled browser:", kCells: cellsBonjour} : [NSNull null],
        @{kTitle : !isBonjour ? [enterUrlString capitalized1WordString] : [@"or " stringByAppendingString:enterUrlString],kCells:cellsIfaces},
        @{kTitle : @"You are sharing:", kCells:cellsShares}
    ];
    self.tableModel = [TableModel new];
    [self.tableModel setSectionsFromArray:sections];

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

    BaseCell* cell = (BaseCell*) [tableView dequeueReusableCellWithIdentifier:[cellModel cellIdentifier]];
    if (nil==cell) {
        cell = [cellModel createCell];
    }
    [cell updateWithAdapter:[cellModel adapter]];
    if (cellModel.tag == SEC_BONJOUR) {
        cell.textLabel.text = (NSString*)cellModel.model;
    }
    return cell;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    SectionModel* sectionModel = [self.tableModel sectionModelForSection:section];
    return sectionModel.titleForHeader;
}

@end