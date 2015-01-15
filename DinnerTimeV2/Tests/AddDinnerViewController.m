//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import "AddDinnerViewController.h"
#import "DinnerListViewController.h"


@implementation AddDinnerViewController {

}
- (void)sendDinner {
  [self.delegate addDinnerWithDinnerTitle:self.dinnerTitleTextField.text];
}

@end