//
//  DOActivityIndicator.m
//
//  Created by durian on 12/1/13.
//  Copyright (c) 2013 durian. All rights reserved.
//

static CGFloat const kDefaultDotSize = 10;
#define DEFAULT_DOT_SPACING(dotSize) (dotSize * 0.6)
#define DEFAULT_ANIMATION_DURATION (1 + (_dotSize - kDefaultDotSize) / _dotSize * 0.35)

#import "DOTActivityIndicator.h"

@implementation DOTActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dotSize = kDefaultDotSize;
        _dotSpacing = DEFAULT_DOT_SPACING(_dotSize);
        
        [self commonInit];
    }
    return self;
}

- (id)initWithDotSize:(CGFloat)size spacing:(CGFloat)spacing {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dotSize = size;
        _dotSpacing = spacing;
        
        [self commonInit];
    }
    return self;
}

+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size spacing:(CGFloat)spacing {
    return [[self alloc] initWithDotSize:size spacing:spacing];
}

+ (DOTActivityIndicator *)indicatorWithDotSize:(CGFloat)size {
    return [[self alloc] initWithDotSize:size spacing:DEFAULT_DOT_SPACING(size)];
}

+ (DOTActivityIndicator *)indicator {
    return [[self alloc] initWithDotSize:kDefaultDotSize spacing:DEFAULT_DOT_SPACING(kDefaultDotSize)];
}

- (void)awakeFromNib {
    if (_dotSize == 0) {
        _dotSize = kDefaultDotSize;
    }
    if (_dotSpacing == 0) {
        _dotSpacing = DEFAULT_DOT_SPACING(_dotSize);
    }
    
    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    if (self.highlightedColor == nil) {
        self.highlightedColor = [UIColor blackColor];
    }
    if (self.normalColor == nil) {
        self.normalColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    _isAnimating = NO;
    
    NSUInteger dotsCount = 3;
    
    CGSize size = CGSizeMake(_dotSize * dotsCount + _dotSpacing * (dotsCount + 1), _dotSize);
    
    // Adjust self frame.
    CGRect frame = self.frame;
    CGPoint center = self.center;
    frame.size = size;
    self.frame = frame;
    self.center = center;

    // The block which create a dot.
    UIView *(^newDot)() = ^() {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _dotSize, _dotSize)];
        dot.layer.cornerRadius = _dotSize / 2;
        dot.backgroundColor = self.normalColor;
        
        return dot;
    };
    
    // Create 3 dots
    NSMutableArray *dots = [NSMutableArray arrayWithCapacity:dotsCount];
    for (int i = 0; i < dotsCount; i++) {
        UIView *dot = newDot();
        [self addSubview:dot];
        [dots addObject:dot];
    }
    
    // And layout
    [dots enumerateObjectsUsingBlock:^(UIView *dot, NSUInteger idx, BOOL *stop) {
        CGPoint center = CGPointMake((idx + 1) * _dotSpacing + (idx + 0.5) * _dotSize, self.frame.size.height / 2);
        dot.center = center;
    }];
    
    _dots = [NSArray arrayWithArray:dots];
}

- (void)startAnimating {
    _isAnimating = YES;
    
    id highlightedColor = (id)_highlightedColor.CGColor;
    id normalColor = (id)_normalColor.CGColor;
    
    // Six frames for animation.
    NSArray *colorValues =
        @[@[highlightedColor, normalColor,      normalColor,      normalColor, normalColor, highlightedColor],
          @[normalColor,      highlightedColor, normalColor,      normalColor, normalColor, normalColor],
          @[normalColor,      normalColor,      highlightedColor, normalColor, normalColor, normalColor]];
    [_dots enumerateObjectsUsingBlock:^(UIView *dot, NSUInteger idx, BOOL *stop) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
        animation.values = colorValues[idx];
        animation.repeatCount = INFINITY;
        animation.duration = _animationDuration != 0 ? _animationDuration : DEFAULT_ANIMATION_DURATION;
        [dot.layer addAnimation:animation forKey:@"color"];
    }];
}

- (void)stopAnimating {
    [_dots enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[obj layer] removeAnimationForKey:@"color"];
    }];
    _isAnimating = NO;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

@end
