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

#import "HexColor.h"

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
    if (self.highlightedColors == nil) {
        NSArray *colorStrings = @[@"F83F44", @"FF8900", @"FFC800", @"C6C800", @"3AB539", @"1FAB76", @"00A59F", @"0089B3", @"007FD2", @"876CD0", @"C15FB2", @"EB4D83"];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[colorStrings count]];
        [colorStrings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [array addObject:[UIColor colorWithHexString:obj]];
        }];
        self.highlightedColors = [NSArray arrayWithArray:array];
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
    
    DOTActivityIndicatorOption colorOption = _option & 0xF;
    NSArray *(^createOneRoundAnimationColorValues)(UIColor *highlightedColor, UIColor *normalColor, NSUInteger idx) =
    ^(UIColor *highlightedColor, UIColor *normalColor, NSUInteger idx) {
        NSArray *colors;
        // Six frames for animation.
        if (idx == 0) {
            colors = @[normalColor, highlightedColor, normalColor,      normalColor,      normalColor, normalColor];
        } else if (idx == 1) {
            colors = @[normalColor, normalColor,      highlightedColor, normalColor,      normalColor, normalColor];
        } else if (idx == 2) {
            colors = @[normalColor, normalColor,      normalColor,      highlightedColor, normalColor, normalColor];
        }
        return colors;
    };
    
    NSArray *highlightedColors;
    NSArray *colorValues;
    NSTimeInterval duration;
    
    if (colorOption == DOTActivityIndicatorOptionColorSingle) {
        highlightedColors = @[_highlightedColor];
    } else if (colorOption == DOTActivityIndicatorOptionColorMultiple) {
        highlightedColors = _highlightedColors;
    }
    NSMutableArray *values = [NSMutableArray arrayWithObjects:[NSMutableArray array], [NSMutableArray array], [NSMutableArray array], nil];
    [highlightedColors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
        id highlightedColor = (id)color.CGColor;
        id normalColor = (id)_normalColor.CGColor;
        [values[0] addObjectsFromArray:createOneRoundAnimationColorValues(highlightedColor, normalColor, 0)];
        [values[1] addObjectsFromArray:createOneRoundAnimationColorValues(highlightedColor, normalColor, 1)];
        [values[2] addObjectsFromArray:createOneRoundAnimationColorValues(highlightedColor, normalColor, 2)];
    }];
    
    colorValues = [NSArray arrayWithArray:values];
    duration = [highlightedColors count] * (_animationDuration != 0 ? _animationDuration : DEFAULT_ANIMATION_DURATION);
    
    [_dots enumerateObjectsUsingBlock:^(UIView *dot, NSUInteger idx, BOOL *stop) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
        animation.values = colorValues[idx];
        animation.repeatCount = INFINITY;
        animation.duration = duration;
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
