//
//  VSAComposeController.m
//  VSAWebo
//
//  Created by alvin on 15/9/1.
//  Copyright (c) 2015年 alvin. All rights reserved.
//

#import "VSAComposeController.h"
#import "VSAEmotionTextView.h"
#import "VSAComposeToolbar.h"
#import "VSAAccountTool.h"
#import "AFNetworking.h"
#import "VSAComposePhoto.h"
#import "VSAEmotionKeyboard.h"
#import "MBProgressHUD.h"
#import "VSAEmotion.h"

@interface VSAComposeController () <UITextViewDelegate, VSAComposeToolbarDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, weak) VSAEmotionTextView *textView;
@property (nonatomic, weak) VSAComposeToolbar *toolbar;
@property (nonatomic, weak) VSAComposePhoto *photo;

@property (nonatomic, strong) VSAEmotionKeyboard *emotionKeyboard;
@property (nonatomic, assign) BOOL isSwitchingKeyboard;
@end

@implementation VSAComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setUpNav];
    
    //初始化textView
    [self setupTextView];
    
    [self setupToolbar];
    
    //设置图片附件
    [self setupPhoto];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //成为第一响应者，弹出键盘
//    [self.textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
- (void)setUpNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //设置title
}

- (void)setupTextView {
    VSAEmotionTextView *textView = [[VSAEmotionTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;
    
    //通知，输入文字时，右上角“发送”变成可点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    //通知，键盘代理事件
//    UIKeyboardWillChangeFrameNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    VSAEmotionKeyboard *emotionKeyboard = [[VSAEmotionKeyboard alloc] init];
    emotionKeyboard.height = 216;
    emotionKeyboard.width = self.view.bounds.size.width;
    self.emotionKeyboard = emotionKeyboard;
//    self.textView.inputView = emotionKeyboard;
    
    //通知表情按钮被选
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:VSAEmotionButtonDidSelectNotification object:nil];
    
    //通知，删除按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delBtnDidClick:) name:VSADeleteButtonDidSelectNotification object:nil];
}

- (void)setupToolbar {
    VSAComposeToolbar *toolbar = [[VSAComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.delegate = self;
    self.toolbar = toolbar;
    toolbar.y = self.view.bounds.size.height - toolbar.height;
    [self.view addSubview:toolbar];
}

- (void)setupPhoto {
    VSAComposePhoto *photo = [[VSAComposePhoto alloc] init];
    self.photo = photo;
    [self.view addSubview:photo];
}

#pragma mark - 监听事件方法

- (void)emotionDidSelect:(NSNotification *)notification {
    VSAEmotion *emotion = notification.userInfo[VSASelectedEmotionButtonKey];
    //Controller只负责接收通知，把插入表情的操作交给textView
    [self.textView insertEmotion:emotion];
}

- (void)delBtnDidClick:(NSNotification *)notification {
    [self.textView deleteBackward];
}

- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendClick {
    if (self.photo.image) {
        [self sendWithImage];
    } else {
        [self sendWithoutImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendWithoutImage {
    VSAAccount *account = [VSAAccountTool account];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.text;
    //发布一条微博
    NSString *updateURL = @"https://api.weibo.com/2/statuses/update.json";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mgr POST:updateURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送微博成功");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送微博失败--%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)sendWithImage {
    VSAAccount *account = [VSAAccountTool account];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"status"] = self.textView.text;
    //上传图片并发布一条微博
    NSString *uploadURL = @"https://api.weibo.com/2/statuses/upload.json";
    
    [mgr POST:uploadURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        UIImage *image = self.photo.image;
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"发送微博成功");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发送微博失败--%@", error);
    }];
}

- (void)textDidChange {
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    if (self.isSwitchingKeyboard) {
        return;
    }
//    NSLog(@"%@",notification.userInfo);
    /**
     *{
         UIKeyboardAnimationCurveUserInfoKey = 7;
         UIKeyboardAnimationDurationUserInfoKey = "0.25";
         UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
         UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
         UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
         UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
         UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
     }
     */
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
    }];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    /*
     *{
     UIKeyboardAnimationCurveUserInfoKey = 7;
     UIKeyboardAnimationDurationUserInfoKey = "0.25";
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
     }
     */
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
    }];
    NSLog(@"%@", notification.userInfo);
}

- (void)switchKeyboard {
    self.isSwitchingKeyboard = YES;
    
    if (self.textView.inputView == nil) { //如果是系统默认的键盘
        self.textView.inputView = self.emotionKeyboard;
        
        //显示键盘图标
        self.toolbar.showKeyboard = YES;
    } else {
        self.textView.inputView = nil;
        
        //显示表情图标
        self.toolbar.showKeyboard = NO;
    }
    
    //收起键盘
    [self.view endEditing:YES];
    //弹出键盘
    [self.textView becomeFirstResponder];
    self.isSwitchingKeyboard = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.textView becomeFirstResponder];
//    });
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - VSAComposeToolbarDelegate代理方法
- (void)composeToolbar:(VSAComposeToolbar *)composeToolbar didClickButton:(VSAComposeToolbarButtonType)buttonType {
    switch (buttonType) {
        case VSAComposeToolbarButtonTypePicture:
            [self openAlbum];
            break;
        case VSAComposeToolbarButtonTypeCamera: {
            NSLog(@"camera click");
            [self openCamera];
            break;
        case VSAComposeToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    /**
     *{
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x7feb55314640> size {1500, 1001} orientation 0 scale 1.000000";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=6E5438ED-9A8C-4ED0-9DEA-AB2D8F8A9360&ext=JPG";
     }
     */
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.photo.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)openAlbum {
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)openCamera {
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type {
    if (![UIImagePickerController isSourceTypeAvailable:type]) {
        return;
    }
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
