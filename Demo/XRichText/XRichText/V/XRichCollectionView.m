//
//  XRichCollectionView.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XRichCollectionView.h"
static NSString *ImageCellIdentify = @"ImageCellIdentify";
static NSString *TextCellIdentify = @"TextCellIdentify";

@implementation XRichCollectionView
{
    NSIndexPath *dragIndexPath;
    NSIndexPath *moveToIndexPath;  //交换后的indexpath，防止重复交换
    XCollectionViewFlowLayout *_layout;
    NSMutableDictionary *_selectedData;   //选中的数据源
    UICollectionViewCell *_selectedCell;  //选中的cell
   
}

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    _layout = (XCollectionViewFlowLayout *)layout;
    _layout.dataSource = self;
    _layout.delegate = self;
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    [_layout setCellCanMove];
    [self initUI];
    return self;
}
-(CGFloat)XCollectionViewItem:(NSIndexPath *)indexPath{
    CGFloat wid = self.frame.size.width-30;
    NSDictionary *dict = _dataArray[indexPath.item];
    if ([dict[@"flag"] isEqualToString:@"1"]) {
        NSNumber *height = dict[@"height"];
        NSNumber *width = dict[@"width"];
        return wid*height.floatValue/width.floatValue;
    }else{
        NSNumber *height = dict[@"height"];
        return height.floatValue;
    }
}
-(void)moveEndOldIndexPath:(NSIndexPath *)OldIndexPath toMoveIndexPath:(NSIndexPath *)moveIndexPath{
    id objc = [_dataArray objectAtIndex:OldIndexPath.item];
    [_dataArray removeObjectAtIndex:OldIndexPath.item];
    [_dataArray insertObject:objc atIndex:moveIndexPath.item];
    [_collectionDelegate textHeightChange];
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
        return cell;
    }else{
        __weak XRichCollectionView *wself = self;
        XRichTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TextCellIdentify forIndexPath:indexPath];
        cell.dataSource = data;
        cell.delegate = self;
        cell.refreshBlock = ^{
            [wself reloadData];
        };
        return cell;
    }
    
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
    _selectedCell = cell;
    [self showMenu:cellRect];
}
/*
 * 选中文本编辑框
 */
-(void)selectTextCell:(UITapGestureRecognizer *)tap{
    UICollectionViewCell *cell = (UICollectionViewCell *)[[tap.view superview] superview];
    //获取cell相对屏幕的位置
    CGRect cellRect = [self convertRect:cell.frame toView:self];
    NSLog(@"x:%f,y:%f",cellRect.origin.x,cellRect.origin.y);
    [cell becomeFirstResponder];
    _selectedData = _dataArray[[self indexPathForCell:cell].row];
    _selectedCell = cell;
    [self showMenu:cellRect];
}
-(void)showMenu:(CGRect)cellRect{
   
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if ([_selectedCell isKindOfClass:[XRichTextImageCell class]]) {
        menu.menuItems = @[
                           [[UIMenuItem alloc]initWithTitle:@"剪裁" action:@selector(cutImage)],
                           [[UIMenuItem alloc]initWithTitle:@"替换" action:@selector(replaceImage)],
                           [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteImage)],
                           ];
    }else{
        menu.menuItems = @[
                           [[UIMenuItem alloc]initWithTitle:@"编辑" action:@selector(editTextView)],
                           [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteTextView)],
                           ];
    }
    
    [self becomeFirstResponder];
    [menu setTargetRect:cellRect inView:self];
    [menu setMenuVisible:true animated:true];
}
-(void)replaceImage{
    [_collectionDelegate replaceImage:[self indexPathForCell:_selectedCell]];
}
-(void)replaceImage:(UIImage *)image indexPaht:(NSIndexPath *)indexPath{
    image = [image imageCompress:1000];
    _selectedData[@"image"] = image;
    _selectedData[@"height"] = @(image.size.height);
    _selectedData[@"width"] = @(image.size.width);
    [self reloadData];
}
-(void)cutImage{
    _selectedData[@"cut"] = @"1";
    [self reloadData];
}
-(void)deleteTextView{
    [_dataArray removeObject:_selectedData];
    [self reloadData];
}
-(void)editTextView{
    _selectedData[@"edit"] = @"1";
    XRichTextCell *cell = (XRichTextCell *)_selectedCell;
    cell.textView.userInteractionEnabled = true;
    [cell.textView becomeFirstResponder];
}
-(void)deleteImage{
    [_dataArray removeObject:_selectedData];
    [self reloadData];
}
#pragma  mark - KeyBoardDlegate

-(void)keyboardWillHideNotification:(NSNotification *)notification{
    double keyboardDuration = [XKeyBoard returnKeyBoardDuration:notification];
    _selectedData[@"edit"] = @"0";
    XRichTextCell *cell = (XRichTextCell *)_selectedCell;
    cell.textView.userInteractionEnabled = false;
    [cell.textView resignFirstResponder];
    
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
