//
//  memberTransactionPopover.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 29/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberTransactionPopover.h"

@implementation memberTransactionPopover

- (void) setNavigatorCallBack:(METHODCALLBACK) p_navigatorCallBack;
{
    _navigatorCallBack = p_navigatorCallBack;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.view setFrame:CGRectMake(0, 0, 125, 260)];
    CGRect tvrect = CGRectMake(0, 0, 120, 250);
    _headertv = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    //[_headertv setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_headertv];
    [_headertv setBackgroundView:nil];
    [_headertv setBackgroundView:[[UIView alloc] init]];
    [_headertv setBackgroundColor:[UIColor whiteColor]];
    [_headertv setDelegate:self];
    [_headertv setDataSource:self];
    [_headertv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_headertv setSeparatorColor:[UIColor grayColor]];
    [_headertv setBounces:NO];
    [_headertv reloadData];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"no of ites for division  nd count is %d",[currentData count] );
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", 200+indexPath.row], @"data", nil];
    _navigatorCallBack(selInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Executing ceeforrowindex path");
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleSubtitle
                 reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor whiteColor];
        //cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
    }
    
    switch (indexPath.row) 
    {
        case 0:
            cell.textLabel.text = @"Members";
            break;
        case 1:
            cell.textLabel.text = @"Contracts";
            break;
        case 2:
            cell.textLabel.text = @"Collections";
            break;
        case 3:
            cell.textLabel.text = @"Notes";
            break;
        case 4:
            cell.textLabel.text = @"Refunds";
            break;
        default:
            break;
    }
    return cell;
}




@end
