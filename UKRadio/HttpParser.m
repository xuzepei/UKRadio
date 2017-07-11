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
                }else if([[temp.attributes objectForKey:@"class"] isEqualToString:@"tl-img cf"])
                {
                    element_child_div = temp;
                    //break;
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
                
                text = [NSString stringWithFormat:@"视频地址%d",i];
                
                [array addObject:@{@"url": link, @"text": text}];
                
                i++;
            }
            
        }
        
        return array;
    }
    
    return nil;
}

- (NSArray*)parseForGongLue:(NSString*)httpString
{
    if(0 == httpString.length)
        return nil;
    
    NSData* data = [httpString dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple* hpple = [TFHpple hppleWithHTMLData:data];
    if(hpple)
    {
        NSString* queryString = @"//div[@class='liebiao']/ul/li";
        NSArray *nodes = [hpple searchWithXPathQuery:queryString];
        
        NSMutableArray* array = [NSMutableArray new];
        for (TFHppleElement *element in nodes) {
            
            NSArray* children = element.children;
            
            NSString* date = nil;
            TFHppleElement* element_child_div = nil;
            for(TFHppleElement* temp in children)
            {
                if([[temp.attributes objectForKey:@"class"] isEqualToString:@"lie-news"])
                {
                    NSArray* divs = [temp childrenWithTagName:@"div"];
                    if([divs count])
                    {
                        TFHppleElement* div_lie_di = [divs lastObject];
                        NSArray* tempArray = [div_lie_di childrenWithTagName:@"time"];
                        if([tempArray count])
                        {
                            TFHppleElement* element_child_div_time = [tempArray firstObject];
                            date = element_child_div_time.content;
                            NSLog(@"date:%@",date);
                        }
                    }
                }
                else if([[temp.attributes objectForKey:@"class"] isEqualToString:@"lie-img"])
                {
                    element_child_div = temp;
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
                    if(href.length)
                    {
                        if([href hasPrefix:@"http://"] || [href hasPrefix:@"https://"])
                            [dict setObject:href forKey:@"url"];
                    }
                    
                    NSString* name = [element_child_div_a objectForKey:@"title"];
                    
                    tempArray = [element_child_div_a childrenWithTagName:@"img"];
                    if([tempArray count])
                    {
                        TFHppleElement* element_child_div_img = [tempArray firstObject];
                        NSString* src = [element_child_div_img objectForKey:@"src"];
                        
                        if(src.length)
                            [dict setObject:src forKey:@"image_url"];
                        if(name.length)
                            [dict setObject:name forKey:@"name"];
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

- (NSString*)parseForGongLueDetail:(NSString*)httpString
{
    if(0 == httpString.length)
        return nil;
    
    NSRange range = [httpString rangeOfString:@"<div class=\"zhengwen-main\">"];
    if(range.location != NSNotFound)
    {
        httpString = [httpString substringFromIndex:range.location];
        range = [httpString rangeOfString:@"<!--通栏广告-->"];
        if(range.location != NSNotFound)
        {
            httpString = [httpString substringToIndex:range.location];
        }
    }
    
    //@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"%@\"/><script type=\"text/javascript\" charset=\"utf-8\" src=\"bbc.js\"></script></head><body><div class=\"titleDiv\"><font>%@</font></div><div id=\"date\">%@</div><a href=\"%@\"><img class=\"topImage\" src=\"%@\"/></a>%@<br><br><br><br></body></html>"
    
    return [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"my.css\"/></head><body>%@<br><br><br><br></body></html>",httpString];
    
}

- (NSArray*)parseForChuZhuang:(NSString*)httpString
{
    
    if(0 == httpString.length)
        return nil;
    
    NSData* data = [httpString dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple* hpple = [TFHpple hppleWithHTMLData:data];
    if(hpple)
    {
        NSString* queryString = @"//div[@class='list-div arc-list-wrap']/ul/li";
        NSArray *nodes = [hpple searchWithXPathQuery:queryString];
        
        NSMutableArray* array = [NSMutableArray new];
        for (TFHppleElement *element in nodes) {
            
            NSArray* tags = [element childrenWithTagName:@"a"];
            if([tags count])
            {
                TFHppleElement* element_a = [tags lastObject];
                if(element_a)
                {
                    NSString* name = [element_a objectForKey:@"title"];
                    NSString* href = [element_a objectForKey:@"href"];
                    NSString* imageUrl = nil;
                    
                    NSArray* child_divs = [element_a childrenWithTagName:@"div"];
                    
                    TFHppleElement* element_div = nil;
                    for(TFHppleElement* temp in child_divs)
                    {
                        if([[temp.attributes objectForKey:@"class"] isEqualToString:@"pic ani-pic"])
                        {
                            element_div = temp;
                            break;
                        }
                    }
                    
                    
                    if(element_div)
                    {
                        NSArray* child_imgs = [element_div childrenWithTagName:@"img"];
                        if([child_imgs count])
                        {
                            TFHppleElement* element_img = [child_imgs lastObject];
                            if(element_img)
                            {
                                imageUrl = [element_img objectForKey:@"data-original"];
                            }
                        }
                    }
                    
                    
                    NSMutableDictionary* dict = [NSMutableDictionary new];
                    if(imageUrl.length)
                        [dict setObject:imageUrl forKey:@"image_url"];
                    if(name.length)
                        [dict setObject:name forKey:@"name"];
                    
                    if([href hasPrefix:@"http://"] || [href hasPrefix:@"https://"])
                        [dict setObject:href forKey:@"url"];
                    
                    if(imageUrl.length && href.length)
                        [array addObject:dict];
                    
                }
            }
            
        }
        
        return array;
    }
    
    return nil;
}

- (NSString*)parseForChuZhuangDetail:(NSString*)httpString
{
    
    if(0 == httpString.length)
        return nil;
    
    NSRange range = [httpString rangeOfString:@"<div class=\"arc-body\">"];
    if(range.location != NSNotFound)
    {
        httpString = [httpString substringFromIndex:range.location];
        range = [httpString rangeOfString:@"推荐阅读"];
        if(range.location != NSNotFound)
        {
            httpString = [httpString substringToIndex:range.location];
        }
        else
        {
            range = [httpString rangeOfString:@"<!-- 分页 -->"];
            if(range.location != NSNotFound)
            {
                httpString = [httpString substringToIndex:range.location];
            }
        }
    }
    
    //@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"%@\"/><script type=\"text/javascript\" charset=\"utf-8\" src=\"bbc.js\"></script></head><body><div class=\"titleDiv\"><font>%@</font></div><div id=\"date\">%@</div><a href=\"%@\"><img class=\"topImage\" src=\"%@\"/></a>%@<br><br><br><br></body></html>"
    
    httpString = [httpString stringByReplacingOccurrencesOfString:@"//img.18183.com" withString:@"http://img.18183.com"];
    httpString = [httpString stringByReplacingOccurrencesOfString:@"http:http:" withString:@"http:"];
    
    return [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"my.css\"/></head><body>%@<br><br><br><br></body></html>",httpString];
}

@end
