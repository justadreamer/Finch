//
//  AlbumShareSectionHeader.m
//  Finch
//
//  Created by Eugene Dorfman on 3/17/13.
//
//

#import "AlbumShareSectionHeader.h"
#import "AlbumShare.h"
#import "TableModel.h"
#import "ShareSwitchCellAdapter.h"

@interface AlbumShareSectionHeader()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) TableModel* tableModel;
@property (nonatomic,strong) UILabel* label;
@end

@implementation AlbumShareSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = COLOR_TABLE_BACKGROUND;
        self.tableView.backgroundView = nil;
        self.tableModel = [TableModel new];
        self.tableView.delegate = self.tableModel;
        self.tableView.dataSource = self.tableModel;

        self.tableView.scrollEnabled = NO;
        [self addSubview:self.tableView];

        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, self.bounds.size.width, 20)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:17.0];
        self.label.shadowColor = [UIColor whiteColor];
        self.label.shadowOffset = CGSizeMake(0, 1.0);
        self.label.textColor = COLOR_SECTION_HEADER_TITLE;
        self.label.text = @"Mark private pictures:";
        [self addSubview:self.label];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setAlbumShare:(AlbumShare *)albumShare {
    _albumShare = albumShare;
    [self.tableModel reset];
    [self.tableModel addSection:@{kSectionCellModels:@[
        @{
                 kCellClassName:@"SwitchCell",
                   kCellNibName:@"SwitchCell",
                   kCellAdapter:[ShareSwitchCellAdapter new],
                     kCellModel:_albumShare
        }
     ]}];
    [self.tableView reloadData];
}

@end
