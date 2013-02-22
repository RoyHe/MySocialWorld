//
//  RepostViewController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-22.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostViewController.h"
#import "WebStringToImageConverter.h"
#import "NewFeedRootData.h"
#import "StatusCommentData.h"
typedef  enum kShareStyle {
    kNewBlog           =1,
    kPhoto          =2,
    kAlbum          =6,
    kShare          =20,
    kRenrenStatus   =30,
    kWeiboStatus    =40,

    
} kShareStyle;
@interface RepostViewController : PostViewController<WebStringToImageConverterDelegate>
{
    BOOL _repostToRenren;
    BOOL _repostToWeibo;

    BOOL _commentPage;
    BOOL _comment;
    kShareStyle _style;
    NewFeedRootData* _feedData;
    StatusCommentData* _commetData;
    
    NSString* _blogData;
    
    IBOutlet UIButton* _repostToRenrenBut;
    IBOutlet UIButton* _repostToWeiboBut;
    
    IBOutlet UIButton* _repostToRenrenLabelBut;
    IBOutlet UIButton* _repostToWeiboLabelBut;
    
    IBOutlet UIButton* _commentBut;
    IBOutlet UIButton* _commentLabelBut;
    
    NSString* _photoID;
    NSString* _photoURL;
    NSString* _photoComment;
    
}


@property (nonatomic, retain) NewFeedRootData* feedData;
@property (nonatomic, retain) StatusCommentData* commetData;
@property (nonatomic, retain) NSString* blogData;

@property (nonatomic, retain) NSString* photoID;
@property (nonatomic, retain) NSString* photoURL;
@property (nonatomic, retain) NSString* photoComment;


-(void)setcommentPage:(BOOL)bol;
-(void)setStyle:(kShareStyle)style;
- (IBAction)didClickPostToRenrenButton;
- (IBAction)didClickPostToWeiboButton;
- (IBAction)didClickComment;

@end
