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

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)  UICollectionView *collectionView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
}

- (void)setupSubViews {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.clipsToBounds = NO;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 3.0;
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    contentView.backgroundColor = [UIColor redColor];
    contentView.frame = self.view.bounds;
    self.contentView = contentView;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 200);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionReusedId"];
    collectionView.clipsToBounds = NO;
    [contentView addSubview:collectionView];
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(contentView);
    }];
}

#pragma mark - UICollectionViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        return self.contentView;
    }
    return nil;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView == self.scrollView) {
        CGSize endScaleContentSize = scrollView.contentSize;
        CGFloat insetBottom = (endScaleContentSize.height - scrollView.bounds.size.height) / scale;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, insetBottom, 0);
        CGSize zeroSize = CGSizeMake(endScaleContentSize.width, 0);
        CGPoint lastOffset = self.scrollView.contentOffset;
        self.scrollView.contentSize = zeroSize;
        // 修复偏移
        CGFloat newOffsetX = self.collectionView.contentOffset.x;
        CGFloat newOffsetY = self.collectionView.contentOffset.y + lastOffset.y / scale;
        CGPoint newOffset = CGPointMake(newOffsetX, newOffsetY);
        [self.collectionView setContentOffset:newOffset animated:NO];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseKey = @"collectionReusedId";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseKey forIndexPath:indexPath];
    cell.contentView.backgroundColor = [self randomColor];
    NSInteger tag = 999;
    UILabel *backLabel = [cell.contentView viewWithTag:tag];
    if (!backLabel) {
        backLabel = [[UILabel alloc] init];
        backLabel.tag = tag;
        backLabel.frame = CGRectMake(10, 10, 100, 50);
        [cell.contentView addSubview:backLabel];
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
