//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AddDinnerViewController.h"

@interface DinnerListViewController : UIViewController <AddDinnerViewControllerDelegate>
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) id sessionManager;

- (void)addButtonTapped;
@end