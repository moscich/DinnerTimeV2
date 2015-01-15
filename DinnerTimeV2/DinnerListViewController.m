//
// Created by Marek Moscichowski on 15.01.15.
// Copyright (c) 2015 Marek Mościchowski. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DinnerListViewController.h"

@interface DinnerListViewController () <UITableViewDataSource>
@property (nonatomic, strong) NSArray *model;
@end

@implementation DinnerListViewController {

}

- (void)viewDidLoad {
  [self.sessionManager GET:@"http://localhost:3001/dinners" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSMutableArray *results = [NSMutableArray new];
    NSError *jsonError;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&jsonError];
    NSArray *dinnersDicts = dict[@"dinners"];
    for(NSDictionary *dinnerDictionary in dinnersDicts){
      [results addObject:dinnerDictionary[@"title"]];
    }
    self.model = results;
  } failure:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.model.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  cell.textLabel.text = self.model[(NSUInteger) indexPath.row];
  return cell;
}


@end