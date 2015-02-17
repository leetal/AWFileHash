//
//  AWFileHash.h
//  Pods
//
//  Created by Alexander Widerberg on 2015-02-17.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#import <Photos/Photos.h>
#endif

@interface FileHash : NSObject

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)md5HashOfData:(NSData *)data;
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)md5HashOfALAssetRepresentation:(ALAssetRepresentation *)alAssetRep;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
+ (NSString *)md5HashOfPHAsset:(PHAsset *)phAsset;
#endif

@end
