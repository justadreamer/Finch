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
#import "TransparentTouchView.h"

NSString* const kPictureViewCell = @"PictureViewCell";
const CGFloat spacing = 4.0;

@interface PicturesPrivateViewController () <UICollectionViewDelegateFlowLayout,TransparentTouchViewDelegate>
@property (nonatomic,strong) TransparentTouchView* touchView;
@end

@implementation PicturesPrivateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kPictureViewCell];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.touchView = [[TransparentTouchView alloc] initWithFrame:self.view.bounds];
    self.touchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.touchView.scrollViewToPreventScrolling = self.collectionView;
    self.touchView.delegate = self;

    [self.view addGestureRecognizer:self.touchView.recognizer];
    [self.view addSubview:self.touchView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.picturesShare.assetShares count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPictureViewCell forIndexPath:indexPath];
    ALAssetShare* assetShare = [self.picturesShare.assetShares objectAtIndex:indexPath.row];
    cell.assetShare = assetShare;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75, 75);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return spacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return spacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
}

#pragma mark - TransparentTouchViewDelegate 

- (void) transparentTouchView:(TransparentTouchView*)transparentTouchView didEndTouchesWithPoints:(NSArray*)points {
    NSSet* cells = [transparentTouchView view:self.view subviewsOfClass:[PictureViewCell class] underPoints:points];
    for (PictureViewCell* cell in cells) {
        ALAssetShare* asset = cell.assetShare;
        asset.isPrivate = !asset.isPrivate;
        [cell refresh];
    }
}

@end