//
//  PicturesShareController.m
//  Sharit
//
//  Created by Eugene Dorfman on 9/10/12.
//
//

#import "PicturesShareController.h"
#import "Share.h"
#import "CellModel.h"
#import "PicturesPrivateViewController.h"
#import "AlbumShare.h"
#import "PicturesShare.h"

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

    if ([self.share isDetailsDescriptionAWarning]) {
        self.tableModel = [TableModel new];

        BaseCellAdapter* adapter = [BaseCellAdapter new];
        adapter.mainText = @"Fix Settings";
        adapter.detailText = self.share.detailsDescription;
        adapter.detailTextColor = [UIColor redColor];

        [self.tableModel addSection:@{kSectionCellModels : @[@{
                        kCellStyle :@(UITableViewCellStyleSubtitle),
                       kCellAdapter:adapter,
         }
         ]}];
    } else {
        NSMutableArray* albumCells = [NSMutableArray new];

        for (AlbumShare* albumShare in [self picturesShare].albumShares) {
            [albumCells addObject:@{
                   kCellClassName:@"AlbumShareCell",
                     kCellNibName:@"AlbumShareCell",
                       kCellModel:albumShare,
               kCellAccessoryType:@(UITableViewCellAccessoryDisclosureIndicator)
             }];
        }

        [self.tableModel addSection:@{
             kSectionTitleForHeader: @"Albums:",
                 kSectionCellModels: albumCells
         }];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CellModel* cellModel = [self.tableModel cellModelForIndexPath:indexPath];
    if ([cellModel.model isKindOfClass:[AlbumShare class]]) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        PicturesPrivateViewController* controller = [[PicturesPrivateViewController alloc] initWithCollectionViewLayout:layout];
        AlbumShare* albumShare = (AlbumShare*)cellModel.model;
        controller.title = albumShare.name;
        controller.albumShare = albumShare;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (PicturesShare*) picturesShare {
    return (PicturesShare*) self.share;
}

@end