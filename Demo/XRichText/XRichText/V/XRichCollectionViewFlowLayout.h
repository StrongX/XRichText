
#import <UIKit/UIKit.h>
#define colMargin 15
#define colCount 1
#define rolMargin 15


typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);

@interface XRichCollectionViewFlowLayout : UICollectionViewFlowLayout
//数组存放每列的总高度
@property(nonatomic,strong)NSMutableArray* colsHeight;
//单元格宽度
@property(nonatomic,assign)CGFloat colWidth;

@property(nonatomic,strong )itemHeightBlock heightBlock ;

-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;

@end
