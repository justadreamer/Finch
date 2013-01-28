//
//  SwitchCell.m
//  Finch
//
//  Created by Eugene Dorfman on 1/27/13.
//
//

#import "SwitchCell.h"
#import "SwitchCellAdapter.h"

@interface SwitchCell()
@property (nonatomic,strong) IBOutlet UILabel* label;
@property (nonatomic,strong) IBOutlet UISwitch* switcher;
@property (nonatomic,weak)SwitchCellAdapter* switchCellAdapter;
@end

@implementation SwitchCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void) setSwitcher:(UISwitch *)switcher {
    [_switcher removeTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
    _switcher = switcher;
    [_switcher addTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) updateWithAdapter:(SwitchCellAdapter*)adapter {
    self.switchCellAdapter = adapter;
    self.label.text = [adapter mainText];
    [self.switcher setOn:[adapter isOn]];
}

- (void) switcherValueChanged:(UISwitch*)switcher {
    [self.switchCellAdapter setIsOn:switcher.isOn];
}

@end