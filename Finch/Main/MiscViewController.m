//
//  MiscViewController.m
//  Finch
//
//  Created by Eugene Dorfman on 3/25/13.
//
//

#import "MiscViewController.h"
#import "TableModel.h"

@interface MiscViewController ()
@property (nonatomic,strong) TableModel* tableModel;
@end

@implementation MiscViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableModel = [TableModel new];
    self.tableView.delegate = self.tableModel;
    self.tableView.dataSource = self.tableModel;

    [self.tableModel addSection:@{kSectionCellModels: @[
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Help",
             kCellAccessoryType:@(UITableViewCellAccessoryDisclosureIndicator),
        },
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Contact Support",
        },
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Rate This App",
        }
     ]}];
}

@end