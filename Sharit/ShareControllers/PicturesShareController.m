//
//  PicturesShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 9/10/12.
//
//

#import "PicturesShareController.h"
#import "Share.h"
#import "PicturesSharePrivateCellAdapter.h"
#import "CellModel.h"
#import "PicturesPrivateViewController.h"

@interface PicturesShareController ()
@property (nonatomic,strong) UILabel* warningLabel;
@end

const NSInteger kTagPrivatePics = 1;

@implementation PicturesShareController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //TODO:
    self.warningLabel.text = @"Please enable Location Services in order to share pictures";
    self.warningLabel.hidden = ![self.share isDetailsDescriptionAWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) initTableModel {
    [super initTableModel];
    PicturesSharePrivateCellAdapter* adapter = [PicturesSharePrivateCellAdapter new];
    adapter.mainText = @"Select private pics";

    [self.tableModel addSection:@{kSectionCellModels: @[@{
                           kTag: @(kTagPrivatePics),
                     kCellModel: self.share,
                   kCellAdapter: adapter,
                     kCellStyle: @(UITableViewCellStyleSubtitle),
             kCellAccessoryType: @(UITableViewCellAccessoryDisclosureIndicator)
        }
     ]}];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel* cellModel = [self.tableModel cellModelForIndexPath:indexPath];
    if (cellModel.tag==kTagPrivatePics) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        PicturesPrivateViewController* controller = [[PicturesPrivateViewController alloc] initWithCollectionViewLayout:layout];
        controller.picturesShare = (PicturesShare*)self.share;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
