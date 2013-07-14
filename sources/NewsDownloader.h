//
//  NewsDownloader.h
//  Rotato
//
//  Created by Hin Lam on 7/12/13.
//
//

#import <Foundation/Foundation.h>

@interface NewsDownloader : NSObject <NSXMLParserDelegate>

- (id) initWithURL:(NSString *)URL;
- (void) setNewsUnreadStatus:(BOOL)status;
- (BOOL) hasUnreadNews;

// The following array holds strings representing XML elements
// for news.
// Each array element is holding an NSString object
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSString *downloadLinkString;
@property (nonatomic, strong) NSString *pictureLinkString;

@end
