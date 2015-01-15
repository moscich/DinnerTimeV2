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
#import <objc/objc-api.h>
#import "ApplicationAssembly.h"
#import "DinnerListViewController.h"
#import "OCMockObject.h"
#import "AFHTTPSessionManager.h"
#import "OCMStubRecorder.h"
#import "OCMArg.h"

@interface DinnerListViewControllerTests : XCTestCase

@property(nonatomic, strong) DinnerListViewController *dinnerListViewController;
@end

@implementation DinnerListViewControllerTests

- (void)setUp {
  TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:[ApplicationAssembly assembly]];
  self.dinnerListViewController = [factory componentForType:[DinnerListViewController class]];
}

- (void)test_viewDidLoad_DisplaysFetchedDinnersOnTheTableView {
  [self addMockSessionManagerToDinnerListViewController:[self setupStubReturningTestDinners]];

  [self.dinnerListViewController view];

  int numberOfRows = [self.dinnerListViewController.tableView.dataSource tableView:self.dinnerListViewController.tableView numberOfRowsInSection:0];
  UITableViewCell *cell1 = [self.dinnerListViewController.tableView.dataSource tableView:self.dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
  UITableViewCell *cell2 = [self.dinnerListViewController.tableView.dataSource tableView:self.dinnerListViewController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

  XCTAssertEqual(numberOfRows, 2);
  XCTAssertEqualObjects(cell1.textLabel.text, @"First Test Dinner");
  XCTAssertEqualObjects(cell2.textLabel.text, @"Second Test Dinner");
}

- (void)test_addButtonTapped_PresentsAddDinnerViewController{
  id partialMock = [OCMockObject partialMockForObject:self.dinnerListViewController];
  [[partialMock expect] presentViewController:[OCMArg checkWithBlock:^BOOL(id obj) {
    return [obj isKindOfClass:[AddDinnerViewController class]];
  }] animated:YES completion:nil];

  [self.dinnerListViewController addButtonTapped];

  [partialMock verify];
}

- (void)test_sendDinner_Always_SendNewDinner{
  AddDinnerViewController *addDinnerViewController = [AddDinnerViewController new];
  [addDinnerViewController view];
  addDinnerViewController.dinnerTitleTextField.text = @"Test Dinner";
  addDinnerViewController.delegate = self.dinnerListViewController;

  id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];
  [[mockSessionManager expect] POST:@"/dinners" parameters:@{@"title":@"Test Dinner"} success:OCMOCK_ANY failure:OCMOCK_ANY];
  [self addMockSessionManagerToDinnerListViewController:mockSessionManager];

  [addDinnerViewController sendDinner];

  [mockSessionManager verify];
}

- (id)setupStubReturningTestDinners {
  id mockSessionManager = [OCMockObject mockForClass:[AFHTTPSessionManager class]];
  [[[mockSessionManager stub] andDo:^(NSInvocation *invocation) {
    void (^passedBlock)(AFHTTPRequestOperation *operation, id responseObject);
    [invocation getArgument:&passedBlock atIndex:4];
    passedBlock(nil, [self getStubDinnersJSON]);
  }] GET:@"http://localhost:3001/dinners" parameters:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
  return mockSessionManager;
}

- (void)addMockSessionManagerToDinnerListViewController:(AFHTTPSessionManager *)sessionManager {
  self.dinnerListViewController.sessionManager = sessionManager;
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
