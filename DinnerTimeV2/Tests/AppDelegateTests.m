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

- (void)test_appLaunch_WindowHasNavigationControllerAsRootWithDinnerListViewController{
  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
  AppDelegate *appDelegate = [factory componentForType:[AppDelegate class]];

  XCTAssertNotNil(appDelegate.window);
  XCTAssertNotNil(appDelegate.window.rootViewController);
  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]);
  XCTAssertEqual(((UINavigationController *)appDelegate.window.rootViewController).viewControllers.count,1);
  XCTAssertTrue([((UINavigationController *)appDelegate.window.rootViewController).viewControllers[0] isKindOfClass:[DinnerListViewController class]]);
}

@end