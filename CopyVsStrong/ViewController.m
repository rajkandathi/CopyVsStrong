//
//  ViewController.m
//  CopyVsStrong
//
//  Created by Raj Kandathi on 6/27/15.
//  Copyright © 2015 Raj Kandathi. All rights reserved.
//

#import "ViewController.h"

extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));
static size_t const iterations = 10000;
typedef void (^SimpleOperation)(void);

//Code block that calculates the time taken to run a simple operation
void (^calculateSimpleOperationTime) (NSString*, SimpleOperation) = ^(NSString* operationName, SimpleOperation operation) {
    
    uint64_t t = dispatch_benchmark(iterations, ^{
        operation();
    });
    NSLog(@"%@ = %llu ns", operationName, t);
};

@interface ViewController ()

@property(strong, nonatomic) NSMutableArray* hugeArray;
@property(copy, nonatomic) NSArray* arrayUsingCopyAttribute;
@property(strong, nonatomic) NSArray* arrayUsingStrongAttribute;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize the huge array
    for (long i = 0; i < 1000000000; i++)
        self.hugeArray[i] = @"TEST";
    
    //copy the huge array
    SimpleOperation copyOperation = ^{ self.arrayUsingCopyAttribute = self.hugeArray;};
    calculateSimpleOperationTime(@"Copy", copyOperation);
    
    //retain the huge array
    SimpleOperation nonCopyOperation = ^{ self.arrayUsingStrongAttribute = self.hugeArray;};
    calculateSimpleOperationTime(@"Strong", nonCopyOperation);
}

@end
