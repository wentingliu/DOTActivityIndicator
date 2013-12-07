//
//  ViewController.m
//  Sample
//
//  Created by durian on 12/2/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import "ViewController.h"

#import "DOTActivityIndicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    DOTActivityIndicator *indicator = [DOTActivityIndicator indicatorWithDotSize:20];
    indicator.option = DOTActivityIndicatorOptionColorMultiple;
//    indicator.highlightedColor = [UIColor colorWithRed:0.13 green:0.32 blue:0.88 alpha:1];
    [self.view addSubview:indicator];
    CGSize size = self.view.bounds.size;
    indicator.center = CGPointMake(size.width / 2, size.height / 2);
    
    [indicator startAnimating];
}


@end
