//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import "ApplicationAssembly.h"
#import "AppDelegate.h"
#import "DinnerListViewController.h"


@implementation ApplicationAssembly {

}

- (AppDelegate *)appDelegate {
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition)
    {
        [definition injectProperty:@selector(window) with:[self mainWindow]];
    }];
}

- (UIWindow *)mainWindow {
    return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition)
    {
        [definition useInitializer:@selector(initWithFrame:) parameters:^(TyphoonMethod *initializer)
        {
            [initializer injectParameterWith:[NSValue valueWithCGRect:[[UIScreen mainScreen] bounds]]];
        }];
        [definition injectProperty:@selector(rootViewController) with:[self rootViewController]];
    }];
}

- (UINavigationController *)rootViewController {
    return [TyphoonDefinition withClass:[DinnerListViewController class] ];
}

@end