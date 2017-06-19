//
//  JSQMessage+IM.m
//  SiRuiV4.0
//
//  Created by zhangjunbo on 15/6/26.
//  Copyright (c) 2015年 SiRui. All rights reserved.
//

#import "JSQMessage+IM.h"
#import "SRIMMessage.h"
#import "JSQPhotoMediaItem.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImage/SDImageCache.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

@implementation JSQMessage (IM)

+ (JSQMessage *)messageWithIMMessage:(SRIMMessage *)message
{
    JSQMessage *jsqMessage;
    if (message.isImg) {
        JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:message.image];
        photoItem.appliesMediaViewMaskAsOutgoing = message.type==SRIMType_Customer;
        jsqMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                        senderDisplayName:@""
                                                     date:message.date
                                                    media:photoItem];
    } else {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                        senderDisplayName:@""
                                                     date:message.date
                                                     text:message.content];
    }
    
    return jsqMessage;
}

+ (JSQMessage *)messageWithIMMessage:(SRIMMessage *)message
                               index:(NSInteger)index
                        refreshBlock:(JSQMessageRefreshBlock)block
{
    JSQMessage *jsqMessage;
    if (message.isImg) {
        if ([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:message.content]]) {
            NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:message.content]];
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:cacheKey];
            if (!image) {
                image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:cacheKey];
            }
            JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:image];
            photoItem.appliesMediaViewMaskAsOutgoing = message.type==SRIMType_Customer;
            jsqMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                            senderDisplayName:@""
                                                         date:message.date
                                                        media:photoItem];
        } else {
            JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:message.image];
            photoItem.appliesMediaViewMaskAsOutgoing = message.type==SRIMType_Customer;
            jsqMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                            senderDisplayName:@""
                                                         date:message.date
                                                        media:photoItem];
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:message.content]
                                                            options:SDWebImageDelayPlaceholder//SDWebImageProgressiveDownload
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                               
                                                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                               if (error) {
                                                                   SRLogError(@"%@", error);
                                                               }
                                                               
                                                               JSQPhotoMediaItem *photoItem = [[JSQPhotoMediaItem alloc] initWithImage:error?[UIImage imageNamed:@"bt_order_add_small"]:image];
                                                               photoItem.appliesMediaViewMaskAsOutgoing = message.type==SRIMType_Customer;
                                                               JSQMessage *newMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                                                                                           senderDisplayName:@""
                                                                                                                        date:message.date
                                                                                                                       media:photoItem];
                                                               if (block) {
                                                                   block(newMessage, index);
                                                               }
                                                           }];
        }
    } else {
        jsqMessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%zd", message.type]
                                        senderDisplayName:@""
                                                     date:message.date
                                                     text:message.content];
    }
    
    return jsqMessage;
}

- (void)startDownload
{

}

@end
