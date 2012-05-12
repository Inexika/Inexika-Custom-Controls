//
//  BrightnessSliderView.m
//  PickerOverlaySample
//
//  Created by Aleksandr Nikiforov on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrightnessSliderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BrightnessSliderView{
    UIView* back;
    UIImageView* slider;
    UIButton* brightnessButton;
    CAGradientLayer *layer;
}
@synthesize colorCircle;
@synthesize insetGradient = _insetGradient;

- (void)doInit {
    self.backgroundColor = [UIColor clearColor];
    _insetGradient.width = 0;
    _insetGradient.height = 0;
    
    
    UIImage *sliderImage = [UIImage imageNamed:@"brightnessSlider"];
    slider = [[UIImageView alloc]initWithImage:sliderImage];
    layer = [[CAGradientLayer alloc]init];
    layer.frame = self.bounds;
    layer.colors = [NSArray arrayWithObjects:
                    (id)[UIColor clearColor].CGColor,
                    (id)[UIColor blackColor].CGColor,
                    nil];

    back = [[UIView alloc]initWithFrame:layer.frame];
    back.backgroundColor = [UIColor whiteColor];
    [self addSubview:back];
    [self.layer addSublayer:layer];
    [self addSubview:slider];


    brightnessButton = [[UIButton alloc]initWithFrame:self.bounds];
    [brightnessButton addTarget:self action:@selector(changeBrightness:forEvent:) forControlEvents:UIControlEventTouchDown];
    [brightnessButton addTarget:self action:@selector(changeBrightness:forEvent:) forControlEvents:UIControlEventTouchDragInside];
    [brightnessButton addTarget:self action:@selector(changeBrightness:forEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self addSubview:brightnessButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

-(void)colorPickerDidChangeSelection:(IXColorPickerView*)colorPicker {
    CGPoint center = slider.center;
    center.y = back.bounds.origin.y + (1 - colorPicker.brightness) * back.bounds.size.height+_insetGradient.height;
    slider.center = center;
    back.backgroundColor = [colorPicker colorAtPoint:colorPicker.selectedPoint withBrightness:1];
    
}
- (IBAction)changeBrightness:(UIView*)sender forEvent:(UIEvent*)event {
    UITouch* touch = [event touchesForView:sender].anyObject;
    CGPoint loc = [touch locationInView:back];
    CGFloat brightness = 1 - (loc.y / back.bounds.size.height);
    brightness = MIN(brightness, 1);
    brightness = MAX(brightness, 0);
    [self.colorCircle setBrightness:brightness];
}
- (void)setInsetGradient:(CGSize)insetGradient {
    
    _insetGradient = insetGradient;
    CGRect rect = CGRectMake(self.bounds.origin.x+_insetGradient.width, self.bounds.origin.y+_insetGradient.height, self.bounds.size.width-2*_insetGradient.width,self.bounds.size.height-2*_insetGradient.height);
    layer.frame = rect;
    back.frame = rect;
}

@end
