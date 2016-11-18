//
//  TRUColorPopUpButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUColorPopUpButton.h"

#import "TRUDocument.h"

@implementation TRUColorPopUpButton

- (NSTreeController *)treeController
{
    return self.document.colorTreeController;
}

@end
