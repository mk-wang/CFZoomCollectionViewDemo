//
//  ViewController.m
//  22-tableView-zoom
//
//  Created by Yu,Chuanfeng on 2019/7/9.
//  Copyright © 2019 Yu,Chuanfeng. All rights reserved.
//

#import "ViewController.h"
#import "ZoomTableView.h"
#import <Masonry.h>

@interface XXView : UIView

@end

@implementation XXView

@end

@interface XXCollectionView : UICollectionView <UIGestureRecognizerDelegate>
@end

@implementation XXCollectionView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] && [otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] ) {
        return  YES;
    }
    return NO;
}
@end


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)  UICollectionView *collectionView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.4];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_collectionView.superview == nil) {
        [self setupSubViews];
    }
}

- (void)setupSubViews {
    CGRect rect = self.view.bounds;
    
    CGFloat topOffset = self.view.safeAreaInsets.top;
    CGFloat bottemOffset = self.view.safeAreaInsets.bottom;
    
    rect.origin.y = topOffset;
    rect.size.height -= topOffset + bottemOffset;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.clipsToBounds = YES;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 6.0;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.insetsLayoutMarginsFromSafeArea = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    scrollView.bouncesZoom = NO;
    scrollView.bounces = NO;

    
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    rect.origin.y = 0;
    UIView *contentView = [[XXView alloc] init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor redColor];
    contentView.frame = rect;
    contentView.clipsToBounds = YES;
    self.contentView = contentView;    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
    
    UICollectionView *collectionView = [[XXCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionReusedId"];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.clipsToBounds = YES;
    collectionView.pagingEnabled = NO;
    collectionView.contentInset = UIEdgeInsetsZero;
    collectionView.insetsLayoutMarginsFromSafeArea = NO;
    collectionView.bouncesZoom = NO;
    collectionView.bounces = NO;
    collectionView.scrollEnabled = YES;
    
    
    [contentView addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
    collectionView.backgroundColor = UIColor.lightGrayColor;
}

#pragma mark - UICollectionViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        return self.contentView;
    }
    return nil;
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidZoom %@", scrollView);
//
//    if (scrollView != _scrollView) {
//        return ;
//    }
//
//    CGFloat scale = scrollView.zoomScale;
//    if (scale < 1.0) {
//        CGSize outSize = scrollView.bounds.size;
//        CGSize targetSize = outSize;
//
//        targetSize.width = outSize.width * scale;
//        targetSize.height = outSize.height;
//
//        CGRect rect = CGRectZero;
//        rect.size = targetSize;
//        rect.origin.x = (outSize.width - targetSize.width)/2;
//
//        _contentView.frame = rect;
//    } else {
//        CGSize outSize = scrollView.bounds.size;
//        CGSize targetSize = outSize;
//        targetSize.width = outSize.width * scale;
//        targetSize.height = outSize.height  * scale;
//
//        CGRect rect = CGRectZero;
//        rect.size = targetSize;
//        _contentView.frame = rect;
//    }
//    //    if (scrollView == _scrollView) {
//    //        CGSize imgViewSize = _contentView.bounds.size;
//    //
//    //        CGRect fr = CGRectMake(0, 0, 0, 0);
//    //        fr.size = imgViewSize;
//    //        _contentView.frame = fr;
//    //
//    //        CGSize scrSize = scrollView.frame.size;
//    //        float offx = (scrSize.width > imgViewSize.width ? (scrSize.width - imgViewSize.width) / 2 : 0);
//    //        float offy = (scrSize.height > imgViewSize.height ? (scrSize.height - imgViewSize.height) / 2 : 0);
//    //
//    //        scrollView.contentInset = UIEdgeInsetsMake(offy, offx, offy, offx);
//    //    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidScroll %@", scrollView);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"scrollViewDidEndZooming %@", scrollView);
    
    //    if (scrollView == self.scrollView) {
    //        CGSize endScaleContentSize = scrollView.contentSize;
    //        CGFloat insetBottom = (endScaleContentSize.height - scrollView.bounds.size.height) / scale;
    //        if (insetBottom < 0)  {
    //            insetBottom  = 0;
    //        }
    //
    ////        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, insetBottom, 0);
    //        CGSize zeroSize = CGSizeMake(endScaleContentSize.width, 0);
    //
    //        CGPoint lastOffset = self.scrollView.contentOffset;
    //        self.scrollView.contentSize = zeroSize;
    //        // 修复偏移
    //        CGFloat newOffsetX = self.collectionView.contentOffset.x;
    //        CGFloat newOffsetY = self.collectionView.contentOffset.y + lastOffset.y / scale;
    //        CGPoint newOffset = CGPointMake(newOffsetX, newOffsetY);
    //        [self.collectionView setContentOffset:newOffset animated:NO];
    //    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseKey = @"collectionReusedId";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseKey forIndexPath:indexPath];
    cell.contentView.backgroundColor = UIColor.whiteColor;
    NSInteger tag = 999;
    UILabel *backLabel = [cell.contentView viewWithTag:tag];
    if (!backLabel) {
        backLabel = [[UILabel alloc] init];
        backLabel.tag = tag;
        backLabel.font = [UIFont boldSystemFontOfSize:30];
        backLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:backLabel];
        backLabel.backgroundColor = self.randomColor;
        
        [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    backLabel.text = [NSString stringWithFormat:@"cell --- %zd", indexPath.row];
    return cell;
}

- (UIColor *)randomColor {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
@end
