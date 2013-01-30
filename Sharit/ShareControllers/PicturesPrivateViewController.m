//
//  PicturesPrivateViewController.m
//  Finch
//
//  Created by Eugene Dorfman on 1/31/13.
//
//

#import "PicturesPrivateViewController.h"
#import "PicturesShare.h"
#import "ALAssetShare.h"
#import "PictureViewCell.h"

NSString* const kPictureViewCell = @"PictureViewCell";

@interface PicturesPrivateViewController ()

@end

@implementation PicturesPrivateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"PictureViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kPictureViewCell];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.picturesShare.assetShares count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureViewCell" forIndexPath:indexPath];
    ALAssetShare* assetShare = [self.picturesShare.assetShares objectAtIndex:indexPath.row];
    [cell setImage:assetShare.image];
    return cell;
}

@end