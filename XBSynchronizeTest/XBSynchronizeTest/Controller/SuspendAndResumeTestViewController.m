//
//  SuspendAndResumeTestViewController.m
//  XBSynchronizeTest
//
//  Created by xxb on 2019/4/1.
//  Copyright © 2019年 xxb. All rights reserved.
//

#import "SuspendAndResumeTestViewController.h"

@interface SuspendAndResumeTestViewController ()

@end

@implementation SuspendAndResumeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self mainThreadTest];
    [self serialThreadTest];
//    [self globalThreadTest];
//    [self globalThreadTest_1];
}

/**
 dispatch_after,是在指定时间将任务加载到队列。但是如果是串行队列的情况，即使已经加到队列中了，也必须等队列中排在该任务前面的任务执行完了再执行该任务
 
 2019-04-01 10:39:22.706236+0800 XBSynchronizeTest[295:7209] 0
 2019-04-01 10:39:23.707548+0800 XBSynchronizeTest[295:7209] 1
 2019-04-01 10:39:24.708768+0800 XBSynchronizeTest[295:7209] 2
 2019-04-01 10:39:25.710006+0800 XBSynchronizeTest[295:7209] 3
 2019-04-01 10:39:26.711162+0800 XBSynchronizeTest[295:7209] 4
 2019-04-01 10:39:27.712395+0800 XBSynchronizeTest[295:7209] 5
 2019-04-01 10:39:28.713636+0800 XBSynchronizeTest[295:7209] 6
 2019-04-01 10:39:29.714887+0800 XBSynchronizeTest[295:7209] 7
 2019-04-01 10:39:30.716122+0800 XBSynchronizeTest[295:7209] 8
 2019-04-01 10:39:31.717352+0800 XBSynchronizeTest[295:7209] 9
 2019-04-01 10:39:32.718756+0800 XBSynchronizeTest[295:7209] 10
 2019-04-01 10:39:33.720009+0800 XBSynchronizeTest[295:7209] 11
 2019-04-01 10:39:34.721255+0800 XBSynchronizeTest[295:7209] 12
 2019-04-01 10:39:35.722500+0800 XBSynchronizeTest[295:7209] 13
 2019-04-01 10:39:36.723748+0800 XBSynchronizeTest[295:7209] 14
 2019-04-01 10:39:41.729567+0800 XBSynchronizeTest[295:7209] end
 2019-04-01 10:39:41.730260+0800 XBSynchronizeTest[295:7209] dispatch_suspend
 2019-04-01 10:39:41.730422+0800 XBSynchronizeTest[295:7209] dispatch_resume
 */
- (void)mainThreadTest
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 15; i++)
        {
            if (i == 5)
            {
                NSLog(@"dispatch_suspend");
                dispatch_suspend(queue);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                    NSLog(@"dispatch_resume");
                    dispatch_resume(queue);
                });
            }
            sleep(1);
            NSLog(@"%ld",i);
        }
        NSLog(@"end");
    });
}

/**
 异步串行：任务已经添加到队列中，并且还没有执行，那么调用suspend可以暂停任务的执行，resume继续执行未完成的任务
 
 2019-04-01 11:14:12.570629+0800 XBSynchronizeTest[363:16124] end
 2019-04-01 11:14:13.576158+0800 XBSynchronizeTest[363:16146] 0,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:14.577285+0800 XBSynchronizeTest[363:16146] 1,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:15.579303+0800 XBSynchronizeTest[363:16146] 2,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:16.581358+0800 XBSynchronizeTest[363:16146] 3,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:17.586845+0800 XBSynchronizeTest[363:16146] 4,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:17.587041+0800 XBSynchronizeTest[363:16146] dispatch_suspend
 2019-04-01 11:14:18.592494+0800 XBSynchronizeTest[363:16146] 5,currentThread:<NSThread: 0x282e70180>{number = 3, name = (null)}
 2019-04-01 11:14:23.558571+0800 XBSynchronizeTest[363:16145] dispatch_resume
 2019-04-01 11:14:24.560980+0800 XBSynchronizeTest[363:16148] 6,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:25.565798+0800 XBSynchronizeTest[363:16148] 7,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:26.571276+0800 XBSynchronizeTest[363:16148] 8,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:27.575275+0800 XBSynchronizeTest[363:16148] 9,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:28.580847+0800 XBSynchronizeTest[363:16148] 10,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:29.586331+0800 XBSynchronizeTest[363:16148] 11,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:30.591881+0800 XBSynchronizeTest[363:16148] 12,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:31.597381+0800 XBSynchronizeTest[363:16148] 13,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}
 2019-04-01 11:14:32.602861+0800 XBSynchronizeTest[363:16148] 14,currentThread:<NSThread: 0x282e75300>{number = 4, name = (null)}

 */
- (void)serialThreadTest
{
    dispatch_queue_t queue = dispatch_queue_create("test", NULL);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispatch_resume");
        dispatch_resume(queue);
    });
    
    for (NSInteger i = 0; i < 15; i++)
    {
        dispatch_async(queue, ^{
            if (i == 5)
            {
                NSLog(@"dispatch_suspend");
                dispatch_suspend(queue);
            }
            sleep(1);
            NSLog(@"%ld,currentThread:%@",i,[NSThread currentThread]);
        });
    }
    NSLog(@"end");
}

/**
 不起作用，看来是针对多个任务时使用的。如果只有一个任务，并且已经开始执行，suspend和resume不起作用
 
 2019-04-01 10:57:51.705090+0800 XBSynchronizeTest[335:12080] 0,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:52.710680+0800 XBSynchronizeTest[335:12080] 1,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:53.712192+0800 XBSynchronizeTest[335:12080] 2,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:54.717649+0800 XBSynchronizeTest[335:12080] 3,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:55.723125+0800 XBSynchronizeTest[335:12080] 4,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:55.723283+0800 XBSynchronizeTest[335:12080] dispatch_suspend
 2019-04-01 10:57:56.725482+0800 XBSynchronizeTest[335:12080] 5,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:57.730919+0800 XBSynchronizeTest[335:12080] 6,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:57.879375+0800 XBSynchronizeTest[335:12082] dispatch_resume
 2019-04-01 10:57:58.736343+0800 XBSynchronizeTest[335:12080] 7,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:57:59.741787+0800 XBSynchronizeTest[335:12080] 8,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:00.747213+0800 XBSynchronizeTest[335:12080] 9,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:01.750403+0800 XBSynchronizeTest[335:12080] 10,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:02.755830+0800 XBSynchronizeTest[335:12080] 11,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:03.761285+0800 XBSynchronizeTest[335:12080] 12,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:04.766720+0800 XBSynchronizeTest[335:12080] 13,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:05.772164+0800 XBSynchronizeTest[335:12080] 14,currentThread:<NSThread: 0x282a6ca40>{number = 3, name = (null)}
 2019-04-01 10:58:05.772317+0800 XBSynchronizeTest[335:12080] end
 */
- (void)globalThreadTest
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 15; i++)
        {
            if (i == 5)
            {
                NSLog(@"dispatch_suspend");
                dispatch_suspend(queue);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                    NSLog(@"dispatch_resume");
                    dispatch_resume(queue);
                });
            }
            sleep(1);
            NSLog(@"%ld,currentThread:%@",i,[NSThread currentThread]);
        }
        NSLog(@"end");
    });
}

/**
 无法控制系统创建的线程数量，所以不好模拟测试，理论上和serialThreadTest的测试结果一样
 */
- (void)globalThreadTest_1
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSInteger i = 0; i < 15; i++)
    {
        dispatch_async(queue, ^{
            if (i == 5)
            {
                NSLog(@"dispatch_suspend");
                dispatch_suspend(queue);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                    NSLog(@"dispatch_resume");
                    dispatch_resume(queue);
                });
            }
            sleep(i);
            NSLog(@"%ld,currentThread:%@",i,[NSThread currentThread]);
        });
        NSLog(@"end");
    }
}


@end
