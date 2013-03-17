//
//  ShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShareController.h"
#import "Share.h"
#import "PasteboardShare.h"
#import "TextShare.h"
#import "PicturesShare.h"
#import "PasteboardShareController.h"
#import "TextShareController.h"
#import "PicturesShareController.h"
#import "ShareSwitchCellAdapter.h"

@interface ShareController ()

@end

@implementation ShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.share.name;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = COLOR_TABLE_BACKGROUND;
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (ShareController*) controllerWithShare:(Share*)share {
    NSDictionary* controllerToShare = @{
        (id<NSCopying>)[PasteboardShare class] : [PasteboardShareController class],
        (id<NSCopying>)[TextShare class] : [TextShareController class],
        (id<NSCopying>)[PicturesShare class] : [PicturesShareController class]
    };

    ShareController* shareController = nil;
    Class controllerClass = [controllerToShare objectForKey:[share class]];
    if (Nil!=controllerClass) {
        shareController = [[controllerClass alloc] initWithStyle:UITableViewStyleGrouped];
        shareController.share = share;
    }

    return shareController;
}

- (void) refresh {
    [self initTableModel];
    [self.tableView reloadData];
}

- (void)switchValueChanged:(UISwitch*)sender {
    self.share.isShared = sender.isOn;
}

- (void)setShare:(Share *)share {
    _share = share;
    [self initTableModel];
}

- (void) initTableModel {
    self.tableModel = [TableModel new];
    [self.tableModel addSection:@{
                         kSectionCellModels: @[
     @{
                kCellClassName : @"SwitchCell",
                kCellNibName : @"SwitchCell",
                      kCellAdapter : [ShareSwitchCellAdapter new],
                        kCellModel : self.share
     }
     ]
     }];
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

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.tableModel tableView:tableView titleForFooterInSection:section];
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.tableModel tableView:tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath];
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableModel tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}
@end