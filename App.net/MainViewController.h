//
//  MainViewController.h
//  App.net
//
//  Created by Benjamin SENECHAL on 22/12/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
@interface MainViewController : UIViewController
@property (strong, nonatomic) IBOutlet NSArray *members;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
