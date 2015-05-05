//
//  GlobalManager.m
//  Fixx2.0
//
//  Created by Randall Spence on 4/23/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "GlobalManager.h"

@implementation GlobalManager

@synthesize incomeCategoryArray;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static GlobalManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.incomeCategoryArray = @[@"Jobs & Work-Study",@"Internships",@"Scholarships & Grants",@"Loans",@"Parents & Family",@"Savings",@"Other"];
        self.expenseCategoryArray = @[@"Groceries",@"Transportation",@"Utilities",@"Health & Beauty",@"Housing",@"School",@"Phone & Technology",@"Eating Out",@"Entertainment",@"Savings",@"Other"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end