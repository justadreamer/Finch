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
#import "MiscViewController.h"

const NSInteger SEC_BONJOUR = 3;

@interface MainViewController ()
@property (nonatomic,strong) TableModel* tableModel;
@property (nonatomic,strong) NSArray* ifaces;
@end

@implementation MainViewController

- (UIView*)titleView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finch-text"]];
}

- (UIBarButtonItem*) leftItem {    
    CGFloat dx = 5;
    UIImage* finchImage = [UIImage imageNamed:@"finch-icon"];
    CGRect frame = CGRectMake(0, 0, finchImage.size.width+dx, finchImage.size.height);
    UIButton* button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:finchImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Finch";

    self.navigationItem.titleView = [self titleView];
    self.navigationController.navigationBar.tintColor = COLOR_NAV_BACKGROUND;

    [[UIBarButtonItem appearance] setTitleTextAttributes:NAV_TEXT_ATTRIBUTES forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:NAV_TEXT_ATTRIBUTES forState:UIControlStateHighlighted];
    [[UINavigationBar appearance] setTitleTextAttributes:NAV_TEXT_ATTRIBUTES];

    self.navigationItem.leftBarButtonItem = [self leftItem];

    self.mainTableView.backgroundView = nil;
    self.mainTableView.backgroundColor = COLOR_TABLE_BACKGROUND;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

    [CellModel setDefaultBackgroundColor:COLOR_CELL_BACKGROUND];

    for (Iface* iface in self.ifaces) {
        [cellsIfaces addObject:@{
                   kCellStyle : @(UITableViewCellStyleSubtitle),
                   kCellModel : iface,
                 kCellAdapter : ifaceCellModelAdapter,
         }];
    }

    NSMutableArray* cellsShares = [NSMutableArray array];
    for (Share* share in [SharesProvider instance].shares) {
        [cellsShares addObject:@{
                 kCellNibName : @"ShareCell",
            kCellAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator),
                   kCellModel : share,
          kCellDetailTextColor:COLOR_FINCH_TITLE,}];
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

#pragma mark - UITableViewDelegate
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
    return [self.tableModel numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableModel tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableModel tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tableModel tableView:tableView titleForHeaderInSection:section];
}

#pragma mark -

- (void) leftItemTapped:(UIBarButtonItem*)barButtonItem {
    MiscViewController* miscController = [[MiscViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:miscController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    navController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    miscController.navigationItem.titleView = [self titleView];
    miscController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelMisc:)];

    [self presentViewController:navController animated:YES completion:nil];
}

- (void) cancelMisc:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end