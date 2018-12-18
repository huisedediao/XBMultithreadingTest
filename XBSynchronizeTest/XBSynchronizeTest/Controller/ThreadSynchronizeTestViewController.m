//
//  ThreadSynchronizeTestViewController.m
//  XBSynchronizeTest
//
//  Created by xxb on 2018/12/18.
//  Copyright © 2018年 xxb. All rights reserved.
//

#import "ThreadSynchronizeTestViewController.h"


///结论：被同一个锁锁住的代码段，依次执行



@interface ThreadSynchronizeTestViewController ()
{
    int testInt111;
    int testInt222;
    NSLock *lock1;
    NSLock *lock2;
}
@end

@implementation ThreadSynchronizeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lock1 = [NSLock new];
    lock2 = [NSLock new];
    
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue1, ^{
        NSLog(@"queue1 start currentThread:%@",[NSThread currentThread]);
        [lock1 lock];
        int index = 0;
        while (index < 10)
        {
            sleep(1);
            index ++;
            NSLog(@"1111----%d",index);
        }
        [lock1 unlock];
        NSLog(@"queue1 end currentThread:%@",[NSThread currentThread]);
    });

    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue2, ^{
        NSLog(@"queue2 start currentThread:%@",[NSThread currentThread]);
        [lock2 lock];
        int index = 0;
        while (index < 10)
        {
            sleep(1);
            index ++;
            NSLog(@"2222----%d",index);
        }
        [lock2 unlock];
        NSLog(@"queue2 end currentThread:%@",[NSThread currentThread]);
    });
    
    dispatch_queue_t queue3 = dispatch_queue_create("queue3", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue3, ^{
        NSLog(@"queue3 start currentThread:%@",[NSThread currentThread]);
        [lock1 lock];
        int index = 0;
        while (index < 10)
        {
            sleep(1);
            index++;
            NSLog(@"333----%d",index);
        }
        [lock1 unlock];
        NSLog(@"queue3 end currentThread:%@",[NSThread currentThread]);
    });
}


@end
