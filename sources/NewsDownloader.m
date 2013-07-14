//
//  NewsDownloader.m
//  Rotato
//
//  Created by Hin Lam on 7/12/13.
//
//

#import "NewsDownloader.h"

@interface NewsDownloader()
{
    NSString *sourceURL;
    NSString *currentXMLElementString;
    NSString *newsVersion;
    NSString *currentNewsDate;
    NSString *currentNewsDescription;
    NSString *currentNewsDownloadLink;
    NSString *currentNewsPictureLink;
}
- (void) getXMLFromURLandParse;

@end

@implementation NewsDownloader
@synthesize dateString;
@synthesize descriptionString;
@synthesize downloadLinkString;
@synthesize pictureLinkString;


- (id) initWithURL:(NSString *)URL
{

    if ([self init]!= nil)
    {
        sourceURL = URL;

        // Load news from the device
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        newsVersion = [userDefault stringForKey:@"NewsVersion"];
        self.dateString = [userDefault stringForKey:@"NewsDate"];
        self.descriptionString = [userDefault stringForKey:@"NewsDescription"];
        self.downloadLinkString = [userDefault stringForKey:@"NewsDownloadLink"];
        self.pictureLinkString = [userDefault stringForKey:@"NewsPictureLink"];
        NSLog(@"Version on Device %@",newsVersion);
        
    }
    [self getXMLFromURLandParse];
    return (self);
}

- (void) getXMLFromURLandParse
{
    NSURL *url = [NSURL URLWithString:sourceURL];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlParser.delegate = self;
    [xmlParser parse];

}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    return;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentXMLElementString = string;
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([elementName isEqualToString:@"News"])
    {
        // Write the new Data
        [userDefault setObject:newsVersion forKey:@"NewsVersion"];
        [userDefault setObject:self.dateString forKey:@"NewsDate"];
        [userDefault setObject:self.descriptionString forKey:@"NewsDescription"];
        [userDefault setObject:self.downloadLinkString forKey:@"NewsDownloadLink"];
        [userDefault setObject:self.pictureLinkString forKey:@"NewsPictureLink"];
        [userDefault synchronize];
        
    }
    else if ([elementName isEqualToString:@"Version"])
    {
        if ([newsVersion integerValue] < [currentXMLElementString integerValue])
        {
            [userDefault setInteger:1 forKey:@"NewsUnReadStatus"];
            [userDefault synchronize];
            NSLog(@"old Version on Device %@ newVersion on XML %@",newsVersion,currentXMLElementString);
        }
        newsVersion = currentXMLElementString;
    }
    else if ([elementName isEqualToString:@"Date"])
    {
        self.dateString = currentXMLElementString;
    }
    else if ([elementName isEqualToString:@"Description"])
    {
        self.descriptionString = currentXMLElementString;
    }
    else if ([elementName isEqualToString:@"DownloadLink"])
    {
        self.downloadLinkString = currentXMLElementString;
    }
    else if ([elementName isEqualToString:@"PictureLink"])
    {
        self.pictureLinkString = currentXMLElementString;
    }
    currentXMLElementString = nil;
    
}

- (void) setNewsUnreadStatus:(BOOL)status
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setInteger:(status == YES?1:0) forKey:@"NewsUnReadStatus"];
    [userDefault synchronize];
}

- (BOOL) hasUnreadNews
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int rc = [userDefault integerForKey:@"NewsUnReadStatus"];
    return (rc==1?TRUE:FALSE);
}

@end
