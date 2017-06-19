//
//  SRCustomerServiceViewController.m
//
//
//  Created by zhangjunbo on 15/6/15.
//
//

#import "SRCustomerServiceViewController.h"
#import "SRUserDefaults.h"
#import "SRKeychain.h"
#import "SRIMMessage.h"
#import "SRPortal+IM.h"
#import "SRPortal+Message.h"
#import "SRPortalRequest.h"
#import "SRUIUtil.h"
#import "SRCustomer.h"

#import "JSQMessages.h"
#import "JSQMessage+IM.h"

#import <MJRefresh/MJRefresh.h>
#import <KVOController/FBKVOController.h>
#import <MJExtension/MJExtension.h>

@interface SRCustomerServiceViewController ()<UITextViewDelegate>
{
    FBKVOController *kvoController;
}

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) NSMutableArray *jsqMessages;

@end

@implementation SRCustomerServiceViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SRLocal(@"title_customer_service");
    
    
    kvoController = [[FBKVOController alloc] initWithObserver:self];
    
    /*设置bubble颜色*/
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor defaultColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor defaultBackgroundColor]];
    
    
    /*设置用户ID 和 用户名*/
    self.senderId = [NSString stringWithFormat:@"%zd", SRIMType_Customer];
    self.senderDisplayName = @"";
    
    /*设置头像大小*/
    UIImage *image = [UIImage imageNamed:@"ic_sirui"];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = image.size;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = image.size;
    /*不显示更早消息头，用下拉刷新*/
    self.showLoadEarlierMessagesHeader = NO;
    
    /*字体*/
    self.collectionView.collectionViewLayout.messageBubbleFont = [UIFont systemFontOfSize:14.0f];
    
    /*自定义工具栏*/
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"bt_camera"] forState:UIControlStateNormal];
    [button bk_whenTapped:^{
        [self showActionSheet];
    }];
    self.inputToolbar.contentView.leftBarButtonItem = button;
    
    UIButton *send = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    send.layer.cornerRadius = 5.0f;
    send.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setBackgroundColor:[UIColor defaultColor]];
    [send bk_whenTapped:^{
        [self sendIMMessage:self.inputToolbar.contentView.textView.text];
    }];
    self.inputToolbar.contentView.rightBarButtonItem = send;
    
    RAC(send, enabled) = [RACSignal combineLatest:@[self.inputToolbar.contentView.textView.rac_textSignal]
                                           reduce:^(NSString *text){
                                               return @(text.length>0);
                                           }];
    
    /*设置工具栏最大高度*/
    self.inputToolbar.maximumHeight = 100.0f;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getIMMessagesWithDirection:self.jsqMessages.count>1?SRIMDirection_Old:SRIMDirection_New];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getIMMessagesWithDirection:SRIMDirection_New];
    }];
    //    self.collectionView.mj_footer.hidden = YES;
    //    self.collectionView.mj_header.automaticallyHidden = YES;
    self.collectionView.mj_header.state = MJRefreshStateRefreshing;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [kvoController observe:[SRPortal sharedInterface].customer keyPath:@"hasNewMessageInIm" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (![change[NSKeyValueChangeNewKey] boolValue]) {
            return ;
        }
        [self executeOnMain:^{
            self.collectionView.mj_footer.state = MJRefreshStateRefreshing;
        } afterDelay:0];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*不用 springy 效果*/
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent =  YES;
    [kvoController unobserveAll];
}

#pragma mark - JSQMessagesViewController method overrides

//发送
- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [self sendIMMessage:text];
}


#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.jsqMessages objectAtIndex:indexPath.item];
}

//消息背景
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.jsqMessages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

//头像
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.jsqMessages objectAtIndex:indexPath.item];
    return self.avatars[@(message.senderId.integerValue)];
}

//时间
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.jsqMessages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

//姓名
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //    return nil;
    return [[NSAttributedString alloc] initWithString:@" "];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.jsqMessages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    

    
    JSQMessage *msg = [self.jsqMessages objectAtIndex:indexPath.item];

    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            
            cell.textView.textColor = [UIColor whiteColor];
            
        }
        else {
            
            cell.textView.textColor = [UIColor blackColor];
            
        }
        

        
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate



#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    //    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.jsqMessages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.jsqMessages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 0.0f;
    return kJSQMessagesCollectionViewCellLabelHeightDefault/2;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    //    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"Tapped message bubble!");
    JSQMessage *message = self.jsqMessages[indexPath.row];
    if (message.isMediaMessage) {
        [self modalImagePreviewViewController:[(JSQPhotoMediaItem *)message.media image]];
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    //    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return (scrollView.tag == 10086)?[scrollView viewWithTag:10000]:nil;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.tag == 10086) {
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        [scrollView viewWithTag:10000].center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
    }
}

#pragma mark - 私有方法

- (void)showActionSheet
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info){
        UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
        }
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self sendIMMessage:image];
        }];
    };
    
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sheet bk_addButtonWithTitle:@"拍照" handler:^{
            picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }];
    }
    [sheet bk_addButtonWithTitle:@"从手机相册选择" handler:^{
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:NULL];
    [sheet showInView:self.view];
}

- (void)modalImagePreviewViewController:(UIImage *)image
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.frame = bounds;
    vc.view.backgroundColor = [UIColor blackColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tag = 10000;
    CGFloat delta = 1.0;
    if (image.size.width > bounds.size.width
        || image.size.height > bounds.size.height) {
        delta = MAX(image.size.width/bounds.size.width, image.size.height/bounds.size.height);
        imageView.frame = CGRectMake(0, 0, image.size.width/delta, image.size.height/delta);
    }
    delta *= 1.5;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.tag = 10086;
    scrollView.directionalLockEnabled = YES;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = delta;
    scrollView.contentSize = imageView.bounds.size;
    scrollView.delegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [vc dismissViewControllerAnimated:YES completion:NULL];
    }];
    [scrollView addGestureRecognizer:tap];
    
    [scrollView addSubview:imageView];
    imageView.center = scrollView.center;
    
    [vc.view addSubview:scrollView];
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)sendIMMessage:(id)content
{
    if ([SRUserDefaults isExperienceUser]) {
        [SRUIUtil showAutoDisappearHUDWithMessage:@"该功能需要绑定车辆后才能使用" isDetail:YES];
        return ;
    }
    
    [SRUIUtil showLoadingHUDWithTitle:nil];
    
    SRPortalRequestSendIM *request = [[SRPortalRequestSendIM alloc] init];
    if ([content isKindOfClass:[UIImage class]]) {
        request.image = content;
    } else {
        request.content = content;
    }
    
    [SRPortal sendIMWithRequest:request andCompleteBlock:^(NSError *error, id responseObject) {
        [SRUIUtil dissmissLoadingHUD];
        if (error) {
            [SRUIUtil showAlertMessage:error.domain];
        } else {
            JSQMessage *message = [JSQMessage messageWithIMMessage:responseObject];
            [self.jsqMessages addObject:message];
            [self finishSendingMessageAnimated:YES];
            
            self.inputToolbar.contentView.textView.text = nil;
        }
    }];
}

- (void)getIMMessagesWithDirection:(SRIMDirection)direction {
    NSString *date;
    if (self.jsqMessages.count <= 1) {
        direction = SRIMDirection_New;
    } else if (direction == SRIMDirection_New) {
        JSQMessage *message = [self.jsqMessages lastObject];
        if (message.text && [message.text isEqualToString:SRLocal(@"description_customer_service")]) {
            message = self.jsqMessages[self.jsqMessages.count-2];
        }
        date = [message.date stringOfDateWithFormatYYYYMMddHHmmss];
    } else {
        JSQMessage *message = [self.jsqMessages firstObject];
        if (message.text && [message.text isEqualToString:SRLocal(@"description_customer_service")]) {
            message = self.jsqMessages[1];
        }
        date = [message.date stringOfDateWithFormatYYYYMMddHHmmss];
    }
    
    SRPortalRequestQueryIM *request = [[SRPortalRequestQueryIM alloc] init];
    request.direction = direction;
    request.adddate = date;
    [SRPortal queryIMWithRequest:request andCompleteBlock:^(NSError *error, NSArray *list) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (error) return ;
        
        BOOL addTolist = self.jsqMessages.count > 1 && direction == SRIMDirection_New;
        NSMutableArray *newMessages = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(SRIMMessage *obj, NSUInteger idx, BOOL *stop) {
            JSQMessage *message;
            if (obj.isImg) {
                message = [JSQMessage messageWithIMMessage:obj index:self.jsqMessages.count refreshBlock:^(JSQMessage *message, NSInteger index) {
                    if (self.jsqMessages.count <= index) return ;
                    [self.jsqMessages replaceObjectAtIndex:index withObject:message];
                    [self.collectionView reloadData];
                }];
            } else {
                message = [JSQMessage messageWithIMMessage:obj];
            }
            
            [newMessages addObject:message];
        }];
        
        if (addTolist) {
            [self.jsqMessages addObjectsFromArray:newMessages];
        } else {
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newMessages.count)];
            [self.jsqMessages insertObjects:newMessages atIndexes:indexes];
        }
        
        [self.collectionView reloadData];
        
        if (direction == SRIMDirection_New) {
            [self finishReceivingMessageAnimated:YES];
        }
    }];
}

#pragma mark - Getter

- (NSDictionary *)avatars
{
    if (!_avatars) {
        JSQMessagesAvatarImage *customerImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"ic_customer"]
                                                                                           diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        JSQMessagesAvatarImage *siruiImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"ic_sirui"]
                                                                                        diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        _avatars = @{
                     @(SRIMType_Customer) : customerImage,
                     @(SRIMType_SiRui) : siruiImage
                     };
    }
    
    return _avatars;
}

- (NSMutableArray *)jsqMessages
{
    if (!_jsqMessages) {
        JSQMessage *defaultMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", SRIMType_SiRui]
                                                        senderDisplayName:@""
                                                                     date:[NSDate date]
                                                                     text:SRLocal(@"description_customer_service")];
//        _jsqMessages = [NSMutableArray arrayWithObject:defaultMessage];
        _jsqMessages = [NSMutableArray new];
    }
    
    return _jsqMessages;
}

#pragma mark - Setter


@end
