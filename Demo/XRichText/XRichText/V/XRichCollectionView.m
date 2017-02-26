//
//  XRichCollectionView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichCollectionView.h"
#import "XRichCollectionViewFlowLayout.h"

static NSString *ImageCellIdentify = @"ImageCellIdentify";
static NSString *TextCellIdentify = @"TextCellIdentify";

@implementation XRichCollectionView
{
    NSIndexPath *dragIndexPath;
    NSIndexPath *moveToIndexPath;  //交换后的indexpath，防止重复交换
    UICollectionViewFlowLayout *_layout;
    NSDictionary *_selectedData;   //选中的数据源
   
}
-(id)initWithFrame:(CGRect)frame collectionViewLayout:(XRichCollectionViewFlowLayout *)layout{
    _layout = [UICollectionViewFlowLayout new];
    self = [super initWithFrame:frame collectionViewLayout:_layout];
   // _layout = layout;
    [self initUI];
    return self;
}
-(void)initUI{
    _dataArray = [@[] mutableCopy];
    self.backgroundColor = [UIColor whiteColor];
    [self registerClass:[XRichTextImageCell class] forCellWithReuseIdentifier:ImageCellIdentify];
    [self registerClass:[XRichTextCell class] forCellWithReuseIdentifier:TextCellIdentify];
    self.delegate = self;
    self.dataSource = self;
    [XKeyBoard registerKeyBoardHide:self];
    [XKeyBoard registerKeyBoardShow:self];
   
}

/*
 * 添加图片
 */
-(void)addImage:(UIImage *)image{
    image = [image imageCompress:1000];
    NSMutableDictionary *data = [@{@"flag":@"1",@"height":@(image.size.height),@"width":@(image.size.width),@"image":image} mutableCopy];
    [_dataArray addObject:data];
    [self reloadData];
}
/*
 * 添加文字
 */
-(void)addText:(NSString *)text{
    NSMutableDictionary *data = [@{@"flag":@"2",@"height":@(60),@"text":text} mutableCopy];
    [_dataArray addObject:data];
    [self reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *data = _dataArray[indexPath.row];
    if ([data[@"flag"] isEqualToString:@"1"]) {   //表明是图片
        XRichTextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCellIdentify forIndexPath:indexPath];
        cell.dataSource = data;
        //添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [cell addGestureRecognizer:longGesture];
        return cell;
    }else{
        __weak XRichCollectionView *wself = self;
        XRichTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TextCellIdentify forIndexPath:indexPath];
        cell.dataSource = data;
        cell.delegate = self;
        cell.refreshBlock = ^{
            [wself reloadData];
        };
        //添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [cell addGestureRecognizer:longGesture];

        return cell;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wid = self.frame.size.width-30;
    NSDictionary *dict = _dataArray[indexPath.item];
    if ([dict[@"flag"] isEqualToString:@"1"]) {
        NSNumber *height = dict[@"height"];
        NSNumber *width = dict[@"width"];
        return CGSizeMake(wid, wid*height.floatValue/width.floatValue);
    }else{
        NSNumber *height = dict[@"height"];
        return CGSizeMake(wid, height.floatValue);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 15, 15);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
/*
 * cell点击事件
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    //获取cell相对屏幕的位置
    CGRect cellRect = [self convertRect:cell.frame toView:self];
    NSLog(@"x:%f,y:%f",cellRect.origin.x,cellRect.origin.y);
    [cell becomeFirstResponder];
    _selectedData = _dataArray[indexPath.row];
    [self showMenu:cellRect];
}
-(void)showMenu:(CGRect)cellRect{
   
    UIMenuController *menu = [UIMenuController sharedMenuController];
    menu.menuItems = @[
                       [[UIMenuItem alloc]initWithTitle:@"剪裁" action:@selector(cutImage)],
                       [[UIMenuItem alloc]initWithTitle:@"替换" action:@selector(replaceImage)],
                       [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteImage)],
                       ];
    [self becomeFirstResponder];
    [menu setTargetRect:cellRect inView:self];
    [menu setMenuVisible:true animated:true];
}
-(void)replaceImage{
    
}
-(void)cutImage{
    
}
-(void)deleteImage{
    [_dataArray removeObject:_selectedData];
    [self reloadData];
}
#pragma  mark - KeyBoardDlegate

-(void)keyboardWillHideNotification:(NSNotification *)notification{
    double keyboardDuration = [XKeyBoard returnKeyBoardDuration:notification];
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self setContentInset:UIEdgeInsetsZero];
    }];
}
-(void)keyboardWillShowNotification:(NSNotification *)notification{
    
    CGRect keyboardWindow = [XKeyBoard returnKeyBoardWindow:notification];
    double keyboardDuration = [XKeyBoard returnKeyBoardDuration:notification];
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self setContentInset:UIEdgeInsetsMake(0, 0, keyboardWindow.size.height, 0)];
        
    }];
}

#pragma mark - XRichTextCellDelegate
-(void)textHeightChange{
    [_collectionDelegate textHeightChange];
    [_layout invalidateLayout];
}



- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSIndexPath *indexPath = [self indexPathForCell:(UICollectionViewCell *)longGesture.view];
            dragIndexPath = indexPath;
            NSLog(@"开始拖动:%ld",(long)dragIndexPath.item);
         //   [self beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
         //   NSInteger item = [_collectionDelegate returnTheItemSelected:[longGesture locationInView:self].y];
        //    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longGesture locationInView:self]];
            if (!indexPath) {
                NSLog(@"cell 不存在");
                return;
            }
            if (dragIndexPath.item != indexPath.item) {
                NSLog(@"交换：%ld and %ld",(long)dragIndexPath.item,indexPath.item);
                
                [self replaceData:dragIndexPath.item toItem:indexPath.item];
                [self moveItemAtIndexPath:dragIndexPath toIndexPath:indexPath];
                [self updateInteractiveMovementTargetPosition:[longGesture locationInView:self]];
                moveToIndexPath = indexPath;
                dragIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self endInteractiveMovement];
            break;
        default:
            [self cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return false;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
}
-(void)replaceData:(NSInteger)item toItem:(NSInteger)toItem{
    //取出源item数据
    id objc = [_dataArray objectAtIndex:item];
    //从资源数组中移除该数据
    [_dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataArray insertObject:objc atIndex:toItem];
    [_collectionDelegate textHeightChange];
   
}


/*
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longGesture locationInView:self]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
            //移动过程当中随时更新cell位置
            [self updateInteractiveMovementTargetPosition:[longGesture locationInView:self]];
            break;
        case UIGestureRecognizerStateEnded:
            //移动结束后关闭cell移动
            [self endInteractiveMovement];
            break;
        default:
            [self cancelInteractiveMovement];
            break;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //返回YES允许其item移动
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    //取出源item数据
    id objc = [_dataArray objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [_dataArray removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataArray insertObject:objc atIndex:destinationIndexPath.item];
}
 */
@end









@implementation UIImage(Extension)
/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *) imageCompress:(CGFloat)targetWidth
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
