//
//  NotificationService.m
//  com.lxbox.Emeat.NotificationService
//
//  Created by liuheshun on 2018/7/6.
//  Copyright © 2018年 liuheshun. All rights reserved.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>



@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    //NSLog(@"----将APNs信息交由个推处理----");

 
    [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray* errors) {
        
        //注意：是否修改下发后的title内容以项目实际需求而定
        //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];
        
        self.bestAttemptContent.attachments = attachments; //设置通知中的多媒体附件
        
       // NSLog(@"个推处理APNs消息遇到错误：%@",errors); //如果APNs处理有错误，可以在这里查看相关错误详情
        
        self.contentHandler(self.bestAttemptContent); //展示推送的回调处理需要放到个推回执完成的回调中
        
        // 附件
        NSDictionary *dict =  self.bestAttemptContent.userInfo;
        NSDictionary *notiDict = dict[@"aps"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
        
        if (!imgUrl.length) {
            self.contentHandler(self.bestAttemptContent);
        }
        
        [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
            
            if (attach) {
                self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
            }
            self.contentHandler(self.bestAttemptContent);
            
        }];
        
        
    }];
    
}
- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        //NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                           // NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    completionHandler(attachment);
                }] resume];
    
}

- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    return [@"." stringByAppendingString:ext];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    //销毁SDK，释放资源
    [GeTuiExtSdk destory];
    //结束 NotificationService 调用
    self.contentHandler(self.bestAttemptContent);
    
    
    
}

@end
