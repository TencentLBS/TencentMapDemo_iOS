//
//  LocalTile.m
//  QMapKitDemo
//
//  Created by Keith Cao on 2019/7/15.
//  Copyright © 2019 tencent. All rights reserved.
//

#import "LocalTile.h"

@implementation LocalTile

- (void)loadTileAtPath:(QTileOverlayPath)path result:(void (^)(NSData *, NSError *))result
{
    NSString *imagePath = [NSString stringWithFormat:@"%d-%d-%d.png", (int)path.z, (int)path.x, (int)path.y];
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"localTiles"];
    
    NSData *data = [NSData dataWithContentsOfFile:[filePath stringByAppendingPathComponent:imagePath]];
    
    if (data.length != 0)
    {
        result(data,nil);
    }
    else
    {
       NSError *error = [NSError errorWithDomain:@"QTileLoadErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"load tile data error"}];
        result(nil, error);
    }
        
    
}

@end
