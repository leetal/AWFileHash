//
//  AWFileHash.m
//  Pods
//
//  Created by Alexander Widerberg on 2015-02-17.
//
//

// Header file
#import "AWFileHash.h"

// System framework and libraries
#include <CommonCrypto/CommonDigest.h>
#include <CoreFoundation/CoreFoundation.h>
#include <stdint.h>
#include <stdio.h>


// Constants
static const size_t FileHashDefaultChunkSizeForReadingData = 256000; // 250kB buffer size

// Function pointer types for functions used in the computation
// of a cryptographic hash.
typedef int (*FileHashInitFunction)   (uint8_t *hashObjectPointer[]);
typedef int (*FileHashUpdateFunction) (uint8_t *hashObjectPointer[], const void *data, CC_LONG len);
typedef int (*FileHashFinalFunction)  (unsigned char *md, uint8_t *hashObjectPointer[]);

// Structure used to describe a hash computation context.
typedef struct _FileHashComputationContext {
    FileHashInitFunction initFunction;
    FileHashUpdateFunction updateFunction;
    FileHashFinalFunction finalFunction;
    size_t digestLength;
    uint8_t **hashObjectPointer;
} FileHashComputationContext;

#define MAX_READ_STREAM_STATUS_POLLING_ATTEMPTS 10

#define FileHashComputationContextInitialize(context, hashAlgorithmName)                    \
CC_##hashAlgorithmName##_CTX hashObjectFor##hashAlgorithmName;                          \
context.initFunction      = (FileHashInitFunction)&CC_##hashAlgorithmName##_Init;       \
context.updateFunction    = (FileHashUpdateFunction)&CC_##hashAlgorithmName##_Update;   \
context.finalFunction     = (FileHashFinalFunction)&CC_##hashAlgorithmName##_Final;     \
context.digestLength      = CC_##hashAlgorithmName##_DIGEST_LENGTH;                     \
context.hashObjectPointer = (uint8_t **)&hashObjectFor##hashAlgorithmName


@implementation FileHash

+ (NSString *)hashOfFileAtPath:(NSString *)filePath withComputationContext:(FileHashComputationContext *)context {
    NSString *result = nil;
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, (Boolean)false);
    CFReadStreamRef readStream = fileURL ? CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL) : NULL;

    BOOL didSucceed = readStream ? (BOOL)CFReadStreamOpen(readStream) : NO;

    // Race condition while running om multiple threads patched with big thanks to Aaron Morse
    if (!didSucceed) {
        if (readStream) CFRelease(readStream);
        if (fileURL) CFRelease(fileURL);
        return nil;
    }
    CFStreamStatus myStreamStatus;
    NSUInteger attempts = 0;
    do {
        sleep(1);
        myStreamStatus = CFReadStreamGetStatus(readStream);
        if (attempts++ > MAX_READ_STREAM_STATUS_POLLING_ATTEMPTS) {
            if (readStream) CFRelease(readStream);
            if (fileURL) CFRelease(fileURL);
            return nil;
        }
    } while ((myStreamStatus != kCFStreamStatusOpen) && (myStreamStatus != kCFStreamStatusError));

    if (myStreamStatus == kCFStreamStatusError) {
        if (readStream) CFRelease(readStream);
        if (fileURL) CFRelease(fileURL);
        return nil;
    }
    // End race condition check

    // Use default value for the chunk size for reading data.
    const size_t chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;

    // Initialize the hash object
    (*context->initFunction)(context->hashObjectPointer);

    // Feed the data to the hash object.
    BOOL hasMoreData = YES;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8 *)buffer, (CFIndex)sizeof(buffer));

        if (readBytesCount == -1) {
            break;
        } else if (readBytesCount == 0) {
            hasMoreData = NO;
        } else {
            (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
        }
    }

    // Compute the hash digest
    unsigned char digest[context->digestLength];
    (*context->finalFunction)(digest, context->hashObjectPointer);

    // Close the read stream.
    CFReadStreamClose(readStream);

    // Proceed if the read operation succeeded.
    didSucceed = !hasMoreData;
    if (didSucceed) {
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = [NSString stringWithUTF8String:hash];
    }

    if (readStream) CFRelease(readStream);
    if (fileURL)    CFRelease(fileURL);
    return result;
}

+ (NSString *)hashOfALAssetRepresentation:(ALAssetRepresentation *)assetRepresentation withComputationContext:(FileHashComputationContext *)context {

    NSString *result = nil;
    BOOL didSucceed = NO;

    // Use default value for the chunk size for reading data.
    const size_t chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;

    // Initialize the hash object
    (*context->initFunction)(context->hashObjectPointer);

    // Feed the data to the hash object.
    BOOL hasMoreData = YES;
    CFIndex readBytesCount = 0;
    CFIndex totalOffset = 0;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];

        NSError* err = nil;
        readBytesCount = [assetRepresentation getBytes:buffer fromOffset:totalOffset length:sizeof(buffer) error:&err];
        totalOffset = totalOffset + readBytesCount;

        if (readBytesCount == -1) {
            break;
        } else if (readBytesCount == 0) {
            hasMoreData = NO;
        } else {
            (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
        }
    }

    // Compute the hash digest
    unsigned char digest[context->digestLength];
    (*context->finalFunction)(digest, context->hashObjectPointer);


    // Proceed if the read operation succeeded.
    didSucceed = !hasMoreData;
    if (didSucceed) {
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = [NSString stringWithUTF8String:hash];
    }

    return result;
}

+ (NSString *)hashOfNSData:(NSData *)data withComputationContext:(FileHashComputationContext *)context {

    NSString *result = nil;
    BOOL didSucceed = NO;

    // Use default value for the chunk size for reading data.
    size_t chunkSizeForReadingData = 0;
    if(FileHashDefaultChunkSizeForReadingData > data.length) {
        chunkSizeForReadingData = data.length;
    } else {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }

    // Initialize the hash object
    (*context->initFunction)(context->hashObjectPointer);

    // Feed the data to the hash object.
    BOOL hasMoreData = YES;
    CFIndex readBytesCount = 0;
    CFIndex totalOffset = 0;
    NSRange range;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];

        readBytesCount = sizeof(buffer);
        // Make sure that we read the correct amount of data
        if(totalOffset+readBytesCount > data.length && !(totalOffset == data.length)) {
            readBytesCount = (data.length-totalOffset);
        } else if(totalOffset == data.length) {
            readBytesCount = 0;
        } else if(totalOffset > data.length) {
            // This should not happen at any time (added for precaution)
            break;
        }

        range = NSMakeRange(totalOffset, readBytesCount);

        @try {
            [data getBytes:buffer range:range];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception.debugDescription);
            break;
        }

        totalOffset = totalOffset + readBytesCount;

        if (readBytesCount == -1) {
        } else if (readBytesCount == 0) {
            hasMoreData = NO;
        } else {
            (*context->updateFunction)(context->hashObjectPointer, (const void *)buffer, (CC_LONG)readBytesCount);
        }
    }

    // Compute the hash digest
    unsigned char digest[context->digestLength];
    (*context->finalFunction)(digest, context->hashObjectPointer);

    // Proceed if the read operation succeeded.
    didSucceed = !hasMoreData;
    if (didSucceed) {
        char hash[2 * sizeof(digest) + 1];
        for (size_t i = 0; i < sizeof(digest); ++i) {
            snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        }
        result = [NSString stringWithUTF8String:hash];
    }

    return result;
}

+ (NSString *)md5HashOfData:(NSData *)data {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, MD5);
    return [self hashOfNSData:data withComputationContext:&context];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
// This will have a much larger memory impact than ALAsset
+ (NSString *)md5HashOfPHAsset:(PHAsset *)phAsset {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, MD5);

    if(phAsset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeNone;   // No resize
        options.networkAccessAllowed = YES;                         // Allow network access
        options.version = PHImageRequestOptionsVersionCurrent;      // Latest edit
        // Is Image
        [[PHImageManager defaultManager] requestImageDataForAsset:phAsset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {

        }];
    } else if(phAsset.mediaType == PHAssetMediaTypeVideo) {
        // Is Video

    }

    //return [self hashOfALAssetRepresentation:alAssetRep withComputationContext:&context];
    return nil;
}
#endif

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, MD5);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSString *)md5HashOfALAssetRepresentation:(ALAssetRepresentation *)alAssetRep {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, MD5);
    return [self hashOfALAssetRepresentation:alAssetRep withComputationContext:&context];
}

+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA1);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath {
    FileHashComputationContext context;
    FileHashComputationContextInitialize(context, SHA512);
    return [self hashOfFileAtPath:filePath withComputationContext:&context];
}

@end
