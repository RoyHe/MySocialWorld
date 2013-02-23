//
//  AlbumDetailController.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "AlbumDetailController.h"
#import "NewFeedShareAlbum+Addition.h"
#import "RenrenClient.h"
#import "Image+Addition.h"
#import "UIImageView+Addition.h"
#import "DetailImageViewController.h"
#import "UIApplication+Addition.h"
#import "NewFeedSharePhoto+Addition.h"
#import "NewFeedUploadPhoto+Addition.h"
#import "User.h"
#import "RepostViewController.h"
#define IMAGE_OUT_BEGIN_X 10
#define IMAGE_OUT_BEGIN_Y 5
#define IMAGE_OUT_V_SPACE 20
#define IMAGE_OUT_WIDTH 83
#define IMAGE_OUT_H_SPACE 17
#define IMAGE_OUT_HEIGHT 66
#define VIEW_SIZE (270)


@implementation AlbumDetailController


- (void)dealloc
{
    for (int i=0;i<27;i++)
    {
        [_photoInAlbum[i] release];
    }
    
    
    for (int i=0;i<9;i++)
    {
        [_photoID[i] release];
        [_bigURL[i]  release];
    }
    [_albumTitle release];
    [_contentScrollView release];
    [_contentView release];
    
    
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.view.frame;
    rect.origin.y = rect.origin.y-[UIScreen mainScreen].bounds.size.height+480;
    self.view.frame = rect;

}

- (void)setFixedInfo
{
    [super setFixedInfo];
    _contentScrollView.delegate=self;
    _selectedPhoto=-1;
    
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_contentScrollView)
    {
        scrollView.scrollEnabled=NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView==_contentScrollView)
    {
        int index = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
        
        int total=fabs(scrollView.contentSize.height) / scrollView.frame.size.height;
        
        [[UIApplication sharedApplication] presentToastwithShortInterval:[NSString stringWithFormat:@"%d / %d 页",index+1,total] withVerticalPos:380];
        
        
        if (index+1!=_albumPageNumber)
        {
            _albumPageNumber= index+1;
            
            
            switch (index%3) {
                case 0:
                {
                    if (index!=0)
                    {
                        for (int i=18;i<27;i++)
                        {
                            int wid=i%3;
                            int hei=(i-18)/3;
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];
                        }
                        if (_albumPageNumber*9>_numberOfPhoto)
                        {
                            for (int i=9;i<18;i++)
                            {
                                _photoInAlbum[i].frame=CGRectMake(0, 0, 0, 0);
                                [_photoInAlbum[i].imageView setImage:nil];
                            }
                        }
                        else if (_albumPageNumber*9+9>_numberOfPhoto)  
                        {
                            int count=_numberOfPhoto;
                            int leftNumber=count%9;
                            
                            for (int i=9;i<9+leftNumber;i++)
                            {
                                int wid=i%3;
                                int hei=(i-9)/3;
                                
                                _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                                [_photoInAlbum[i].imageView setImage:nil];
                                
                                
                            }
                            
                            
                            
                            for (int i=leftNumber+9;i<18;i++)
                            {
                                
                                int wid=i%3;
                                int hei=(i-9)/3;
                                
                                _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                                [_photoInAlbum[i].imageView setImage:nil];
                            }
                            
                        }
                        else
                        {
                            for (int i=9;i<18;i++)
                            {
                                int wid=i%3;
                                int hei=(i-9)/3;
                                _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                                [_photoInAlbum[i].imageView setImage:nil];                    }
                        }
                        
                        
                    }
                    else
                    {
                        
                        
                        
                        for (int i=0;i<27;i++)
                        {
                            
                            
                            [_photoInAlbum[i].imageView setImage:nil];
                            
                        }
                        
                    }
                    break;
                }
                case 1:
                {
                    
                    if (_albumPageNumber*9>_numberOfPhoto)
                    {
                        for (int i=18;i<27;i++)
                        {
                            int wid=i%3;
                            int hei=(i-18)/3;
                            
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];
                        }
                    }
                    
                    else if (_albumPageNumber*9+9>_numberOfPhoto)  
                    {
                        int count=_numberOfPhoto;
                        int leftNumber=count%9;
                        
                        for (int i=18;i<leftNumber+18;i++)
                        {
                            int wid=i%3;
                            int hei=(i-18)/3;
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];                        
                        }
                        
                        for (int i=leftNumber+18;i<27;i++)
                        {
                            int wid=i%3;
                            int hei=(i-18)/3;
                            
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];
                        }
                        
                    }
                    
                    
                    else   
                    {
                        for (int i=18;i<27;i++)
                        {
                            int wid=i%3;
                            int hei=(i-18)/3;
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];     
                        }
                    }
                    
                    
                    for (int i=0;i<9;i++)
                    {
                        int wid=i%3;
                        int hei=i/3;
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];                }
                    
                    break;
                }
                case 2:
                {
                    
                    
                    for (int i=9;i<18;i++)
                    {
                        int wid=i%3;
                        int hei=(i-9)/3;
                        _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                        [_photoInAlbum[i].imageView setImage:nil];                }
                    
                    if (_albumPageNumber*9>_numberOfPhoto)
                    {
                        for (int i=0;i<9;i++)
                        {
                            int wid=i%3;
                            int hei=(i-9)/3;
                            
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];                    }
                    }
                    else if (_albumPageNumber*9+9>_numberOfPhoto)  
                    {
                        int count=_numberOfPhoto;
                        int leftNumber=count%9;
                        for (int i=0;i<leftNumber;i++)
                        {
                            int wid=i%3;
                            int hei=i/3;
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];
                        }
                        
                        
                        for (int i=leftNumber;i<9;i++)
                        {
                            
                            int wid=i%3;
                            int hei=(i)/3;
                            
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index-1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];
                        }
                        
                    }
                    
                    else   
                    {
                        for (int i=0;i<9;i++)
                        {
                            int wid=i%3;
                            int hei=i/3;
                            _photoInAlbum[i].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*(index+1)+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
                            [_photoInAlbum[i].imageView setImage:nil];                }
                        
                    }
                    
                    break;
                }
                default:
                    break;
            }
            
            
            
            for (int i=0;i<27;i++)
            {
                
                [_photoInAlbum[i].captian setText:nil];
            }
            [self loadPhotoData];
            
        }
        else
        {
            _contentScrollView.scrollEnabled=YES;
        }
    }
    
}


-(void)loadAlbumData
{
    _activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.center=CGPointMake(153, 300);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
    
    if (_numberOfPhoto<9)
    {
        for (int i=_numberOfPhoto;i<9;i++)
        {
           // _photoInAlbum[i].frame=CGRectMake(0, 0, 0, 0);
            _photoInAlbum[i].hidden=YES;
        }
    }
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            int i=0;
            for(NSDictionary *dict in array) {
                Image *image = [Image imageWithURL:[dict objectForKey:@"url_head"] inManagedObjectContext:self.managedObjectContext];
                if (image == nil)
                {
                    [_photoInAlbum[i].imageView loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_photoInAlbum[i].imageView fadeIn];
                    } cacheInContext:self.managedObjectContext];
                }
                else
                {
                    [_photoInAlbum[i].imageView setImage:[UIImage imageWithData:image.imageData.data]];
                }
                [_photoInAlbum[i].captian setText:[dict objectForKey:@"caption"]];
                _photoID[i]=[[NSString alloc ] initWithString:[[dict objectForKey:@"pid"] stringValue]];
                _bigURL[i]=[[NSString alloc] initWithString:[dict objectForKey:@"url_large"]];
                _commentCount[i]=[[dict objectForKey:@"comment_count"] intValue];
                i++;
            } 
            [_activity stopAnimating];
            [_activity release];
        }
    }];
    if ([self.feedData class]==[NewFeedShareAlbum class])
    {
        [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];
    }
    else if ([self.feedData class]==[NewFeedSharePhoto class])
    {
        [renren getAlbum:((NewFeedSharePhoto*)self.feedData).fromID a_ID:((NewFeedSharePhoto*)self.feedData).albumID pageNumber:_albumPageNumber];
        
    }
    else
    {
        [renren getAlbum:((NewFeedUploadPhoto*)self.feedData).author.userID a_ID:((NewFeedUploadPhoto*)self.feedData).album_ID pageNumber:_albumPageNumber];
        
        
    }
    
    
}
- (void)returnToAlbum
{
    int y=_photoInAlbum[_selectedPhoto].frame.origin.y/VIEW_SIZE;
    [_contentScrollView zoomToRect:CGRectMake(0, y*VIEW_SIZE, 306, VIEW_SIZE) animated:YES];
    [_infoTextView removeFromSuperview];
    [_infoTextView release];
    [_returnToAlbum removeFromSuperview];
    [_returnToAlbum release];
    _selectedPhoto=-1;
    
    
    if (_firstToAlbum!=0)
    {
        [_bigURL[0] release];
        _firstToAlbum=0;
        RenrenClient *renren = [RenrenClient client];
        [renren setCompletionBlock:^(RenrenClient *client) {
            if(!client.hasError) {
                NSArray *array = client.responseJSONObject;
                for(NSDictionary *dict in array) {
                    int size=[[dict objectForKey:@"size"] intValue];
                    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* (size/9+1))];
                    [_contentView setFrame:CGRectMake(0, 0,_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* (size/9+1))];
                    _numberOfPhoto=size;
                } 
                [self loadAlbumData];
            }
        }];
        if ([self.feedData class]==[NewFeedSharePhoto class])
        {
            [renren getAlbumInfo:((NewFeedSharePhoto*)self.feedData).fromID a_ID:((NewFeedSharePhoto*)self.feedData).albumID];
            
        }
        else
        {
            [renren getAlbumInfo:((NewFeedUploadPhoto*)self.feedData).author.userID a_ID:((NewFeedUploadPhoto*)self.feedData).album_ID];
            
        }
        
        
    }
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    
    if (_selectedPhoto!=-1)
    {
        _infoTextView =[[UITextView alloc] init];
        _infoTextView.frame=CGRectMake(22, 300, 260,50);
        _infoTextView.editable=NO;
        
        _infoTextView.backgroundColor=[UIColor clearColor];
        
        [_infoTextView setTextColor:[UIColor colorWithRed:0.32157 green:0.31373 blue:0.2666667 alpha:1]];
        [_infoTextView setFont:[UIFont systemFontOfSize:15]];
        _infoTextView.text=_photoInAlbum[_selectedPhoto].captian.text;
        _infoTextView.contentOffset=CGPointMake(0, 10);
        
        
        _returnToAlbum=[[UIButton alloc] init];
        _returnToAlbum.frame=CGRectMake(242 ,48, 60, 27);
        [_returnToAlbum setTitle:@"显示全部" forState:UIControlStateNormal];
        [_returnToAlbum.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_returnToAlbum setBackgroundImage:[UIImage imageNamed:@"detail_show_all.png"] forState:UIControlStateNormal];
        [_returnToAlbum setTitleColor:[UIColor colorWithRed:0.3765 green:0.3725 blue:0.3059 alpha:1] forState:UIControlStateNormal];
        [_returnToAlbum addTarget:self action:@selector(returnToAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_returnToAlbum];
        [self.view addSubview:_infoTextView];
        
        Image *image = [Image imageWithURL:_bigURL[_selectedPhoto%9] inManagedObjectContext:self.managedObjectContext];
        if (image == nil)
        {
            [_photoInAlbum[_selectedPhoto].imageView loadImageFromURL:_bigURL[_selectedPhoto%9] completion:^{
                
                
            } cacheInContext:self.managedObjectContext];
            
        }
        else
        {
            [_photoInAlbum[_selectedPhoto].imageView setImage:[UIImage imageWithData:image.imageData.data]];
            
        }
       _albumTitle.frame=CGRectMake(51 , 52, 192, 21);
  
    }
    else
    {
        for (int i=0;i<27;i++)
        {
            [_photoInAlbum[i] showCaptian];
        }
        scrollView.scrollEnabled=YES;
  _albumTitle.frame=CGRectMake(51 , 52, 245, 21);
    }
}


- (IBAction)showImageDetail:(id)sender
{
    
    
    if (_selectedPhoto==-1)
    {
        for (int i=0;i<27;i++)
        {
            if (_photoInAlbum[i].imageOut==sender)
            {
                _selectedPhoto=i;
                break;
            }
        }
        [_photoInAlbum[_selectedPhoto] hideCaptian];
        [_photoInAlbum[_selectedPhoto].imageOut setImage:[UIImage imageNamed:@"detail_photo.png"] forState:UIControlStateNormal];
        
        
        CGRect zoomingRect=((UIButton*)sender).superview.frame;
        
        [_contentScrollView zoomToRect:zoomingRect animated:YES];
        _contentScrollView.scrollEnabled=NO;
        
        _pageNumber=_commentCount[_selectedPhoto%9]/10+1;
        [self clearData];
        [self loadData];
    }
    else
    {
        Image* imageData = [Image imageWithURL:_bigURL[_selectedPhoto%9] inManagedObjectContext:self.managedObjectContext];
        UIImage *image = [UIImage imageWithData:imageData.imageData.data];
        [DetailImageViewController showDetailImageWithImage:image];
    }
}
- (void)loadPhotoData
{
    
    _activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.center=CGPointMake(153, 300);
    [self.view addSubview:_activity];
    [_activity startAnimating];
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            int i=(_albumPageNumber+2)%3*9;
            for(NSDictionary *dict in array) {
                
                Image *image = [Image imageWithURL:[dict objectForKey:@"url_head"] inManagedObjectContext:self.managedObjectContext];
                if (image == nil)
                {
                    [_photoInAlbum[i].imageView loadImageFromURL:[dict objectForKey:@"url_head"] completion:^{
                        [_photoInAlbum[i].imageView fadeIn];
                    } cacheInContext:self.managedObjectContext];
                    _photoInAlbum[i].imageView.clipsToBounds=YES;
                }
                else
                {
                    [_photoInAlbum[i].imageView setImage:[UIImage imageWithData:image.imageData.data]];
                    [_photoInAlbum[i].imageView fadeIn];
                    
                }
                
                [_photoInAlbum[i].captian setText:[dict objectForKey:@"caption"]];
                
                
                int j=i%9;
                [_photoID[j] release];
                _photoID[j] =[[NSString alloc ] initWithString:[[dict objectForKey:@"pid"] stringValue]];
                [_bigURL[j] release];
                _bigURL[j]=[[NSString alloc] initWithString:[dict objectForKey:@"url_large"]];
                _commentCount[j]=[[dict objectForKey:@"comment_count"] intValue];
                i++;
                
                
                
            } 
            [_activity stopAnimating];
            
            [_activity release];
            _contentScrollView.scrollEnabled=YES;
            
        }
    }];
    if ([self.feedData class]==[NewFeedShareAlbum class])
    {
        [renren getAlbum:((NewFeedShareAlbum*)self.feedData).fromID a_ID:((NewFeedShareAlbum*)self.feedData).media_ID pageNumber:_albumPageNumber];
    }
    else if ([self.feedData class]==[NewFeedSharePhoto class])
    {
        [renren getAlbum:((NewFeedSharePhoto*)self.feedData).fromID a_ID:((NewFeedSharePhoto*)self.feedData).albumID pageNumber:_albumPageNumber];
        
    }
    else
    {
        [renren getAlbum:((NewFeedUploadPhoto*)self.feedData).author.userID a_ID:((NewFeedUploadPhoto*)self.feedData).album_ID pageNumber:_albumPageNumber];
        
    }
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _contentView;
}


-(void)loadtoAlbumData
{
    
    
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* ([((NewFeedShareAlbum*)self.feedData).album_count intValue]/9+1))];
    [_contentView setFrame:CGRectMake(0, 0,_contentScrollView.frame.size.width, _contentScrollView.frame.size.height* ([((NewFeedShareAlbum*)self.feedData).album_count intValue]/9+1))];
    
    _firstToAlbum=0;
    [_albumTitle setText:((NewFeedShareAlbum*)self.feedData).album_title];
    
    _numberOfPhoto=[((NewFeedShareAlbum*)self.feedData).album_count intValue]+1;
    [self loadAlbumData];
    
    
}
-(void)loadToPhoto
{
    _firstToAlbum=1;
    [_contentScrollView setContentSize:CGSizeMake(_contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    [_contentView setFrame:CGRectMake(0, 0,_contentScrollView.frame.size.width, _contentScrollView.frame.size.height)];
    
    
    if ([self.feedData class]==[NewFeedSharePhoto class])
    {
        [_albumTitle setText:((NewFeedSharePhoto*)self.feedData).title];
        _photoID[0]=((NewFeedSharePhoto*)self.feedData).mediaID;
        _commentCount[0]=[((NewFeedSharePhoto*)self.feedData).comment_Count intValue];
        
    }
    else
    {
        [_albumTitle setText:((NewFeedUploadPhoto*)self.feedData).title];
        _photoID[0]=((NewFeedUploadPhoto*)self.feedData).photo_ID;
        _commentCount[0]=[((NewFeedUploadPhoto*)self.feedData).comment_Count intValue];
    }
    
    _contentScrollView.scrollEnabled=NO;
    
    _pageNumber=_commentCount[_selectedPhoto%9]/10+1;
    _selectedPhoto=0;
    
    [self clearData];
    
    RenrenClient *renren = [RenrenClient client];
    [renren setCompletionBlock:^(RenrenClient *client) {
        if(!client.hasError) {
            NSArray *array = client.responseJSONObject;
            
            for(NSDictionary *dict in array) {
                
                [_photoInAlbum[0].captian setText:[dict objectForKey:@"caption"]];
                [_photoInAlbum[0] hideCaptian];
                
                _bigURL[0]=[[NSString alloc] initWithString:[dict objectForKey:@"url_large"]];
                
            } 
            
            [_contentScrollView zoomToRect:_photoInAlbum[0].frame animated:YES];
        }
    }];
    if ([self.feedData class]==[NewFeedSharePhoto class])
    {
        [renren getSinglePhoto:((NewFeedSharePhoto*)self.feedData).fromID photoID:((NewFeedSharePhoto*)self.feedData).mediaID ];
    }
    else
    {
        
        [renren getSinglePhoto:((NewFeedUploadPhoto*)self.feedData).author.userID photoID:((NewFeedUploadPhoto*)self.feedData).photo_ID ];
        
    }
    
    
    
    
    
    
}
- (void)loadMainView
{
    
    _albumPageNumber=1;
    _contentScrollView.pagingEnabled=YES;
    _contentScrollView.directionalLockEnabled=YES;
    _contentScrollView.maximumZoomScale=10.0;
    
    for (int j=0;j<3;j++)
    {
        for (int i=0;i<9;i++)
        {
            _photoInAlbum[i+9*j]=[[PhotoInAlbum alloc] init];
            int wid=i%3;
            int hei=i/3;
            _photoInAlbum[i+9*j].frame=CGRectMake(IMAGE_OUT_BEGIN_X+wid*(IMAGE_OUT_V_SPACE+IMAGE_OUT_WIDTH), VIEW_SIZE*j+IMAGE_OUT_BEGIN_Y+hei*(IMAGE_OUT_H_SPACE+IMAGE_OUT_HEIGHT), IMAGE_OUT_WIDTH, IMAGE_OUT_HEIGHT+15);
            [ _photoInAlbum[i+9*j].imageOut addTarget:self action:@selector(showImageDetail:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:_photoInAlbum[i+9*j]];
        }
    }
    
    
    if ([self.feedData class]==[NewFeedShareAlbum class])
    {
        [self loadtoAlbumData];
    }
    else
    {
        [self loadToPhoto];
    }
}



#pragma mark - EGORefresh Method
- (void)refresh {
    
    [self hideLoadMoreDataButton];
    _clearDataFlag = YES;
    
    _pageNumber = _commentCount[_selectedPhoto % 9] / 10 + 1;
    
    [self loadData];
}




- (void)loadData
{
    if(_loadingFlag)
        return;
    _loadingFlag = YES;
    
    if ([self.feedData class]==[NewFeedShareAlbum class])
    {
        if (_selectedPhoto==-1) {
            RenrenClient *renren = [RenrenClient client];
            [renren setCompletionBlock:^(RenrenClient *client) {
                if(!client.hasError) {
                    [self clearData];
                    NSArray *array = client.responseJSONObject;
                    array=[client.responseJSONObject objectForKey:@"comments"];
                    [self ProcessRenrenData:array];
                    
                }
            }];
            
            [renren getShareComments:((NewFeedShareAlbum*)self.feedData).fromID share_ID:((NewFeedShareAlbum*)self.feedData).source_ID pageNumber:_pageNumber];
        }
        else {
            RenrenClient *renren = [RenrenClient client];
            [renren setCompletionBlock:^(RenrenClient *client) {
                if(!client.hasError) {
                    [self clearData];
                    NSArray *array = client.responseJSONObject;
                    [self ProcessRenrenData:array];
                }
            }];
            [renren getPhotoComments:((NewFeedShareAlbum*)self.feedData).fromID photo_ID:_photoID[_selectedPhoto%9] pageNumber:_pageNumber];
        }
    }
    else if ([self.feedData class]==[NewFeedSharePhoto class])
    {
        if (_firstToAlbum==1)
        {
            RenrenClient *renren = [RenrenClient client];
            [renren setCompletionBlock:^(RenrenClient *client) {
                if(!client.hasError) {
                    NSArray *array = client.responseJSONObject;
                    array=[client.responseJSONObject objectForKey:@"comments"];
                    [self ProcessRenrenData:array];
                    
                }
            }];
            
            [renren getShareComments:((NewFeedSharePhoto*)self.feedData).fromID share_ID:((NewFeedSharePhoto*)self.feedData).source_ID pageNumber:_pageNumber];
        }
        else
        {
            if (_selectedPhoto!=-1)
            {
                
                
                
                RenrenClient *renren = [RenrenClient client];
                [renren setCompletionBlock:^(RenrenClient *client) {
                    if(!client.hasError) {
                        NSArray *array = client.responseJSONObject;
                        [self ProcessRenrenData:array];
                    }
                }];
                [renren getPhotoComments:((NewFeedShareAlbum*)self.feedData).fromID photo_ID:_photoID[_selectedPhoto%9] pageNumber:_pageNumber];
                
            }
            
            
        }
    }
    
    else
    {
        if (_selectedPhoto!=-1)
        {
            
            
            
            RenrenClient *renren = [RenrenClient client];
            [renren setCompletionBlock:^(RenrenClient *client) {
                if(!client.hasError) {
                    NSArray *array = client.responseJSONObject;
                    [self ProcessRenrenData:array];
                }
            }];
            [renren getPhotoComments:((NewFeedUploadPhoto*)self.feedData).author.userID photo_ID:_photoID[_selectedPhoto%9] pageNumber:_pageNumber];
            
        } 
    }
    
}


-(IBAction)repost
{
    RepostViewController *vc = [[RepostViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    [vc setStyle:kPhoto];
    vc.feedData=self.feedData;
   // NSLog(@"%d",_selectedPhoto);
    if (_selectedPhoto!=-1)
    {
        vc.photoURL=_bigURL[_selectedPhoto%9];
        vc.photoID=_photoID[_selectedPhoto%9];
        vc.photoComment=_photoInAlbum[_selectedPhoto].captian.text;
    }
    [vc setcommentPage:NO];
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}


-(IBAction)comment:(id)sender
{
    
    UITableViewCell* cell=(UITableViewCell*)((UIButton*)sender).superview.superview;
    NSIndexPath* indexPath=[self.tableView indexPathForCell:cell];
    if (_showMoreButton == YES)
    {
        indexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    }
    StatusCommentData* data=[self.fetchedResultsController objectAtIndexPath:indexPath];
    RepostViewController *vc = [[RepostViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    [vc setStyle:kPhoto];
    [vc setcommentPage:YES];
    vc.feedData=self.feedData;
    if (_selectedPhoto!=-1)
    {
        vc.photoURL=_bigURL[_selectedPhoto%9];
        vc.photoID=_photoID[_selectedPhoto%9];
        vc.photoComment=_photoInAlbum[_selectedPhoto].captian.text;
    }
    vc.commetData=data;
    
    
    [[UIApplication sharedApplication] presentModalViewController:vc];
    [vc release];
}


@end
