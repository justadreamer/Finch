//
//  MiscViewController.m
//  Finch
//
//  Created by Eugene Dorfman on 3/25/13.
//
//

#import "MiscViewController.h"
#import "TableModel.h"
#import "HelpViewController.h"

#import <MessageUI/MessageUI.h>

@interface MiscViewController ()<MFMailComposeViewControllerDelegate>

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
    NSString* verString = [NSString stringWithFormat:@"Finch v.%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    __weak MiscViewController* safeSelf = self;
    [self.tableModel addSection:@{kSectionCellModels: @[
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Help",
             kCellAccessoryType:@(UITableViewCellAccessoryDisclosureIndicator),
                   kCellOnClick:
     
            ^{
        
        HelpViewController* helpViewController = [HelpViewController new];
        [safeSelf.navigationController pushViewController:helpViewController animated:YES];
        
        
            }
        },
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Contact Support",
                   kCellOnClick:

            ^{
                [safeSelf presentMailComposer];
            }
        },
        @{
                     kCellStyle:@(UITableViewCellStyleDefault),
                     kCellTitle:@"Rate This App",
                   kCellOnClick:
     
            ^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=636279394&mt=8"]];
            }

        }
     ],
         kSectionTitleForFooter:verString}];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) presentMailComposer {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* composer = [[MFMailComposeViewController alloc] init];
        [composer setToRecipients:@[SUPPORT_EMAIL]];
        [composer setSubject:@"[Finch] "];
        [composer setMessageBody:@"--Please, keep [Finch] in the subject line--" isHTML:NO];
        [composer setMailComposeDelegate:self];
        [composer.navigationBar setTintColor:COLOR_NAV_BACKGROUND];
        [self presentViewController:composer animated:YES completion:nil];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"For contacting support you need to setup Mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
@end