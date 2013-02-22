//
//  StatusCommentCell.h
//  SocialFusion
//
//  Created by He Ruoyun on 11-10-18.
//  Copyright (c) 2011年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCommentData+StatusCommentData_Addition.h"
@interface StatusCommentCell : UITableViewCell
{
    IBOutlet UIButton* _userName;
    IBOutlet UILabel* _status;
    IBOutlet UILabel* _time;
    IBOutlet UIButton* _commentButton;
    IBOutlet UIImageView* _secret;
}




+(float)heightForCell:(StatusCommentData*)feedData;
- (void)configureCell:(StatusCommentData*)feedData colorStyle:(BOOL)bo;
@end
