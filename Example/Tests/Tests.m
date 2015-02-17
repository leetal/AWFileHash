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
         _data = [NSData dataWithBytes:"AWFileHash" length:10];
        // [data md5] == f8b38b91e8972b2cffcf46723c755089
        // [data sha1] == e100884df5826e4e2c36f784521f7b4c74809082
        // [data sha512] == A83343A46AABC469E12483EC6F4A4620516B50AD2A810226270E7EFA4851E8F69065A47B6C6EEEE8ED9006361F79665CFA0E481AE69EF873B55653220B0A578A

        // Fetch the test file path
        NSString *mainBundlePath = [[NSBundle bundleForClass:[self class]] resourcePath];
        NSBundle *mainBundle = [NSBundle bundleWithPath:mainBundlePath];
        NSString *podBundlePath = [mainBundle pathForResource:@"AWFileHash" ofType:@"bundle"];
        NSBundle *podBundle = [NSBundle bundleWithPath:podBundlePath];
         _filePath = [podBundle pathForResource:@"flower" ofType:@"png"];

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
        expect([AWFileHash md5HashOfFileAtPath:_filePath]).to.equal(@"f8b38b91e8972b2cffcf46723c755089");
    });

    it(@"can calculate SHA1 of nsdata", ^{
        expect([AWFileHash sha1HashOfFileAtPath:_filePath]).to.equal(@"e100884df5826e4e2c36f784521f7b4c74809082");
    });

    it(@"can calculate SHA512 of nsdata", ^{
        expect([AWFileHash sha512HashOfFileAtPath:_filePath]).to.equal(@"a83343a46aabc469e12483ec6f4a4620516b50ad2a810226270e7efa4851e8f69065a47b6c6eeee8ed9006361f79665cfa0e481ae69ef873b55653220b0a578a");
    });
    
    /*it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"should do some stuff asynchronously", ^{
        waitUntil(^(DoneCallback done) {
            // Async example blocks need to invoke done() callback.
            done();
        });
    });*/

    afterEach(^{
    });

    afterAll(^{
        data = nil;
    });
});

SpecEnd
