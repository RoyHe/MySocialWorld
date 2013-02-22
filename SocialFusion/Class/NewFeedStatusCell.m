//
//  NewFeedStatusCell.m
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-9.
//  Copyright 2011年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedStatusCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonFunction.h"
#import "NewFeedBlog+NewFeedBlog_Addition.h"
#import "NewFeedUploadPhoto+Addition.h"
#import "NewFeedListController.h"
#import "Base64Transcoder.h"
#import "NSData+NSData_Base64.m"
#import "NSString+DataURI.h"
#import "NewFeedShareAlbum+Addition.h"
#import "NewFeedSharePhoto+Addition.h"
#import "NSString+HTMLSet.h"
#import "NewFeedData+NewFeedData_Addition.h"
#import "CardBrowserViewController.h"

@implementation NewFeedStatusCell
@synthesize photoView=_photoView;
@synthesize delegate=_delegate;

- (void)dealloc {
   // NSLog(@"NewFeedStatusCell release");
    
    [_time release];
    [_photoView release];
    [_defaultphotoView release];
    [_photoOut release];
    
    [_name release];
    
    [_upCutline release];
    
    
    _webView.delegate = nil;    
    [_webView release];
    [super dealloc];
}

- (void)awakeFromNib
{
    
}

+ (float)heightForCell:(NewFeedData*)feedData
{
    if ([feedData class] == [NewFeedUploadPhoto class] )
    {
        return 162;
    }
    else
    {
        return [feedData.cellheight intValue];
    }
    
    
    return 0;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)loadPicture:(NSData*)image
{
    
    UIImage* image1 = [UIImage imageWithData:image];
    CGSize size;
    //改变图片大小
    float a=image1.size.width/98;
    float b=image1.size.height/73;
    if (a>b)
    {
        size=CGSizeMake(image1.size.width/image1.size.height*73, 73);
    }
    else
    {
        size=CGSizeMake(98, image1.size.height/image1.size.width*98);
    }
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //  return newImage;
    
    
    NSData* imagedata=UIImageJPEGRepresentation(newImage, 10);
    
    
    
    NSString *imgB64 = [[imagedata base64Encoding] jpgDataURIWithContent];
    
    
    NSString *javascript = [NSString stringWithFormat:@"setPhotoPos(%f,%f)", size.width,size.height];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
    
    
    javascript = [NSString stringWithFormat:@"document.getElementById('upload').src='%@'", imgB64];
    
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
}


- (void)setData:(NSData*)image
{
    _photoData = [[NSData alloc] initWithData:image];
}

- (void)loadImage:(NSData*)image
{
    NSString *imgB64 = [[image base64Encoding] jpgDataURIWithContent];
    NSString *javascript = [NSString stringWithFormat:@"document.getElementById('head').src='%@'", imgB64];
    [_webView stringByEvaluatingJavaScriptFromString:javascript];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (_photoData!=nil)
    {
        [self loadImage:_photoData];
        [_photoData release];
    }
    
    NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    [_delegate statusCellWebViewDidLoad:webView indexPath:indexpath Cell:self];
    _loaded = YES;
}

- (void)showBigImage
{
    
    NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    //    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController showImage:indexpath];
    
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    
    NSString* tempString = [NSString stringWithFormat:@"%@",[request URL]];
    tempString=[tempString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* commandString = [tempString substringFromIndex:7];
    
    NSString* startString = [tempString substringToIndex:5];
    
   // NSLog(@"url:%@",[[tempString stringByDeletingLastPathComponent] lastPathComponent]);
    if ([commandString isEqualToString:@"showimage/"])//点击图片
    {
        [self showBigImage];
        return NO;
    }
    else if ([commandString isEqualToString:@"gotodetail/"])//进入detail页面
    {
        [self exposeCell];
        return NO;
    }
    
    else if ([[[tempString stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:@"renren"])
    {
        
        
        [_listController loadNewRenrenAt:[tempString lastPathComponent]];
        return NO;
    }
    else if ([[[tempString stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:@"weibo"])
    {
        
        
        [_listController loadNewWeiboAt:[tempString lastPathComponent]];   
        
        
        return NO;
    }
    else if ([startString isEqualToString:@"file:"])//本地request读取
    {
        return YES;
    }
    else//其他url，调用safari
    {
        
        //[[UIApplication sharedApplication] openURL:[request URL]];
        [CardBrowserViewController showCardBrowserWithLink:request.URL];
        return NO;
    }
}
- (void)exposeCell
{
    
    NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    //    [_listController.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    
    [_listController exposeCell:indexpath];
}

-(BOOL)loaded
{
    return _loaded;
}

- (void)setList:(NewFeedListController*)list
{
    _listController=list;
}

- (id)initWithType:(kFeedType)type
{
    
    
    static NSString *NormalCell = @"NewFeedStatusNormalCell";
    static NSString *RepostCell = @"NewFeedStatusRepostCell";
    static NSString *NormalCellWithPhoto = @"NewFeedStatusNormalCellWithPhoto";
    static NSString *RepostCellWithPhoto = @"NewFeedStatusRepostCellWithPhoto";
    static NSString *ShareAlbumCell = @"NewFeedStatusShareAlbumCell";
    static NSString *SharePhotoCell = @"NewFeedStatusSharePhotoCell";
    static NSString *UploadPhotoCell = @"NewFeedStatusUploadPhotoCell";
    static NSString *BlogCell = @"NewFeedStatusBlogCell";
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(0, 0, 320, 100);
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _loaded = NO;    
    NSString *infoSouceFile ;
    NSString *infoText;
    
    switch (type) {
        case kUploadPhoto:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"uploadphotocell" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:UploadPhotoCell];
            
            break;
        }
        case kShareAlbum:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharealbum" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShareAlbumCell];
            
            break;
        }
        case kSharePhoto:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"sharephotocell" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SharePhotoCell];
            
            break;
        }
        case kBlog:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcell" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BlogCell];
            
            break;
        }
        case kNormalWithPhoto:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"photocell" ofType:@"html"];
            
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCellWithPhoto];
            
            break;
        }
        case kNormal:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"normalcell" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NormalCell];
            
            break;
        }
            
        case kRepost:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcell" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepostCell];
            
            break;
        }
        case kRepostWithPhoto:
        {
            infoSouceFile = [[NSBundle mainBundle] pathForResource:@"repostcellwithphoto" ofType:@"html"];
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RepostCellWithPhoto];
            
            break;
        }
        default:
            break;
    }
    
    infoText = [[NSString alloc] initWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    [infoText release];
    [self.contentView addSubview:_webView];
    
    _webView.userInteractionEnabled = YES;
    
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    _webView.scrollView.scrollEnabled = NO;
    _webView.delegate=self;
    
    
    
    _time = [[UILabel alloc] init];
    _time.frame=CGRectMake(246, 11, 50, 18);
    _time.backgroundColor = [UIColor clearColor];
    _time.textAlignment=UITextAlignmentRight;
    _time.font = [UIFont fontWithName:@"Helvetica" size:9.0f];
    
    _time.textColor = [UIColor colorWithRed:0.5647f green:0.55686f blue:0.47059 alpha:1];
    
    
    
    
    
    _photoView = [[UIImageView alloc] init];
    _photoView.frame = CGRectMake(8, 12, 37, 37);
    
    _photoOut = [[UIButton alloc] init];
    _photoOut.frame = CGRectMake(4, 8, 46, 46);
    _photoOut.adjustsImageWhenHighlighted = NO;
    _photoOut.showsTouchWhenHighlighted = YES;
    [_photoOut addTarget:self action:@selector(didClickPhotoFrameButton) forControlEvents:UIControlEventTouchUpInside];
    
    _defaultphotoView = [[UIImageView alloc] init];
    _defaultphotoView.frame=CGRectMake(8, 12, 37, 37);
    [_defaultphotoView setImage:[UIImage imageNamed:@"default_head_img_tiny@2x.png"]];
    
    _name = [[UIButton alloc] init];
    _name.frame=CGRectMake(57, 9, 190, 18);
    [_name setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_name setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];   
    [_name setTitleColor:[UIColor colorWithRed:0.32157f green:0.31373 blue:0.26666667 alpha:1] forState:UIControlStateNormal];
    [_name.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
    
    _upCutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]];
    _upCutline.frame=CGRectMake(8, 3, 290, 1);
    
    [self.contentView addSubview:_upCutline];
    
    [self.contentView addSubview:_defaultphotoView];
    
    [self.contentView addSubview:_photoView];
    
    [self.contentView addSubview:_photoOut];
    
    [self.contentView addSubview:_name];
    
    [self.contentView addSubview:_time];
    
    return  self;
}



- (void)configureCell:(NewFeedRootData*)feedData  first:(BOOL)bol
{    
    _photoData=nil;
    
    [_time setText:[CommonFunction getTimeBefore:[feedData getDate]]];
    [_name setTitle:[feedData getAuthorName] forState:UIControlStateNormal];
    
    if (bol==YES)
    {
        [_photoView setImage:nil];
    }
    if ([feedData getStyle] == 0)
    {
        [_photoOut setImage:[UIImage imageNamed:@"head_renren.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_photoOut setImage:[UIImage imageNamed:@"head_wb.png"] forState:UIControlStateNormal];
    }
    
    if ([feedData class] == [NewFeedBlog class])
    {
        NSString* outString = [(NewFeedBlog*)feedData getName];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
        
        
        outString = [(NewFeedBlog*)feedData getBlog];
        
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('%@')",outString]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')",[feedData.comment_Count intValue]]];
    }
    else if ([feedData class] == [NewFeedShareAlbum class])
    {
        NSString* outString = [(NewFeedShareAlbum*)feedData getShareComment];
        
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
        
        outString = [(NewFeedShareAlbum*)feedData getAubumName];
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumName('%@')",outString]];
        
        outString = [(NewFeedShareAlbum*)feedData getAblbumQuantity];
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setPhotoNumber('%@')",  outString]];
        
        
        outString = [(NewFeedShareAlbum*)feedData getFromName];
        
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumAuthor('%@')",  outString]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')",[feedData.comment_Count intValue]]];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"resetPhoto()"]];
        
    }
    else if ([feedData class] == [NewFeedSharePhoto class])
    {
        
        NSString* outString = [(NewFeedSharePhoto*)feedData getShareComment];
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
        
        outString = [(NewFeedSharePhoto*)feedData getPhotoComment];
        outString = [outString replaceJSSign];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setComment('%@')",outString]];
        
        outString = [(NewFeedSharePhoto*)feedData getTitle];
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumName('%@')",outString]];
        
        outString = [(NewFeedSharePhoto*)feedData getFromName];
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setAlbumAuthor('%@')",  outString]];
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')", [feedData.comment_Count intValue]]];
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"resetPhoto()"]];
        
    }
    else if ([feedData class] == [NewFeedUploadPhoto class])
    {
        NSString* outString = [(NewFeedUploadPhoto*)feedData getName];
        
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
        
        outString = [(NewFeedUploadPhoto*)feedData getPhoto_Comment];
      //  NSLog(@"%@",outString);
        
        outString = [outString replaceJSSign];
      //  NSLog(@"%@",outString);
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setDetailComment('%@')",outString]];
        
        outString = [(NewFeedUploadPhoto*)feedData getTitle];
        
        outString = [outString replaceHTMLSign:[feedData.style intValue]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setTitle('%@')", outString]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')",[feedData.comment_Count intValue]]];
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"resetPhoto()"]];
        
    }
    else if ([feedData class] == [NewFeedData class])
    {
        if (((NewFeedData*)feedData).repost_ID==nil)
        {
            
            NSString* outString = [(NewFeedData*)feedData getName];
            
            
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
            
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')",[feedData.comment_Count intValue]]];
            
            
            
            if (((NewFeedData*)feedData).pic_URL!=nil)
            {
                
                
                [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"resetPhoto()"]];
            }
            
        }
        else
        {
            NSString* outString = [(NewFeedData*)feedData getName];
            
            
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
            
            outString = [(NewFeedData*)feedData getPostMessage];
            
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRealRepost('%@')",outString]];
            
            [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setCommentCount('评论:%d')",[feedData.comment_Count intValue]]];
            
            if (((NewFeedData*)feedData).pic_URL!=nil)
            {
                [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"resetPhoto()"]];
            }
            
        }
    }
    
    int scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _webView.scrollView.contentSize.width, scrollHeight);
    _webView.frame = CGRectMake(0, 0,_webView.scrollView.contentSize.width, scrollHeight);
    
}

#pragma mark -
#pragma mark UI actions

- (void)didClickPhotoFrameButton {
    NSIndexPath* indexpath = [_listController.tableView indexPathForCell:self];
    [_listController selectUser:indexpath];
}

@end
