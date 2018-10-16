//
//  AIRGoogleMapURLTile.m
//  Created by Nick Italiano on 11/5/16.
//

#import "AIRGoogleMapUrlTile.h"

@implementation AIRGoogleMapUrlTile

- (void)setZIndex:(int)zIndex
{
  _zIndex = zIndex;
  _tileLayer.zIndex = zIndex;
}

- (void)setUrlTemplate:(NSString *)urlTemplate
{

  NSError *error=nil;
  NSDictionary *parsedUrlTemplate = [NSJSONSerialization JSONObjectWithData:[urlTemplate dataUsingEncoding:nil] options:kNilOptions error:&error];

  NSNumber *tileSize = [parsedUrlTemplate objectForKey:@"tileSize"];
    
  _urlTemplate = [parsedUrlTemplate objectForKey:@"urlTemplate"];
  _tileLayer = [GMSURLTileLayer tileLayerWithURLConstructor:[self _getTileURLConstructor]];
  _tileLayer.tileSize = [[UIScreen mainScreen] scale] * [tileSize intValue];
}

- (GMSTileURLConstructor)_getTileURLConstructor
{
  NSString *urlTemplate = self.urlTemplate;
  GMSTileURLConstructor urls = ^(NSUInteger x, NSUInteger y, NSUInteger zoom) {
    NSString *url = urlTemplate;
    url = [url stringByReplacingOccurrencesOfString:@"{x}" withString:[NSString stringWithFormat: @"%ld", (long)x]];
    url = [url stringByReplacingOccurrencesOfString:@"{y}" withString:[NSString stringWithFormat: @"%ld", (long)y]];
    url = [url stringByReplacingOccurrencesOfString:@"{z}" withString:[NSString stringWithFormat: @"%ld", (long)zoom]];
    return [NSURL URLWithString:url];
  };
  return urls;
}
@end
