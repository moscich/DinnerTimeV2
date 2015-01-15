//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ApplicationAssembly.h"
#import "AppDelegate.h"
#import "DinnerListViewController.h"

@interface AppDelegateTests : XCTestCase

@end

@implementation AppDelegateTests {

}

- (void)test_appLaunch_HasWindowWithDinnerListControllerAsRootViewControllerInstantiated {
  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
  AppDelegate *appDelegate = [factory componentForType:[AppDelegate class]];

  [appDelegate.window.rootViewController isKindOfClass:[DinnerListViewController class]];

  XCTAssertNotNil(appDelegate.window);
  XCTAssertNotNil(appDelegate.window.rootViewController);
  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[DinnerListViewController class]]);
}

@end