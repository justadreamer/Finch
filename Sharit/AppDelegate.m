//
//  AppDelegate.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "MainViewController.h"
#import "Helper.h"
#import "Reachability.h"
#import "SharesProvider.h"
#import "MainHTTPConnection.h"
#import "GlobalDefaults.h"
#import "SharesProvider.h"

@interface AppDelegate()<NSNetServiceDelegate>
@property (nonatomic,strong) HTTPServer* httpServer;
@property (nonatomic,strong) Reachability* reachabilityWiFi;
@property (nonatomic,strong) Reachability* reachabilityForInternet;
@property (nonatomic,strong) NSNetService* netService;

- (void) setupHTTPServer;
- (void) setupReachability;
- (void) setupIdleTimer;
@end

@implementation AppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize httpServer;
@synthesize reachabilityWiFi;
@synthesize reachabilityForInternet;
@synthesize netService;

void uncaughtExceptionHandler(NSException *exception);

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(uncaughtExceptionHandler);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    self.viewController.sharesProvider = [SharesProvider instance];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    //setup dirs needs to be before setupHTTPServer
    [self setupDirs];
    [self setupHTTPServer];
    [self setupBonjourNetService];
    [self setupReachability];
    [self setupIdleTimer];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.reachabilityWiFi stopNotifier];
    [self.reachabilityForInternet stopNotifier];
    [self.httpServer stop];
    [self.netService stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSError* error = nil;
    [self.reachabilityWiFi startNotifier];
    [self.reachabilityForInternet startNotifier];
    [self.httpServer start:&error];
    if (error) {
        VLog(error);
    }
    [[SharesProvider instance] refreshShares];
    [self.viewController refresh];
    [self.netService publish];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Setup HTTP Server]
- (void) copyResDir:(NSString*)resDirName toDir:(NSString*)toPath {
    NSString* fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:resDirName];
    NSError* error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
        if (error) 
            VLog(error);
    }
}

- (void) removeDir:(NSString*)dir {
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:dir error:&error];
        if (error)
            VLog(error);
    }

}

- (void) removePrevItemsForBase:(NSString*)base {
    NSArray* versions = [[Helper instance] versions];
#ifndef DEBUG
    NSString* lastVersion = [versions lastObject];
#endif
    for (NSString* version in versions) {
#ifndef DEBUG
        if (version != lastVersion)
#endif
            [self removeDir:[base stringByAppendingString:version]];
    }
}

- (void) copyTemplateDir {
    [self removePrevItemsForBase:[[Helper instance] baseTemplatesFolder]];
    [self copyResDir:templatesFolderName toDir:[[Helper instance] templatesFolder]];
}

- (void) copyDocroot {
    [self removePrevItemsForBase:[[Helper instance] baseDocrootFolder]];
    [self copyResDir:docrootFolderName toDir:[[Helper instance] docrootFolder]];
}

- (void) setupDirs {
    [self copyTemplateDir];
    [self copyDocroot];
}

- (void) setupHTTPServer {
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setPort:[GlobalDefaults port]];
    [self.httpServer setDocumentRoot:[[Helper instance] documentsRoot]];
    [self.httpServer setConnectionClass:[MainHTTPConnection class]];
}

#pragma mark -
#pragma mark Setup Reachability

- (void) setupReachability {
    self.reachabilityWiFi = [Reachability reachabilityForLocalWiFi];
    self.reachabilityForInternet = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}

- (void) reachabilityChanged:(NSNotification*)notification {
    [self.viewController refresh];
}

- (void) sharesRefreshed {
    [self.viewController sharesRefreshed];
}

- (void) setupIdleTimer {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

#pragma mark - 
#pragma mark Setup Bonjour Service Publishing

- (void) setupBonjourNetService {
    // Create and publish the bonjour service.
    // Obviously you will be using your own custom service type.

    self.netService = [[NSNetService alloc] initWithDomain:@""
                                                 type:@"_http._tcp."
                                                 name:@""
                                                 port:[GlobalDefaults port]];

    [netService setDelegate:self];

    // You can optionally add TXT record stuff

/*    NSMutableDictionary *txtDict = [NSMutableDictionary dictionaryWithCapacity:2];

    [txtDict setObject:@"moo" forKey:@"cow"];
    [txtDict setObject:@"quack" forKey:@"duck"];

    NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
    [netService setTXTRecordData:txtData];*/
}

- (void)netServiceDidPublish:(NSNetService *)ns {
    [[Helper instance] setIsBonjourPublished:YES];
    [[Helper instance] setBonjourName:ns.name];
    [self.viewController refresh];
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict {
    [[Helper instance] setIsBonjourPublished:NO];
	VLog(errorDict);
    [self.viewController refresh];
}

- (void)netServiceDidStop:(NSNetService *)sender {
    [[Helper instance] setIsBonjourPublished:NO];
    [self.viewController refresh];
}

#pragma mark - 
#pragma mark Uncaught exception handler

NSString* cleanBacktrace(NSException *exception) {
    NSArray *backtrace = [exception callStackSymbols];
    NSString* result = @"";
    for (NSString *str in backtrace){
        NSRange methodBeginRange = [str rangeOfString:@"["];
        NSRange methodEndRange = [str rangeOfString:@"]"];
        if (NSNotFound!=methodBeginRange.location && NSNotFound!=methodEndRange.location) {
            NSString *tmp = [str substringFromIndex:methodBeginRange.location];
            tmp = [tmp substringToIndex:methodEndRange.location-methodBeginRange.location+1];
            result = [result stringByAppendingString:tmp];
        }
    }
    return result;
}

void uncaughtExceptionHandler(NSException *exception) {
#if TARGET_IPHONE_SIMULATOR == 0
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];    NSString *logPath =
    [documentsDirectory stringByAppendingPathComponent:@"consoleCrashLogs.log"];
    freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
#endif
    
    NSString *model = [[UIDevice currentDevice] model];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *error = [NSString stringWithFormat:@"(%@|%@)%@", model, version, cleanBacktrace(exception)];
    NSLog(@"%@",error);
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}
@end