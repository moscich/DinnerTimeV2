//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DinnerListViewController;
@class AddDinnerViewController;

@protocol AddDinnerViewControllerDelegate
- (void)addDinnerWithDinnerTitle:(NSString *)title;
@end

@interface AddDinnerViewController : UIViewController
@property(nonatomic, strong) id <AddDinnerViewControllerDelegate> delegate;
@property(nonatomic, strong) IBOutlet UITextField *dinnerTitleTextField;

- (void)sendDinner;
@end