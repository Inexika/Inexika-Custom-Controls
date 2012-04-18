//Created by Leonty Deriglazov & Vadim Yelagin
//Copyright (C) 2012 Inexika, http://www.inexika.com
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this 
//software and associated documentation files (the "Software"), to deal in the Software 
//without restriction, including without limitation the rights to use, copy, modify, merge, 
//publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
//to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or
//substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
//FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
//OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//DEALINGS IN THE SOFTWARE.

#import "IXPickerOverlayView.h"
#import <QuartzCore/QuartzCore.h>

@interface IXPickerOverlayView ()
@property (strong, nonatomic) CAShapeLayer* textureLayer;
@end

@implementation IXPickerOverlayView
@synthesize hostPickerView, textureLayer;

- (UIImage*)imageForLeftPane {
    return [UIImage imageNamed:@"ixPickerOverlayLeftPane"];
}
- (UIImage*)imageForRightPane {
    return [UIImage imageNamed:@"ixPickerOverlayRightPane"];
}
- (UIImage*)imageForSectionWheel {
    return [UIImage imageNamed:@"ixPickerOverlaySectionWheel"];
}
- (UIImage*)imageForSectionsSeparator {
    return [UIImage imageNamed:@"ixPickerOverlaySectionsSeparator"];
}
- (UIImage*)imageForTexture {
    return [UIImage imageNamed:@"ixPickerOverlayTexture"];    
}
- (UIImage*)imageForGlass {
    return [UIImage imageNamed:@"ixPickerOverlayGlass"];    
}

+ (UIPickerView*)findPickerInView:(UIView*)view {
    if ([view isKindOfClass:[UIPickerView class]])
        return (UIPickerView*)view;
    for (UIView* subview in view.subviews) {
        UIPickerView* picker = [self findPickerInView:subview];
        if (picker != nil)
            return picker;
    }
    return nil;
}

- (CAShapeLayer*)textureLayer {
    if (textureLayer == nil) {
        textureLayer = [[CAShapeLayer alloc] init];
        textureLayer.fillRule = kCAFillRuleEvenOdd;
        textureLayer.fillColor = [UIColor colorWithPatternImage:[self imageForTexture]].CGColor;
        textureLayer.transform = CATransform3DMakeScale(1, -1, 1);
        [self.layer addSublayer:textureLayer];
    }
    return textureLayer;
}

- (void)setHostPickerView:(UIView*)view {
    hostPickerView = view;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([view isKindOfClass:[UIDatePicker class]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsLayout) name:NSCurrentLocaleDidChangeNotification object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }
    UIPickerView* picker = [[self class] findPickerInView:self.hostPickerView];
    NSInteger n = picker.numberOfComponents;
    if (n < 1)
        return;
    picker.showsSelectionIndicator = NO;
    
    const CGFloat separatorWidth = 8.0f;
    const CGFloat sectionExceedWidth = -2.0f;
    CGFloat totalWidth = picker.bounds.size.width;
    CGFloat panesWidth = totalWidth - separatorWidth * (n - 1);
    for (NSInteger i = 0; i < n; i++) {
        CGFloat sectionWidth = [picker rowSizeForComponent:i].width + sectionExceedWidth;
        panesWidth -= sectionWidth;
    }
    CGFloat leftPaneWidth = ceilf(panesWidth * 0.5f);
    CGFloat rightPaneWidth = panesWidth - leftPaneWidth;
    CGFloat totalHeight = picker.bounds.size.height;
    CGRect totalRect = CGRectMake(0, 0, totalWidth, totalHeight);
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:totalRect];
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0f, leftPaneWidth, 10.0f, rightPaneWidth);
    [path appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(totalRect, insets)]];
    [path applyTransform:CGAffineTransformMakeScale(1, -1)];
    self.textureLayer.path = path.CGPath;
    
    UIImageView* leftPane = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leftPaneWidth, totalHeight)];
    leftPane.image = [self imageForLeftPane];
    leftPane.contentStretch = CGRectMake(0, 0, 0, 1);
    [self addSubview:leftPane];
    
    UIImageView* rightPane = [[UIImageView alloc] initWithFrame:CGRectMake(totalWidth - rightPaneWidth, 0, rightPaneWidth, totalHeight)];
    rightPane.image = [self imageForRightPane];
    rightPane.contentStretch = CGRectMake(1, 0, 0, 1);
    [self addSubview:rightPane];
    
    CGFloat x = leftPaneWidth;
    for (NSInteger i = 0;; i++) {
        CGFloat sectionWidth = [picker rowSizeForComponent:i].width + sectionExceedWidth;
        
        UIImageView* sectionWheel = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, sectionWidth, totalHeight)];
        sectionWheel.image = [self imageForSectionWheel];
        sectionWheel.contentStretch = CGRectMake(0, 0.25f, 1, 0.5f);
        [self addSubview:sectionWheel];
        x += sectionWidth;
        
        if (i == n - 1)
            break;
        
        UIImageView* sectionsSeparator = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, separatorWidth, totalHeight)];
        sectionsSeparator.image = [self imageForSectionsSeparator];
        sectionsSeparator.contentStretch = CGRectMake(0, 0.25f, 1, 0.5f);
        [self addSubview:sectionsSeparator];
        x += separatorWidth;
    }
    
    UIImage* glassImage = [self imageForGlass];
    if (glassImage != nil) {
        CGFloat glassHeight = glassImage.size.height;
        CGFloat glassY = round(0.5f * (totalHeight - glassHeight));
        const CGFloat glassExceed = 6.0f;
        CGRect glassFrame = CGRectMake(leftPaneWidth - glassExceed, glassY, totalWidth - panesWidth + 2*glassExceed, glassHeight);
        UIImageView* glass = [[UIImageView alloc] initWithFrame:glassFrame];
        glass.image = glassImage;
        glass.contentStretch = CGRectMake(0.5f, 0, 0, 1);
        [self addSubview:glass];
    }
}

@end
