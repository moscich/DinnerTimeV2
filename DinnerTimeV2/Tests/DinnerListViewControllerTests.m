//
//  DinnerListViewControllerTests.m
//  DinnerTimeV2
//
//  Created by Marek Moscichowski on 15.01.15.
//  Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "ApplicationAssembly.h"
#import "DinnerListViewController.h"
#import "OCMockObject.h"
#import "AFHTTPSessionManager.h"
#import "OCMStubRecorder.h"
#import "OCMArg.h"
#import "AFHTTPRequestOperation.h"
#import "AddDinnerViewController.h"

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

  int numberOfRows = [dinnerListViewController.tableView.dataSource tableView:dinnerListViewController.tableView numberOfRowsInSection:0];
  UITableViewCell *cell1 = [dinnerListViewController.tableView.dataSource tableView:dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  UITableViewCell *cell2 = [dinnerListViewController.tableView.dataSource tableView:dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

  XCTAssertEqual(numberOfRows, 2);
  XCTAssertEqualObjects(cell1.textLabel.text, @"First Test Dinner");
  XCTAssertEqualObjects(cell2.textLabel.text, @"Second Test Dinner");
}

- (void)test_addButtonTapped_PresentsAddDinnerViewController{
  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
  DinnerListViewController *dinnerListViewController = [factory componentForType:[DinnerListViewController class]];
  id partialMock = [OCMockObject partialMockForObject:dinnerListViewController];
  [[partialMock expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[AddDinnerViewController class]];
  }] animated:YES completion:nil];

  [dinnerListViewController addButtonTapped];

  [partialMock verify];
}

- (void)test_sendDinner_Always_SendNewDinner{
  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
  DinnerListViewController *dinnerListViewController = [factory componentForType:[DinnerListViewController class]];
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  [addDinnerViewController view];
  addDinnerViewController.dinnerTitleTextField.text = @"Test Dinner";
  addDinnerViewController.delegate = dinnerListViewController;
  id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];
  dinnerListViewController.sessionManager = mockSessionManager;
  [[mockSessionManager expect] POST:@"/dinners" parameters:@{@"title":@"Test Dinner"} success:OCMOCK_ANY failure:OCMOCK_ANY];

  [addDinnerViewController sendDinner];

  [mockSessionManager verify];
}

- (NSData *)getStubDinnersJSON {
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
