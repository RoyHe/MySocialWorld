//
//  AlbumDetailController.h
//  SocialFusion
//
//  Created by He Ruoyun on 12-2-12.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "StatusDetailController.h"
#import "PhotoInAlbum.h"
 
@interface AlbumDetailController : StatusDetailController
{
        IBOutlet UILabel* _albumTitle;
    IBOutlet UIScrollView* _contentScrollView;

    int _albumPageNumber;
    
    PhotoInAlbum* _photoInAlbum[27];
    
    NSString* _photoID[9];
    NSString* _bigURL[9];
    
    int _commentCount[9];
    UITextView* _infoTextView;
    IBOutlet UIView* _contentView;
    UIButton* _returnToAlbum;
    int _selectedPhoto;
    
    int _firstToAlbum;
    int _numberOfPhoto;
  
}

- (void)loadPhotoData;
- (IBAction)showImageDetail:(id)sender;
- (void)returnToAlbum;
@end
