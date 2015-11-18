//
//  ViewController.m
//  GCD初尝试
//
//  Created by 张汇丰 on 15/11/12.
//  Copyright © 2015年 张汇丰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testGroup];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)useThread {
    
}

- (void)useGCD {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC);
    
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(mySerialDispatchQueue, ^{
        NSLog(@"serialQueue1");
        sleep(2);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            NSLog(@"serialQueue1 after");
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"global1");
        sleep(2);
        
        
        dispatch_after(time, dispatch_get_main_queue(), ^{
            NSLog(@"global1after");
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"global2");
        });
    });
}
- (void)test1 {
    dispatch_queue_t mySerialDispatchQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1%@", [NSThread currentThread]);
    dispatch_async(mySerialDispatchQueue, ^{
        //code here
        NSLog(@"2%@", [NSThread currentThread]);
        
    });
}

- (void)testGroup {
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //3.
    //3.1 执行3次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-01-%@ ",[NSThread currentThread]);
        }
    });
    
    //3.2 主队列执行8次循环
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    //3.3.执行5次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
