//
//  DOActivityIndicator.h
//
//  Created by durian on 12/1/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOTActivityIndicator : UIView {
    CGFloat _dotSize;
    CGFloat _dotSpacing;

    BOOL _isAnimating;
    
    NSArray *_dots;
}

+ (DOTActivityIndicator *)indicator;
+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size;
+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size spacing:(CGFloat)spacing;

@property (nonatomic) UIColor *highlightedColor; // Color of highlighted dot, default is black.
@property (nonatomic) UIColor *normalColor; // Color of normal dot, default is 80% white.
@property (nonatomic) NSTimeInterval animationDuration; 
@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
