//
//  MainViewController.m
//  App.net
//
//  Created by Benjamin SENECHAL on 22/12/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize members;
@synthesize tableView;
int f=0;
@synthesize loader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoad) name:@"notificationLoadMembersNewsFinished" object:nil];

    members = [Member findAllSortedBy:@"created_at" ascending:NO];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    [self.tableView reloadData];
    if (f == 0) {
        [ManagedMember loadDataFromWebService];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoad) name:@"notificationLoadMembersNewsFinished" object:nil];
        f = 1;
    }else{
        [self finishedLoad];
    }
}


-(void)finishedLoad{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationLoadMembersNewsFinished" object:nil];
    [self.tableView reloadData];
    [loader stopAnimating];
}


- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    [ManagedMember loadDataFromWebService];
    members = [Member findAllSortedBy:@"created_at" ascending:NO];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *Cell = [[CustomCell alloc] init];
    Cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Member *n = [members objectAtIndex:indexPath.row];
    [Cell.avatar setImage:[UIImage imageWithData:n.avatar]];
    Cell.avatar.layer.cornerRadius = 35;
    Cell.avatar.layer.masksToBounds = YES;
    
    Cell.text.numberOfLines = 0;
    [Cell.name setText:n.name];
    if ([[[members valueForKey:@"text"]objectAtIndex:indexPath.row]isEqual:@"null"]){
        Cell.text.text = @"";
    }else{
        Cell.text.text = [[members valueForKey:@"text"]objectAtIndex:indexPath.row];
    }
    [Cell.text setFont:FONT(14)];
    CGSize size = [n.text
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    CGRect newFrame = Cell.text.frame;
    newFrame.size.height = size.height;
    Cell.text.frame = newFrame;
    
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[[members valueForKey:@"text" ] objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    NSLog(@"%f", size.height);
    return size.height+150;
}

@end
