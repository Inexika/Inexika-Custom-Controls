//
//  ColorPickerControllerViewController.m
//  PickerOverlaySample
//
//  Created by Aleksandr Nikiforov on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerControllerViewController.h"



@interface ColorPickerControllerViewController ()

@end

@implementation ColorPickerControllerViewController
@synthesize slider;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    slider.insetGradient = CGSizeMake(2, 8);
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
