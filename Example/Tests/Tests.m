//
//  AWFileHashTests.m
//  AWFileHashTests
//
//  Created by Alexander Widerberg on 02/17/2015.
//  Copyright (c) 2014 Alexander Widerberg. All rights reserved.
//

#import <AWFileHash/AWFileHash.h>

SpecBegin(InitialSpecs)

describe(@"these should pass", ^{
    __block NSData* _data = nil;
    __block NSString* _filePath = nil;

    beforeAll(^{
        // Setup test NSData
         _data = [NSData dataWithBytes:"AWFileHash" length:10];

        // Fetch the test file path
        NSString *mainBundlePath = [[NSBundle bundleForClass:[self class]] resourcePath];
        NSBundle *mainBundle = [NSBundle bundleWithPath:mainBundlePath];
         _filePath = [mainBundle pathForResource:@"flower" ofType:@"png"];
    });

    beforeEach(^{
    });

    // NSData tests
    it(@"can calculate MD5 of nsdata", ^{
        expect([AWFileHash md5HashOfData:_data]).to.equal(@"f8b38b91e8972b2cffcf46723c755089");
    });
    
    it(@"can calculate SHA1 of nsdata", ^{
        expect([AWFileHash sha1HashOfData:_data]).to.equal(@"e100884df5826e4e2c36f784521f7b4c74809082");
    });

    it(@"can calculate SHA512 of nsdata", ^{
        expect([AWFileHash sha512HashOfData:_data]).to.equal(@"a83343a46aabc469e12483ec6f4a4620516b50ad2a810226270e7efa4851e8f69065a47b6c6eeee8ed9006361f79665cfa0e481ae69ef873b55653220b0a578a");
    });

    // File tests
    it(@"can calculate MD5 of nsdata", ^{
        expect([AWFileHash md5HashOfFileAtPath:_filePath]).to.equal(@"e2b73ef09ebf853047fe1dcb6ad0862a");
    });

    it(@"can calculate SHA1 of nsdata", ^{
        expect([AWFileHash sha1HashOfFileAtPath:_filePath]).to.equal(@"91f90cc1f585fb6ebe6980954a33e2da27257edf");
    });

    it(@"can calculate SHA512 of nsdata", ^{
        expect([AWFileHash sha512HashOfFileAtPath:_filePath]).to.equal(@"a428ad0b1ef9b09b2c7477cce93b0ccd052c70423810778f042dc003c1941129c54d4e82d11b76dad2dddd881cd6fda0063a57793ea95aafcb54a57721391a57");
    });

    afterEach(^{
    });

    afterAll(^{
        _data = nil;
        _filePath = nil;
    });

});

SpecEnd
