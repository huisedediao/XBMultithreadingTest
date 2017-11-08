//
//  ViewController.m
//  XBSynchronizeTest
//
//  Created by xxb on 2017/11/7.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self lockTest_2];

    [self forTest_5];
}

- (void)forTest_1
{
    NSLock *lock = [NSLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10; i++)
        {
            NSLog(@"%zd",i);
            //            NSLog(@"%@",[NSThread currentThread]);
            [lock lock];
            sleep(1);
            [lock unlock];
        }
    });
}
/*
 虽然lock可以线程同步，但是因为没办法控制多线程异步并行的任务执行顺序（就是说你不知道哪个任务被排在前面了）
 但是，虽然在调用多线程异步并行地去执行任务之前没法确定任务的顺序，但是一旦多线程异步并行地开始执行任务，那么任务的顺序是被定下来的
 
 但是这里的lock是有效果的，注意打印的时间，任务是同步执行
 
 2017-11-08 10:46:17.583200+0800 XBSynchronizeTest[6962:2076345] <NSThread: 0x1c0264900>{number = 6, name = (null)}
 2017-11-08 10:46:17.583293+0800 XBSynchronizeTest[6962:2076345] -->0
 2017-11-08 10:46:18.589152+0800 XBSynchronizeTest[6962:2076347] <NSThread: 0x1c0070140>{number = 3, name = (null)}
 2017-11-08 10:46:18.589340+0800 XBSynchronizeTest[6962:2076347] -->1
 2017-11-08 10:46:19.592749+0800 XBSynchronizeTest[6962:2076348] <NSThread: 0x1c0264a00>{number = 7, name = (null)}
 2017-11-08 10:46:19.592934+0800 XBSynchronizeTest[6962:2076348] -->2
 2017-11-08 10:46:20.594687+0800 XBSynchronizeTest[6962:2076351] <NSThread: 0x1c00772c0>{number = 4, name = (null)}
 2017-11-08 10:46:20.594872+0800 XBSynchronizeTest[6962:2076351] -->3
 2017-11-08 10:46:21.600372+0800 XBSynchronizeTest[6962:2076346] <NSThread: 0x1c0077340>{number = 8, name = (null)}
 2017-11-08 10:46:21.600473+0800 XBSynchronizeTest[6962:2076346] -->4
 2017-11-08 10:46:22.606015+0800 XBSynchronizeTest[6962:2076354] <NSThread: 0x1c02636c0>{number = 9, name = (null)}
 2017-11-08 10:46:22.606157+0800 XBSynchronizeTest[6962:2076354] -->5
 2017-11-08 10:46:23.612027+0800 XBSynchronizeTest[6962:2076355] <NSThread: 0x1c0264900>{number = 10, name = (null)}
 2017-11-08 10:46:23.612211+0800 XBSynchronizeTest[6962:2076355] -->6
 2017-11-08 10:46:24.618037+0800 XBSynchronizeTest[6962:2076356] <NSThread: 0x1c0070140>{number = 11, name = (null)}
 2017-11-08 10:46:24.618235+0800 XBSynchronizeTest[6962:2076356] -->7
 2017-11-08 10:46:25.624147+0800 XBSynchronizeTest[6962:2076357] <NSThread: 0x1c0264a00>{number = 12, name = (null)}
 2017-11-08 10:46:25.624334+0800 XBSynchronizeTest[6962:2076357] -->8
 2017-11-08 10:46:26.626611+0800 XBSynchronizeTest[6962:2076358] <NSThread: 0x1c00772c0>{number = 13, name = (null)}
 2017-11-08 10:46:26.626794+0800 XBSynchronizeTest[6962:2076358] -->9
 */
- (void)forTest_2
{
    NSLock *lock = [NSLock new];
    for (int i = 0; i < 10; i++)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [lock lock];
            sleep(1);
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"-->%zd",i);
            [lock unlock];
        });
    }

}
/*
 和上面是一样的原因,这里的lock没有任何作用
 
 2017-11-08 10:43:01.136407+0800 XBSynchronizeTest[6959:2075380] <NSThread: 0x1c006b500>{number = 3, name = (null)}
 2017-11-08 10:43:01.136498+0800 XBSynchronizeTest[6959:2075380] -->1
 2017-11-08 10:43:01.136655+0800 XBSynchronizeTest[6959:2075385] <NSThread: 0x1c007adc0>{number = 5, name = (null)}
 2017-11-08 10:43:01.136695+0800 XBSynchronizeTest[6959:2075388] <NSThread: 0x1c406e9c0>{number = 6, name = (null)}
 2017-11-08 10:43:01.136699+0800 XBSynchronizeTest[6959:2075385] -->2
 2017-11-08 10:43:01.136728+0800 XBSynchronizeTest[6959:2075388] -->5
 2017-11-08 10:43:01.136896+0800 XBSynchronizeTest[6959:2075389] <NSThread: 0x1c407d9c0>{number = 7, name = (null)}
 2017-11-08 10:43:01.136929+0800 XBSynchronizeTest[6959:2075389] -->6
 2017-11-08 10:43:01.136969+0800 XBSynchronizeTest[6959:2075392] <NSThread: 0x1c007af40>{number = 8, name = (null)}
 2017-11-08 10:43:01.137004+0800 XBSynchronizeTest[6959:2075392] -->9
 2017-11-08 10:43:01.137038+0800 XBSynchronizeTest[6959:2075382] <NSThread: 0x1c407f9c0>{number2017-11-08 10:43:01.137245+0800 XBSynchronizeTest[6959:2075391] <NSThread: 0x1c007bc40>{number = 13, name = (null)}
 = 9, name = (null)}
 2017-11-08 10:43:01.137317+0800 XBSynchronizeTest[6959:2075391] -->8
 2017-11-08 10:43:01.137327+0800 XBSynchronizeTest[6959:2075382] -->0
 2017-11-08 10:43:01.137125+0800 XBSynchronizeTest[6959:2075383] <NSThread: 0x1c407da00>{number = 10, name = (null)}
 2017-11-08 10:43:01.137144+0800 XBSynchronizeTest[6959:2075381] <NSThread: 0x1c007be80>{number = 11, name = (null)}
 2017-11-08 10:43:01.137386+0800 XBSynchronizeTest[6959:2075383] -->3
 2017-11-08 10:43:01.137400+0800 XBSynchronizeTest[6959:2075381] -->4
 2017-11-08 10:43:01.137236+0800 XBSynchronizeTest[6959:2075390] <NSThread: 0x1c407da80>{number = 12, name = (null)}
 2017-11-08 10:43:01.137440+0800 XBSynchronizeTest[6959:2075390] -->7

 */
- (void)forTest_3
{
    NSLock *lock = [NSLock new];
    for (int i = 0; i < 10; i++)
    {
        [lock lock];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"-->%zd",i);
        });
        [lock unlock];
    }
    
}
/*
 要另开线程并且控制任务的顺序，自己创建一个队列，异步串行即可
 
 2017-11-08 10:55:44.940168+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:44.940267+0800 XBSynchronizeTest[6965:2078228] -->0
 2017-11-08 10:55:45.946140+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:45.946325+0800 XBSynchronizeTest[6965:2078228] -->1
 2017-11-08 10:55:46.951943+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:46.952127+0800 XBSynchronizeTest[6965:2078228] -->2
 2017-11-08 10:55:47.954069+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:47.954288+0800 XBSynchronizeTest[6965:2078228] -->3
 2017-11-08 10:55:48.959854+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:48.960039+0800 XBSynchronizeTest[6965:2078228] -->4
 2017-11-08 10:55:49.962042+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:49.962227+0800 XBSynchronizeTest[6965:2078228] -->5
 2017-11-08 10:55:50.967904+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:50.968082+0800 XBSynchronizeTest[6965:2078228] -->6
 2017-11-08 10:55:51.973825+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:51.974012+0800 XBSynchronizeTest[6965:2078228] -->7
 2017-11-08 10:55:52.974913+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:52.975099+0800 XBSynchronizeTest[6965:2078228] -->8
 2017-11-08 10:55:53.976925+0800 XBSynchronizeTest[6965:2078228] <NSThread: 0x1c426b800>{number = 5, name = (null)}
 2017-11-08 10:55:53.977108+0800 XBSynchronizeTest[6965:2078228] -->9
 */
- (void)forTest_4
{
    dispatch_queue_t queue = dispatch_queue_create("hh", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++)
    {
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"%@",[NSThread currentThread]);
            NSLog(@"-->%zd",i);
        });
    }
}
/*
 和 forTest_3 是一样的结果
 */
- (void)forTest_5
{
    dispatch_queue_t queue = dispatch_queue_create("hh", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i++)
    {
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                sleep(1);
                NSLog(@"%@",[NSThread currentThread]);
                NSLog(@"-->%zd",i);
            });
        });
    }
}

#pragma mark - NSLock
/*
 效果同@synchronized
 */
- (void)lockTest_1
{
    NSLock *lock = [NSLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        NSLog(@"需要同步的步骤1，开始");
        sleep(3);
        NSLog(@"需要同步的步骤1，结束");
        [lock unlock];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock]; //如果锁在之前上过锁，则这里会等到解锁之后再上锁，是会阻塞线程的
        NSLog(@"需要同步的步骤2");
        [lock unlock];
    });
}

- (void)lockTest_2
{
    NSLock *lock = [NSLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [lock lock];
        NSLog(@"需要同步的步骤1，开始");
        sleep(5);
        NSLog(@"需要同步的步骤1，结束");
        [lock unlock];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL lockResult1 = [lock tryLock];  //tryLock不会阻塞线程，也就没有了线程同步效果
        if (lockResult1)
        {
            NSLog(@"上锁成功");
        }
        else
        {
            NSLog(@"锁已经锁定，还未解锁");
        }
        BOOL lockResult2 = [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3]]; //在指定时间到来之前，上锁并且阻塞线程，返回yes表示在指定时间到达之前，上一次上的锁已经解锁了，返回no则表示在指定时间到达时，上一次的锁还未解锁
        if (lockResult2)
        {
            NSLog(@"在指定时间到达之前，上一次的锁已经解除了");
        }
        else
        {
            NSLog(@"在指定时间到达时，上一次的锁还未解锁");
        }
    });
}


#pragma mark - synchronized
/** 
 @synchronized
 以参数为标识符，如果参数为同一个对象，则代码是同步执行的
 可以看成，参数对象相同，被包括的代码是在另一个线程上顺序执行（或者看成有另一个调度机制在控制代码顺序执行）
 
 2017-11-07 16:14:40.172743+0800 XBSynchronizeTest[5899:1721147] 需要同步的步骤1，开始
 2017-11-07 16:14:40.184619+0800 XBSynchronizeTest[5899:1721099] refreshPreferences: HangTracerEnabled: 0
 2017-11-07 16:14:40.184706+0800 XBSynchronizeTest[5899:1721099] refreshPreferences: HangTracerDuration: 500
 2017-11-07 16:14:40.184741+0800 XBSynchronizeTest[5899:1721099] refreshPreferences: ActivationLoggingEnabled: 0 ActivationLoggingTaskedOffByDA:0
 2017-11-07 16:14:43.177869+0800 XBSynchronizeTest[5899:1721147] 需要同步的步骤1，结束
 2017-11-07 16:14:43.178333+0800 XBSynchronizeTest[5899:1721146] 需要同步的步骤2
 
 */

- (void)synchronizedTestTokenSame
{
    NSObject *obj = [NSObject new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (obj) {
            NSLog(@"需要同步的步骤1，开始");
            sleep(3);
            NSLog(@"需要同步的步骤1，结束");
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (obj) {
            NSLog(@"需要同步的步骤2");
        }
    });
}
/*
 token 不是同一个对象则不同步
 
 2017-11-07 16:16:01.743943+0800 XBSynchronizeTest[5906:1721999] 需要同步的步骤1，开始
 2017-11-07 16:16:01.744113+0800 XBSynchronizeTest[5906:1722005] 需要同步的步骤2
 2017-11-07 16:16:01.761418+0800 XBSynchronizeTest[5906:1721966] refreshPreferences: HangTracerEnabled: 0
 2017-11-07 16:16:01.761506+0800 XBSynchronizeTest[5906:1721966] refreshPreferences: HangTracerDuration: 500
 2017-11-07 16:16:01.761542+0800 XBSynchronizeTest[5906:1721966] refreshPreferences: ActivationLoggingEnabled: 0 ActivationLoggingTaskedOffByDA:0
 2017-11-07 16:16:04.745896+0800 XBSynchronizeTest[5906:1721999] 需要同步的步骤1，结束
 */
- (void)synchronizedTestTokenDifferent
{
    NSObject *obj = [NSObject new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (obj) {
            NSLog(@"需要同步的步骤1，开始");
            sleep(3);
            NSLog(@"需要同步的步骤1，结束");
        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized (self) {
            NSLog(@"需要同步的步骤2");
        }
    });
}

@end
