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
#import "AlbumShare.h"
#import "AlbumShareSectionHeader.h"

NSString* const kPictureViewCell = @"PictureViewCell";
NSString* const kHeader = @"Header";

const CGFloat spacing = 4.0;

@interface PicturesPrivateViewController () <UICollectionViewDelegateFlowLayout,TransparentTouchViewDelegate>
@property (nonatomic,strong) TransparentTouchView* touchView;
@end

@implementation PicturesPrivateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PictureViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kPictureViewCell];

    [self.collectionView registerClass:[AlbumShareSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeader];
    
    self.collectionView.backgroundColor = COLOR_TABLE_BACKGROUND;
    
    self.touchView = [[TransparentTouchView alloc] initWithFrame:self.view.bounds];
    self.touchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.touchView.scrollViewToPreventScrolling = self.collectionView;
    self.touchView.delegate = self;

    [self.view addGestureRecognizer:self.touchView.recognizer];
    [self.view addSubview:self.touchView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.albumShare numberOfPictures];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPictureViewCell forIndexPath:indexPath];
    ALAssetShare* assetShare = [self.albumShare.assetShares objectAtIndex:indexPath.row];
    cell.assetShare = assetShare;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView* reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        AlbumShareSectionHeader* albumShareSectionHeader = (AlbumShareSectionHeader*) [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeader forIndexPath:indexPath];
        albumShareSectionHeader.albumShare = self.albumShare;
        reusableView = albumShareSectionHeader;
    }
    return reusableView;
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 100);
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