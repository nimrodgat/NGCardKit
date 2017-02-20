//
//  CKSAppDelegate.m
//  CardsKitSample
//
//  Created by Nim Gat on 12/26/16.
//  Copyright © 2016 Nim Gat. All rights reserved.
//

#import "CKSAppDelegate.h"
#import "CKSViewController.h"

@interface CKSAppDelegate ()

@end

@implementation CKSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CKSViewController alloc] init]];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
