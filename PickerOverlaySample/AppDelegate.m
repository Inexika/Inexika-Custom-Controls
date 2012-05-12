//
//  AppDelegate.m
//  PickerOverlaySample
//
//  Created by Leonty Deriglazov on 17.04.12.
//  Copyright (c) 2012 Inexika, http://www.inexika.com All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"CustomControllsTableView" bundle:nil];
    self.viewController = [sb instantiateViewControllerWithIdentifier:@"CustomControllers"];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
