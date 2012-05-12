//
//  ActionSheetController.m
//  PickerOverlaySample
//
//  Created by Aleksandr Nikiforov on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionSheetController.h"
#import "IXActionSheetController.h"
 
@interface ActionSheetController ()
@end

@implementation ActionSheetController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showActionSheet:nil];
}

- (IBAction)showActionSheet:(id)sender {
    IXActionSheetController *asc = [[IXActionSheetController alloc] init];
    [asc addButtonWithTitle:@"Share on Facebook" andAction:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared on Facebook" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
    
    [asc setCancelButtonTitle:@"Cancel" andAction:nil];
    
    [asc setDestructiveButtonTitle:@"rm -rf /" andAction:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:nil delegate:nil cancelButtonTitle:@"Gosh!" otherButtonTitles:nil];
        [alert show];
    }];
    
    [asc.actionSheet showInView:self.view];
}

@end
