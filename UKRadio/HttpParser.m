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
        NSString* queryString = @"//ul[@class='txt-list cf']/li";
        NSArray *nodes = [hpple searchWithXPathQuery:queryString];
        
        NSMutableArray* array = [NSMutableArray new];
        for (TFHppleElement *element in nodes) {
            
            NSArray* children = element.children;
            
            NSString* date = nil;
            TFHppleElement* element_child_div = nil;
            for(TFHppleElement* temp in children)
            {
                if([[temp.attributes objectForKey:@"class"] isEqualToString:@"tl-tit cf"])
                {
                    NSArray* tempArray = [temp childrenWithTagName:@"span"];
                    if([tempArray count])
                    {
                        TFHppleElement* element_child_div_span = [tempArray firstObject];
                        date = element_child_div_span.content;
                        NSLog(@"date:%@",date);
                    }
                }
                

                if([[temp.attributes objectForKey:@"class"] isEqualToString:@"tl-img cf"])
                {
                    element_child_div = temp;
                    break;
                }
            }
            
            if(element_child_div)
            {
                NSMutableDictionary* dict = [NSMutableDictionary new];
                
                NSArray* tempArray = [element_child_div childrenWithTagName:@"a"];
                if([tempArray count])
                {
                    TFHppleElement* element_child_div_a = [tempArray firstObject];
                    NSString* href = [element_child_div_a objectForKey:@"href"];
                    NSLog(@"href:%@",href);
                
                    if(href.length)
                    {
                        if([href hasPrefix:@"http://"] || [href hasPrefix:@"https://"])
                            [dict setObject:href forKey:@"url"];
                        else
                            [dict setObject:[NSString stringWithFormat:@"http://m.news.4399.com/%@",href] forKey:@"url"];
                    }
                    
                    tempArray = [element_child_div_a childrenWithTagName:@"img"];
                    if([tempArray count])
                    {
                        TFHppleElement* element_child_div_img = [tempArray firstObject];
                        NSString* src = [element_child_div_img objectForKey:@"src"];
                        NSString* alt = [element_child_div_img objectForKey:@"alt"];
                        
                        NSLog(@"src:%@",src);
                        NSLog(@"alt:%@",alt);
                        
                        if(src.length)
                            [dict setObject:src forKey:@"image_url"];
                        if(alt.length)
                            [dict setObject:alt forKey:@"name"];
                        if(date.length)
                            [dict setObject:date forKey:@"date"];
                        
                        if(src.length && href.length)
                            [array addObject:dict];
                    }
                }
            }
        }
        
        return array;
    }

    return nil;
}

@end
