

#import "XRichCollectionViewFlowLayout.h"

@interface XRichCollectionViewFlowLayout ()

@end

@implementation XRichCollectionViewFlowLayout
{
    CGFloat _contentHeight;
}
-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block{
    if ([super init]) {
        self.heightBlock = block;
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    NSLog(@"----------------------");
    self.colWidth =( self.collectionView.frame.size.width - (colCount+1)*colMargin )/colCount;
    _contentHeight = 0;
}
-(CGSize)collectionViewContentSize{
    NSLog(@"_contentHeight:%f",_contentHeight);
    return CGSizeMake(self.collectionView.frame.size.width, _contentHeight);
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    
    CGFloat height = self.heightBlock(indexPath);
    attr.frame= CGRectMake(colMargin, _contentHeight, self.colWidth, height);

    _contentHeight+=(height+colMargin);
    NSLog(@"%@",attr);

    return attr;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<items;i++) {
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attr];
    }
    return array;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
