//
//  ViewController.m
//  MidTest
//
//  Created by Wei on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ClientSyncController.h"
#import "SBJson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"应用程序启动！");
    
    int num[] = {4, 8, 2, 1, 0, 6, 7, 5, 3, 9};
    int n;
    for (n = 0; n < 10; n++) {
        printf("%d,", num[n]);
    }
    printf("\n");
    
    int maxNumIndex = 0;
    for (int i = 1; i < 10; i++) {
        int j = 0;
        for (j = 0; j < 10 - i; j++) {
            if (num[j] > num[maxNumIndex]) {
                maxNumIndex = j;
            }
        }
        int t = num[j];
        num[j] = num[maxNumIndex];
        num[maxNumIndex] = t;
        
        for (n = 0; n < 10; n++) {
            printf("%d,", num[n]);
        }
        printf("<%d>\n", i);
    }
    
    for (n = 0; n < 10; n++) {
        printf("%d,", num[n]);
    }
    printf("\n");
    
    return;
    
    
    /*JSON操作
    SBJsonParser *parser = [[SBJsonParser alloc]init];
    
    NSString *webServiceURL = @"http://www.loc.gov/pictures/item/89709841/?fo=json";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:webServiceURL]];
    
    //NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *jsonString;// = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    
    //NSArray *jsonArray = [[NSArray alloc]initWithArray:[parser objectWithString:jsonString]];
    
    
    NSArray *array_1 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_2 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_3 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item999", @"item4", @"item5", nil];
    NSArray *array_4 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array_5 = [[NSArray alloc]initWithObjects:@"item1", @"item2", @"item3", @"item4", @"item5", nil];
    NSArray *array = [[NSArray alloc]initWithObjects:array_1, array_2, array_3, array_4, array_5, nil];
    NSArray *arrayKey = [[NSArray alloc]initWithObjects:@"asdf1", @"asdf2", @"asdf3", @"asdf4", @"asdf5", nil];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjects:array forKeys:arrayKey];
    //NSLog(@"%@", [[dic objectForKey:@"asdf3"] objectAtIndex:2]);
    
    jsonString = [dic JSONRepresentation];
    //NSLog(@"%@", jsonString);
//    NSDictionary *jsonDic = [parser objectWithString:jsonString];
    NSDictionary *jsonDic = [jsonString JSONValue];
    
    NSLog(@"%@", [[jsonDic objectForKey:@"asdf3"] objectAtIndex:2]);
    
    
    
    
    return;
    */
    
    ClientSyncController *csc = [[ClientSyncController alloc]init];
    csc.delegate = self;
    
    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage.txt"];
    
    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage.txt"];
    [csc addTaskWithFilePath:@"/Users/wei/Library/Application Support/iPhone Simulator/5.1/Applications/3A846252-D215-4EF4-B647-C0F366A25121/Documents/Middleware/testPackage.txt"];
    [csc startUpwardTransmitThread];
    [csc startDownwardTransmitThread];
    
    
    return;
    
    NSLog(@"调用打包方法，将要同步的数据打包。");
    NSLog(@"调用方法，将要同步的数据打包。");
    //[csc addTask:@"这里是数据包！"];
//    NSLog(@"调用中间件同步方法");
//    [csc synchronize];
    
    [csc startUpwardTransmitThread];
    csc.updateThreadStoped = NO;
    while (YES) {
        if (csc.upwardThreadStoped) {
            break;
        }
    }
    [csc startDownwardTransmitThread];
    
}

#pragma mark - 控制器委托
- (void)upwardTransminThreadStoped
{
    
}

- (void)downwardTransminThreadStoped
{
    
}

-(void)uploadBegin
{
    //NSLog(@"这里是应用程序控制的uploadBegin");
}

-(void)uploadFinish
{
    //NSLog(@"这里是应用程序控制的uploadFinish");
}

-(void)downloadBegin
{
    //NSLog(@"这里是应用程序控制的downloadBegin");
}

-(void)downloadFinish
{
    //NSLog(@"这里是应用程序控制的downloadFinish");
}

- (BOOL)doUpdateOfTask:(SyncTaskDescription *)taskDescription WithDataPackage:(NSString *)dataPackage
{
    return YES;
}

#pragma mark 

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
