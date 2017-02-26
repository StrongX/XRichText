//
//  inputViewController.m
//  XRichText
//
//  Created by xlx on 17/2/21.
//  Copyright © 2017年 xlx. All rights reserved.
//



#import "inputViewController.h"
#import "XRichTextInputView.h"
@interface inputViewController ()<XRichTextInputViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation inputViewController
{
    XRichTextInputView *_richTextView;
    NSIndexPath *_selectedIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}
- (void)initUI{
    self.view.backgroundColor = [UIColor  whiteColor];
    _richTextView = [[XRichTextInputView alloc] initWithFrame:(CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64))];
    [self.view addSubview:_richTextView];
    _richTextView.delegate = self;
}

-(void)XRichchoiceImage{  //选择图片
    _selectedIndex = nil;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"你可以从相册选择或者相机" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action3];

    [self presentViewController:alert animated:true completion:^{
        
    }];

}
-(void)replaceImage:(NSIndexPath *)indexPath{
    _selectedIndex = indexPath;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"你可以从相册选择或者相机" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectImageFromPhoto:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:action2];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action3];
    [self presentViewController:alert animated:true completion:^{
        
    }];
}
-(void)XRichchoiceText{    //选择文本
    [_richTextView addText:@""];
}
/*
 * 从相机或者相机选择图片
 */
-(void)selectImageFromPhoto:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = type;
    picker.delegate = self;
    [self presentViewController:picker animated:true completion:^{
        
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    if(!_selectedIndex){
        [_richTextView addImage:image];
        [_richTextView addImage:image];
        [_richTextView addImage:image];    
    }else{
        [_richTextView replaceImage:image indexPaht:_selectedIndex];
    }

    [picker dismissViewControllerAnimated:true completion:^{
        
    }];
    
}
@end
