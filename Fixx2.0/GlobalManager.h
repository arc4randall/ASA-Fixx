//
//  GlobalManager.h
//  Fixx2.0
//
//  Created by Randall Spence on 4/23/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <foundation/Foundation.h>

@interface GlobalManager : NSObject {
    NSArray *incomeCategoryArray;
}

@property (strong,nonatomic) NSArray* incomeCategoryArray;
+ (id)sharedManager;

@end