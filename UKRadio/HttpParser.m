//
//  HttpParser.m
//  UKRadio
//
//  Created by xuzepei on 2017/6/22.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

#import "HttpParser.h"
#import "TFHpple.h"

@implementation HttpParser

+ (HttpParser*)sharedInstace
{
    static HttpParser* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [HttpParser new];
    });
    
    return sharedInstance;
}

- (NSArray*)parse:(NSString*)httpString
{
    if(0 == httpString.length)
        return nil;
    
    NSData* data = [httpString dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple* hpple = [TFHpple hppleWithHTMLData:data];
    if(hpple)
    {
        NSString* queryString = @"//a";
        NSArray *nodes = [hpple searchWithXPathQuery:queryString];
        
        NSMutableArray* array = [NSMutableArray new];
        
        for (TFHppleElement *element in nodes) {
            
            if([[element.attributes objectForKey:@"target"] isEqualToString:@"_top"])
            {
                NSString* href = [element.attributes objectForKey:@"href"];
                NSLog(@"href:%@",href);
                if(href.length)
                {
                    NSMutableDictionary* dict = [NSMutableDictionary new];
                    
                    if([href hasPrefix:@"http://"] || [href hasPrefix:@"https://"])
                        [dict setObject:href forKey:@"url"];
                    else if([href hasPrefix:@"python3/"])
                        [dict setObject:[NSString stringWithFormat:@"http://www.runoob.com/%@",href] forKey:@"url"];
                    else
                        [dict setObject:[NSString stringWithFormat:@"http://www.runoob.com/python3/%@",href] forKey:@"url"];
                    
                    NSString* title = [element.attributes objectForKey:@"title"];
                    if(title.length)
                        [dict setObject:title forKey:@"title"];
                    
                    [array addObject:dict];
                }

            }
        }
        
        return array;
    }

    return nil;
}

- (NSArray*)parseForVideo:(NSString*)httpString
{
    if(0 == httpString.length)
        return nil;
    
    NSData* data = [httpString dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple* hpple = [TFHpple hppleWithHTMLData:data];
    if(hpple)
    {
        NSString* queryString = @"//a";
        NSArray *nodes = [hpple searchWithXPathQuery:queryString];
        
        NSMutableArray* array = [NSMutableArray new];
        int i = 1;
        for (TFHppleElement *element in nodes) {
            
            NSString* link = [element objectForKey:@"href"];
            
            NSString* text = element.content;
            
            if([link rangeOfString:@".youku.com"].location != NSNotFound)
            {
                NSRange range = [link rangeOfString:@"url="];
                if(range.location != NSNotFound)
                    link = [link substringFromIndex:range.location + range.length];
                
                
//                if(0 == text.length)
//                {
//                    text = @"新连接";
//                }
                
                text = [NSString stringWithFormat:@"视频地址%d",i];
                
                [array addObject:@{@"url": link, @"text": text}];
                
                i++;
            }
            
        }
        
        return array;
    }
    
    return nil;
}

@end
