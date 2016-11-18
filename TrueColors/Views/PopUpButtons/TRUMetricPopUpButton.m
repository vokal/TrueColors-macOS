//
//  TRUMetricPopUpButton.m
//  TrueColors
//
//  Created by Isaac Greenspan on 6/17/15.
//  Copyright (c) 2015 Vokal. All rights reserved.
//

#import "TRUMetricPopUpButton.h"

#import "TRUDocument.h"

@implementation TRUMetricPopUpButton

- (NSTreeController *)treeController
{
    return self.document.metricTreeController;
}

@end
