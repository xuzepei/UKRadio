//
//  HttpParser.h
//  UKRadio
//
//  Created by xuzepei on 2017/6/22.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpParser : NSObject

+ (HttpParser*)sharedInstace;
- (NSArray*)parse:(NSString*)httpString;
- (NSArray*)parseForVideo:(NSString*)httpString;
- (NSArray*)parseForGongLue:(NSString*)httpString;
- (NSString*)parseForGongLueDetail:(NSString*)httpString;
- (NSArray*)parseForChuZhuang:(NSString*)httpString;
- (NSString*)parseForChuZhuangDetail:(NSString*)httpString;
- (NSArray*)parseForHeros:(NSString*)httpString;

@end
