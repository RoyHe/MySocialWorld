//
//  NewFeedCellHeight.m
//  SocialFusion
//
//  Created by He Ruoyun on 12-1-15.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "NewFeedCellHeight.h"
#import "NewFeedListController.h"
#import "NSString+HTMLSet.h"
@implementation NewFeedCellHeight

- (void)myinit:(NewFeedListController*)deleControl
{
    _webView = [[UIWebView alloc] init];    
    NSString *infoSouceFile = [[NSBundle mainBundle] pathForResource:@"blogcell" ofType:@"html"];
    NSString *infoText = [NSString stringWithContentsOfFile:infoSouceFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:infoText baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    _webView.backgroundColor=[UIColor clearColor];
    _webView.opaque=NO;
    _webView.frame=CGRectMake(0, 0, 400, 10);
    _webView.scalesPageToFit=NO;
    _webView.scrollView.scrollEnabled=NO;
    _webView.delegate=self;
   _dele=deleControl;
    
}
//delegate  webView
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_dele refresh];
}


- (int)getHeight:(NSDictionary*)dict style:(int)style
{
    int scrollHeight ;
    
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setName('我')"]];   
 if (style==1)
 {
     NSDictionary* attachment=[dict objectForKey:@"retweeted_status"];
     NSString* string=[dict objectForKey:@"text"];

     string=[string replaceHTMLSign:kWeibo];
     
     //  string=[string stringByReplacingOccurrencesOfString:@"&" withString:@"\\&"];
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",string]];   
   
   
     
     if ([attachment count]==0)
     {
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('')"]];
         scrollHeight=  [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
         if ([dict objectForKey:@"thumbnail_pic"]!=nil)
         {
             scrollHeight=scrollHeight+65;
         }
     }
     else
     {
         

         NSString* outString=[NSString stringWithFormat:@"%@:%@",[[attachment objectForKey:@"user"] objectForKey:@"screen_name"],[attachment objectForKey:@"text"]];
     
         
         outString=[outString replaceHTMLSign:kWeibo];
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('%@')",outString]];
         scrollHeight=  [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
         if ([attachment objectForKey:@"thumbnail_pic"]!=nil)
         {
             scrollHeight=scrollHeight+45+65;
         }
         else
         {
             scrollHeight=scrollHeight+25;
         }
     }
     
 }
 else 
 {
     if (([[dict objectForKey:@"feed_type"] intValue]==20)||([[dict objectForKey:@"feed_type"] intValue]==21))
     {
         
         NSString* outString=[NSString stringWithFormat:@"%@《%@》",[dict objectForKey:@"prefix"],[dict objectForKey:@"title"]];
         
         
         outString=[outString replaceHTMLSign:kRenren];
         
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",outString]];
         
         
         outString=[dict objectForKey:@"description"];
        // NSLog(@":%@:",outString);
         
         outString=[outString replaceHTMLSign:kRenren];
 
         
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('%@')",outString]];
         
          scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
         
  
     }

     else if ([[dict objectForKey:@"feed_type"] intValue]==33)
     {
         
         
         
         NSString* string=[dict objectForKey:@"message"];
         if ([string compare:@""]==0)
         {
             [_webView stringByEvaluatingJavaScriptFromString:@"setWeibo('a')"];                                                                         
         }
         else
         {
             
             string=[string replaceHTMLSign:kRenren];
             
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",string]];                                                                         
             
         }
         
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('')"]];
          scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
         
         scrollHeight=scrollHeight+68;
     }
     else if ([[dict objectForKey:@"feed_type"] intValue]==32)
     {
         
         NSString* string=[dict objectForKey:@"message"];
         
         if ([string compare:@""]==0)
         {
             [_webView stringByEvaluatingJavaScriptFromString:@"setWeibo('a')"];                                                                         
         }
         else
         {
             
             string=[string replaceHTMLSign:kRenren];
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",string]];                                                                         
             
         }
         
         [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('')"]];
          scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
         
         scrollHeight=scrollHeight+88;
     }
     else
     {
 
         NSArray* attachments=[dict objectForKey:@"attachment"];
         if ([attachments count]==0)
         {
             NSString* string=[dict objectForKey:@"message"];
             
             string=[string replaceHTMLSign:kRenren];
         //    NSLog(@"%@",string);
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",string]];         
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('')"]];
             scrollHeight = [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];                 
         }
         else
         {
             NSString* string=[dict objectForKey:@"message"];
             
             string=[string replaceHTMLSign:kRenren];  
             
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setWeibo('%@')",string]];         
           
             NSString* outString=[NSString stringWithFormat:@"%@:%@",[[attachments objectAtIndex:0] objectForKey:@"owner_name"], [[attachments objectAtIndex:0] objectForKey:@"content"]];
             
             outString=[outString replaceHTMLSign:kRenren];          //   NSLog(@"start:%@:end",outString);
             
            // unichar ch=[outString characterAtIndex:[outString length]-1];
            // unichar ch2=[outString characterAtIndex:[outString length]-2];

//             unichar ch3=[outString characterAtIndex:[outString length]-3];

  //           NSLog(@"%c%c%c",ch3,ch2,ch);
             [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setRepost('%@')", outString ]];
             scrollHeight=  [[_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] intValue];
             scrollHeight=scrollHeight+25;
         }
     }
     
     
     
     
 }
      return  scrollHeight;
}

@end
