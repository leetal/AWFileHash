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
    __block NSData* data = nil;
    __block NSString* filePath = nil;

    beforeAll(^{
         data = [NSData dataWithBytes:"AWFileHash" length:10];
        // [data md5] == f8b38b91e8972b2cffcf46723c755089
        // [data sha1] == e100884df5826e4e2c36f784521f7b4c74809082
        // [data sha256] == B04C65C0B3F6BACA7F69A59A6450D1C2BEEC77CF5AB1983A3BFC236538273120
        // [data sha512] == A83343A46AABC469E12483EC6F4A4620516B50AD2A810226270E7EFA4851E8F69065A47B6C6EEEE8ED9006361F79665CFA0E481AE69EF873B55653220B0A578A
         filePath = [[NSBundle mainBundle] pathForResource:@"your_file_name"
                                                             ofType:@"the_file_extension"];
    });

    beforeEach(^{
    });

    it(@"can calculate MD5 of nsdata", ^{
        expect([AWFileHash md5HashOfData:data]).to.equal(@"f8b38b91e8972b2cffcf46723c755089");
    });
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"should do some stuff asynchronously", ^{
        waitUntil(^(DoneCallback done) {
            // Async example blocks need to invoke done() callback.
            done();
        });
    });

    afterEach(^{
    });

    afterAll(^{
        data = nil;
    });
});

SpecEnd
