//
//  DinnerListViewControllerTests.m
//  DinnerTimeV2
//
//  Created by Marek Moscichowski on 15.01.15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ApplicationAssembly.h"
#import "DinnerListViewController.h"
#import "OCMockObject.h"
#import "AFHTTPSessionManager.h"
#import "OCMStubRecorder.h"
#import "OCMArg.h"
#import "AFHTTPRequestOperation.h"

@interface DinnerListViewControllerTests : XCTestCase

@end

@implementation DinnerListViewControllerTests

- (void)test_viewDidLoad_DisplaysFetchedDinnersOnTheTableView {
    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
    DinnerListViewController *dinnerListViewController = [factory componentForType:[DinnerListViewController class]];
    id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];
    dinnerListViewController.sessionManager = mockSessionManager;
    [[[mockSessionManager stub] andDo:^(NSInvocation *invocation) {
      void (^passedBlock)(AFHTTPRequestOperation *operation, id responseObject);
      [invocation getArgument:&passedBlock atIndex:4];
      passedBlock(nil, [self getStubDinnersJSON]);
    }] GET:@"http://localhost:3001/dinners" parameters:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];

    [dinnerListViewController view];

    UITableViewCell *cell1 = [((id <UITableViewDataSource>)dinnerListViewController) tableView:dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    UITableViewCell *cell2 = [((id <UITableViewDataSource>)dinnerListViewController) tableView:dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

    XCTAssertEqualObjects(cell1.textLabel.text, @"First Test Dinner");
    XCTAssertEqualObjects(cell2.textLabel.text, @"Second Test Dinner");
}

- (NSData *)getStubDinnersJSON{
    NSString *resultsString = @"{  "
              "   \"dinners\":[  "
              "      {  "
              "         \"title\":\"First Test Dinner\","
              "      },"
              "      {  "
              "         \"title\":\"Second Test Dinner\","
              "      }]"
            "}";
    NSData *objectData = [resultsString dataUsingEncoding:NSUTF8StringEncoding];

    return objectData;
}

@end
