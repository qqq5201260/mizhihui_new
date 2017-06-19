//
//  SRCalendarSwipeView.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/7/9.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "SRCalendarSwipeView.h"
#import "SRCalendarLabel.h"
#import <DateTools/DateTools.h>

const NSInteger showingItems = 5;
const NSInteger totalItems = 9;
const NSInteger centerPosition = 4;
const NSInteger startPosition = 2;
const NSInteger endPosition = 6;

const NSInteger TAG_Label = 100;

@interface SRCalendarSwipeView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) UIView *indicatorView;

@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation SRCalendarSwipeView
{
    NSInteger tempCenterPosition;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self bottomLine];
        
        [self addSubview:self.collectionView];
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        [self addSubview:self.indicatorView];
        [self.indicatorView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.width/showingItems);
            make.height.equalTo(3.0f);
            make.centerX.bottom.equalTo(self);
        }];
    
        self.selectedDate = [NSDate date];
        
        tempCenterPosition = centerPosition;
        
        
    }
         
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scrollCollectionViewToPosition:startPosition animation:NO];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //重置视图
    tempCenterPosition = centerPosition;
    [self scrollCollectionViewToPosition:startPosition animation:NO];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return totalItems;
}

static NSString * const reuseIdentifier = @"Cell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    
    SRCalendarLabel *label = [self labelFromCell:cell];
    
    //根据cell位置计算时间
    NSInteger cellPosition = indexPath.item;
    NSDate *date = [self.selectedDate dateByAddingDays:cellPosition - tempCenterPosition];
    label.textColor = [date isSameDay:self.selectedDate]?[UIColor defaultColor]:[UIColor blackColor];
    label.date = [date isLaterThan:[NSDate date]]?nil:date;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    SRCalendarLabel *label = [self labelFromCell:cell];
    if (!label.date || [label.date isSameDay:self.selectedDate]) return;
    
    //更新Cell及最新时间
    UICollectionViewCell *centerCell = [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:centerPosition inSection:0]];
    [self labelFromCell:centerCell].textColor = [UIColor blackColor];
    label.textColor = [UIColor defaultColor];
    self.selectedDate = label.date;
    
    //更新位置
    NSInteger position = indexPath.item;
    tempCenterPosition = position;
    
    NSInteger delta = position - centerPosition;
    
    [self scrollCollectionViewToPosition:startPosition + delta animation:YES];
    
    if (self.delegate) {
        [self.delegate calendarSwipeViewDidSelectedDate:self.selectedDate];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width/showingItems, collectionView.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark - Public

- (void)setDate:(NSDate *)date
{
    self.selectedDate = date;
    [self scrollCollectionViewToPosition:startPosition animation:NO];
}

#pragma mark - 私有方法

- (SRCalendarLabel *)labelFromCell:(UICollectionViewCell *)cell
{
    SRCalendarLabel *label = (SRCalendarLabel *)[cell viewWithTag:TAG_Label];
    if (!label) {
        label = [[SRCalendarLabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.tag = TAG_Label;
        label.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:label];
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(cell.contentView).with.offset(2.0f);
            make.bottom.right.equalTo(cell.contentView).with.offset(-2.0f);
        }];
    }
    
    return label;
}

- (void)scrollCollectionViewToPosition:(NSInteger)position animation:(BOOL)animation
{
    CGFloat contentOffset = position*(self.width/showingItems);
    [self.collectionView setContentOffset:CGPointMake(contentOffset, 0) animated:animation];
    
    if (position == startPosition) {
        [self.collectionView reloadData];
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (_collectionView) {
        return _collectionView;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.scrollEnabled = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    _collectionView = collectionView;
    
    return _collectionView;
}

- (UIView *)indicatorView {
    if (_indicatorView) {
        return _indicatorView;
    }
    
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    indicatorView.backgroundColor = [UIColor defaultColor];
    _indicatorView = indicatorView;
    
    return _indicatorView;
}

@end
