
//
//  RepostViewController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-22.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "RepostViewController.h"
#import "RenrenClient.h"
#import "WeiboClient.h"
#import "NewFeedData.h"
#import "User.h"
#import "WeiboClient.h"
#import "UIButton+Addition.h"
#import "Image+Addition.h"
#import "NewFeedBlog.h"
#import "NewFeedShareAlbum.h"
#import "NewFeedSharePhoto.h"
#import "NewFeedUploadPhoto.h"
#import "NSString+WeiboSubString.h"
#import <QuartzCore/QuartzCore.h>
#import "UIApplication+Addition.h"

@implementation RepostViewController

@synthesize feedData=_feedData;
@synthesize blogData=_blogData;
@synthesize commetData=_commetData;
@synthesize photoID=_photoID;
@synthesize photoComment=_photoComment;
@synthesize photoURL=_photoURL;

-(void)dealloc
{
    [_feedData release];
    [_commetData release];
    [_blogData release];
    [_photoID release];
    [_photoURL release];
    [_photoComment release];
    
      [_repostToRenrenBut release];
      [_repostToWeiboBut release];
          [_repostToRenrenLabelBut release];
      [_repostToWeiboLabelBut release];
    
      [_commentBut release];
      [_commentLabelBut release];
    [super dealloc];
    
}

-(void)setcommentPage:(BOOL)bol
{
    _commentPage=bol;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _repostToRenren=NO;
    _repostToWeibo=NO;
    _comment=NO;
    if (_commentPage==NO)
    {
        if (_style==kRenrenStatus)
        {
            [self didClickPostToRenrenButton];
      //      if (((NewFeedData*)_feedData).repost_ID!=nil)
      //      {
       //         self.textView.text=[NSString stringWithFormat:@"//%@:%@", ((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message];
       //     }
            self.textView.selectedRange=NSMakeRange(0, 0);
            [self updateTextCount];
        }
        
        if (_style==kWeiboStatus)
        {
            [self didClickPostToWeiboButton];
            if (((NewFeedData*)_feedData).repost_ID!=nil)
            {
                self.textView.text=[NSString stringWithFormat:@"//@%@:%@", ((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message];
            }
            self.textView.selectedRange=NSMakeRange(0, 0);
            [self updateTextCount];
        }
        if (_style==kNewBlog)
        {
            if (((NewFeedBlog*)_feedData).shareID!=nil)
            {
                _commentBut.hidden=YES;
                _commentLabelBut.hidden=YES;
            }
            [self didClickPostToRenrenButton];
        }
    }
    else
    {
        if (_commetData!=nil)
        {
            self.titleLabel.text=[NSString stringWithFormat:@"回复%@",_commetData.owner_Name];
        }
        else
        {
            self.titleLabel.text=[NSString stringWithFormat:@"评论"];
        }
        _commentBut.hidden=YES;
        _commentLabelBut.hidden=YES;
        [_repostToRenrenLabelBut setTitle:[NSString stringWithFormat:@"同时转发人人网"] forState:UIControlStateNormal];
        [_repostToWeiboLabelBut setTitle:[NSString stringWithFormat:@"同时转发新浪微博"] forState:UIControlStateNormal];
        _comment=YES;
        
    }
}

-(void)forwardWeibo:(NSString*)statusID
{
    WeiboClient* client2=[WeiboClient client];
    [client2 setCompletionBlock:^(WeiboClient *client) {
        [self postStatusCompletion];
    }];
    
     
    [client2 repost:statusID text:[    [NSString stringWithFormat:@"%@//%@:%@", self.textView.text,((NewFeedData*)_feedData).author.name  , ((NewFeedData*)_feedData).message] getStatusSubstringWithCount:WEIBO_MAX_WORD] commentStatus:YES commentOrigin:NO];
}
#pragma mark -
#pragma mark IBAction

- (IBAction)didClickPostButton:(id)sender {
    _postCount = 0;
    _postStatusErrorCode = PostStatusErrorNone;
    
    if(!_repostToWeibo && !_repostToRenren && !_comment) {
        [[UIApplication sharedApplication] presentToast:@"请选择发送平台。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    if([self.textView.text isEqualToString:@""] && _comment) {
        [[UIApplication sharedApplication] presentToast:@"请输入评论内容。" withVerticalPos:TOAST_POS_Y];
        return;
    }
    
    if (_style==kRenrenStatus)
    {
        if (_repostToRenren==YES)
        {
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            
   
            
      //      if (((NewFeedData*)_feedData).repost_ID!=nil)
      //      {
             //   [client forwardStatus:((NewFeedData*)_feedData).repost_ID statusID:((NewFeedData*)_feedData).repost_StatusID andStatusString:self.textView.text];
        //    }
         //   else
          //  {
                [client forwardStatus:((NewFeedData*)_feedData).author.userID statusID:((NewFeedData*)_feedData).source_ID andStatusString:self.textView.text];
                
           // }
        }
        if (_repostToWeibo==YES)
        {
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                else
                {
                    NSDictionary* dict=client.responseJSONObject;
                    NSString* statusID=[[dict objectForKey:@"id"] stringValue];
                    [self performSelector:@selector(forwardWeibo:) withObject:statusID afterDelay:1];
                    
                }
            }];
            _postCount++;
            
            NSString* outString;
            NSString* authorName;
            if (((NewFeedData*)_feedData).repost_ID!=nil)
            {
                
                outString=[NSString stringWithFormat:@"%@:%@",((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status];
                authorName=((NewFeedData*)_feedData).repost_Name;
            }
            else
            {
                
                outString=[NSString stringWithFormat:@"%@:%@",((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message];
                authorName=((NewFeedData*)_feedData).author.name;
            }
            if ([self sinaCountWord:outString]>WEIBO_MAX_WORD)
            {
                UITextView* textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 1000)];
                //textView.scrollEnabled=YES;
                [textView setText:outString];
                //textView.bounds=CGRectMake(0, 0, textView.contentSize.width, textView.contentSize.height);
                
                
                UIFont *font = [UIFont systemFontOfSize:14];
                CGSize size = [textView.text sizeWithFont:font constrainedToSize:CGSizeMake(320, 500) lineBreakMode:UILineBreakModeWordWrap];
                size.height=size.height+20;
                
                // textView.contentSize.height
                UIGraphicsBeginImageContext(size); 
                
                [textView.layer renderInContext:UIGraphicsGetCurrentContext()]; 
                
                
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [textView release];
                
                [client postStatus:[NSString stringWithFormat:@"%@的状态",authorName] withImage:viewImage];
            }
            else
            {
                [client postStatus:outString];
            }
            
        }
        if (_comment==YES)
        {
            RenrenClient *client1 = [RenrenClient client];
            [client1 setCompletionBlock:^(RenrenClient *client1) {
                if(client1.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            if (_commetData!=nil)
            {
                [client1 comment:((NewFeedData*)_feedData).source_ID userID:((NewFeedData*)_feedData).author.userID  text:self.textView.text toID:_commetData.actor_ID];
            }
            else
            {
                [client1 comment:((NewFeedData*)_feedData).source_ID userID:((NewFeedData*)_feedData).author.userID  text:self.textView.text toID:nil];
            }
        }
        
    }
    else if (_style==kWeiboStatus)
    {
        if (_repostToRenren==YES)
        {
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                
                
                [self postStatusCompletion];
            }];
            _postCount++;
            
            if (((NewFeedData*)_feedData).pic_URL==nil)
            {
                if (((NewFeedData*)_feedData).repost_ID!=nil)
                {
                    
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@",self.textView.text,((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status]];
                }
                else
                {
                    [client postStatus:[NSString stringWithFormat:@"%@ 转自%@：%@",self.textView.text,((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message]];
                }
            }
            else
            {
                NSData *imageData = nil;
                Image *image = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL inManagedObjectContext:self.managedObjectContext];
                if (image==nil)
                {
                    imageData = [Image imageWithURL:((NewFeedData*)_feedData).pic_big_URL  inManagedObjectContext:self.managedObjectContext].imageData.data;
                    
                }
                else
                {
                    imageData=image.imageData.data;
                }
                if (((NewFeedData*)_feedData).repost_ID!=nil)
                {
                    
                    NSString* postString=[NSString stringWithFormat:@"%@ 转自%@：%@",self.textView.text,((NewFeedData*)_feedData).repost_Name,((NewFeedData*)_feedData).repost_Status];
                    
                    
                    
                    [client postStatus:[postString getStatusSubstringWithCount:190] withImage:[UIImage imageWithData:imageData]];
                    
                }
                else
                {
                    
                    NSString* postString=[NSString stringWithFormat:@"%@ 转自%@：%@",self.textView.text,((NewFeedData*)_feedData).author.name,((NewFeedData*)_feedData).message];

                    [client postStatus:[postString getStatusSubstringWithCount:190] withImage:[UIImage imageWithData:imageData]];
                }
                
            }
        }
        
        if (_repostToWeibo==YES)
        {
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                [self postStatusCompletion];
            }];
            _postCount++;
            
            [client repost:((NewFeedData*)_feedData).source_ID text:self.textView.text commentStatus:_comment commentOrigin:NO];
            
        }
        
        if (_commentPage==YES)
        {
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                [self postStatusCompletion];
            }];
            _postCount++;
            if (_commetData!=nil)
            {
                [client comment:((NewFeedData*)_feedData).source_ID cid:_commetData.comment_ID text:self.textView.text commentOrigin:NO];
            }
            else
            {
                [client comment:((NewFeedData*)_feedData).source_ID cid:nil text:self.textView.text commentOrigin:NO];
                
            }
            
            
        }
    }
    
    else if (_style==kNewBlog)
    {
        if (_repostToRenren==YES)
        {
            
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            if (((NewFeedBlog*)_feedData).shareID==nil)
            {
                [client share:kNewBlog share_ID:((NewFeedBlog*)_feedData).source_ID user_ID:((NewFeedBlog*)_feedData).author.userID comment:self.textView.text];
            }
            else
            {
                [client share:kShare share_ID:((NewFeedBlog*)_feedData).shareID user_ID:((NewFeedBlog*)_feedData).sharePersonID comment:self.textView.text];
            }
        }
        if (_comment==YES)
        {
            RenrenClient *client2 = [RenrenClient client];
            [client2 setCompletionBlock:^(RenrenClient *client2) {
                if(client2.hasError)
                    _postStatusErrorCode |= PostStatusErrorWeibo;
                [self postStatusCompletion];
            }];
            _postCount++;
            if (_commetData!=nil)
            {
                
                
                [client2 commentShare:((NewFeedBlog*)_feedData).shareID  uid:((NewFeedBlog*)_feedData).sharePersonID content:self.textView.text toID:_commetData.actor_ID ];     
            }
            else
            {
                [client2 commentShare:((NewFeedBlog*)_feedData).shareID  uid:((NewFeedBlog*)_feedData).sharePersonID content:self.textView.text toID:nil ];
            }
        }
        
        
        if (_repostToWeibo==YES)
        {
            WebStringToImageConverter* webStringConverter=[WebStringToImageConverter webStringToImage];
            webStringConverter.delegate=self;
            [webStringConverter startConvertBlogWithTitle:((NewFeedBlog*)_feedData).title detail:_blogData];
        }
    }
    
    
    else if (_style==kPhoto)
    {
        if (_repostToRenren==YES)
        {
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            
            NSString* userID;
            if ([_feedData class]==[NewFeedSharePhoto class])
            {
                userID=((NewFeedSharePhoto*)_feedData).fromID;
            }
            else if ([_feedData class]==[NewFeedUploadPhoto class])
            {
                userID=((NewFeedSharePhoto*)_feedData).author.userID;
            }
            else
            {
                userID=((NewFeedShareAlbum*)_feedData).fromID;
            }
            
            if (_photoID!=nil)
            {
                [client share:kPhoto share_ID:_photoID user_ID:userID comment:self.textView.text];
            }
            else
            {
                [client share:kShare share_ID:(_feedData).source_ID user_ID:_feedData.author.userID comment:self.textView.text];
            }
        }
        if (_repostToWeibo==YES)
        {
            
            NSData *imageData = nil;
            Image *image = [Image imageWithURL:_photoURL inManagedObjectContext:self.managedObjectContext];
            if (image==nil)
            {
                imageData = [Image imageWithURL:_photoURL  inManagedObjectContext:self.managedObjectContext].imageData.data;
                
            }
            else
            {
                imageData=image.imageData.data;
            }
            WeiboClient *client = [WeiboClient client];
            [client setCompletionBlock:^(WeiboClient *client) {
                if(client.hasError)
                {
                    _postStatusErrorCode |= PostStatusErrorRenren;
                }
                [self postStatusCompletion];
            }];
            _postCount++;  
            
            NSString* outString=[NSString stringWithFormat:@"%@ //%@",self.textView.text,_photoComment];

            
            [client postStatus:[outString getStatusSubstringWithCount:WEIBO_MAX_WORD-10] withImage:[UIImage imageWithData:imageData]];
            
        }
   
        
        if (_commentPage==YES)
        {
            
            RenrenClient *client = [RenrenClient client];
            [client setCompletionBlock:^(RenrenClient *client) {
                if(client.hasError)
                    _postStatusErrorCode |= PostStatusErrorRenren;
                [self postStatusCompletion];
            }];
            _postCount++;
            
            NSString* userID;
            if ([_feedData class]==[NewFeedSharePhoto class])
            {
                userID=((NewFeedSharePhoto*)_feedData).fromID;
            }
            else if ([_feedData class]==[NewFeedUploadPhoto class])
            {
                userID=((NewFeedSharePhoto*)_feedData).author.userID;
            }
            else
            {
                userID=((NewFeedShareAlbum*)_feedData).fromID;
            }
            
            if (_photoID!=nil)
            {
                [client commentPhoto:_photoID uid:userID content:self.textView.text toID:_commetData.actor_ID];
            }
            else if ([_feedData class]==[NewFeedUploadPhoto class])
            {
                [client commentPhoto:((NewFeedUploadPhoto*)_feedData).photo_ID uid:_feedData.author.userID content:self.textView.text toID:_commetData.actor_ID];                
            }
            else
            {
                [client commentShare:(_feedData).source_ID uid:_feedData.author.userID content:self.textView.text toID:_commetData.actor_ID];
                
            }
        }
        else
        {
            if (_comment==YES)
            {
                RenrenClient *client = [RenrenClient client];
                [client setCompletionBlock:^(RenrenClient *client) {
                    if(client.hasError)
                        _postStatusErrorCode |= PostStatusErrorRenren;
                    [self postStatusCompletion];
                }];
                _postCount++;
                
                NSString* userID;
                if ([_feedData class]==[NewFeedSharePhoto class])
                {
                    userID=((NewFeedSharePhoto*)_feedData).fromID;
                }
                else if ([_feedData class]==[NewFeedUploadPhoto class])
                {
                    userID=((NewFeedSharePhoto*)_feedData).author.userID;
                }
                else
                {
                    userID=((NewFeedShareAlbum*)_feedData).fromID;
                }
                
                if (_photoID!=nil)
                {
                    [client commentPhoto:_photoID uid:userID content:self.textView.text toID:nil];
                }
                else if ([_feedData class]==[NewFeedUploadPhoto class])
                {
                    [client commentPhoto:((NewFeedUploadPhoto*)_feedData).photo_ID uid:_feedData.author.userID content:self.textView.text toID:nil];
                    
                }
                else
                {
                    [client commentShare:(_feedData).source_ID uid:_feedData.author.userID content:self.textView.text toID:nil];
                    
                }
            }
        }
        
    }
    [self dismissView];
}


- (IBAction)didClickPostToRenrenButton
{
    _repostToRenren = !_repostToRenren;
    [_repostToRenrenBut setPostPlatformButtonSelected:_repostToRenren];
}
- (IBAction)didClickPostToWeiboButton
{
    _repostToWeibo = !_repostToWeibo;
    [_repostToWeiboBut setPostPlatformButtonSelected:_repostToWeibo];
}

- (IBAction)didClickComment
{
    _comment = !_comment;
    [_commentBut setPostPlatformButtonSelected:_comment];
}

-(void)setStyle:(kShareStyle)style
{
    _style=style;
}

- (void)webStringToImageConverter:(WebStringToImageConverter *)converter  didFinishLoadWebViewWithImage:(UIImage*)image
{
    WeiboClient *client = [WeiboClient client];
    [client setCompletionBlock:^(WeiboClient *client) {
        if(client.hasError)
        {
            _postStatusErrorCode |= PostStatusErrorWeibo;
        }
        [self postStatusCompletion];
    }];
    _postCount++;
    [client postStatus:[self.textView.text getStatusSubstringWithCount:WEIBO_MAX_WORD] withImage:image];
}

@end

