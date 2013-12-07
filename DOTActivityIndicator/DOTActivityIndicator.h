//
//  DOActivityIndicator.h
//
//  Created by durian on 12/1/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, DOTActivityIndicatorOption) {
    DOTActivityIndicatorOptionColorSingle     = 0 << 0, // Only one highlight color
    DOTActivityIndicatorOptionColorMultiple   = 1 << 0, // Multiple highlight colors will be used repeatedlly.
    
    DOTActivityIndicatorOptionShapeCutomized  = 0 << 4, // To be implemented
    DOTActivityIndicatorOptionShapeDot        = 0 << 4, // Dot shape
    DOTActivityIndicatorOptionShapeArrow      = 1 << 4  // To be implemented
};

@interface DOTActivityIndicator : UIView {
    CGFloat _dotSize;
    CGFloat _dotSpacing;

    BOOL _isAnimating;
    
    NSArray *_dots;
}

+ (DOTActivityIndicator *)indicator;
+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size;
+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size spacing:(CGFloat)spacing;

@property (nonatomic) DOTActivityIndicatorOption option;
@property (nonatomic) UIColor *highlightedColor; // Color of highlighted dot for single color mode, default is black.
@property (nonatomic) NSArray *highlightedColors; // For multiple color mode. 
@property (nonatomic) UIColor *normalColor; // Color of normal dot, default is 80% white.
@property (nonatomic) NSTimeInterval animationDuration; 
@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
