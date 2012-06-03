//
//  AppDelegate.m
//  Sharit
//
//  Created by Eugene Dorfman on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPServer.h"
#import "ViewController.h"
#import "Helper.h"
#import "Reachability.h"
#import "SharesProvider.h"
#import "MainHTTPConnection.h"
#import "GlobalDefaults.h"

@interface AppDelegate()
@property (nonatomic,strong) HTTPServer* httpServer;
@property (nonatomic,strong) Reachability* reachabilityWiFi;
@property (nonatomic,strong) Reachability* reachabilityForInternet;

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.viewController.sharesProvider = [SharesProvider instance];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    //setup dirs needs to be beofre setupHTTPServer
    [self setupDirs];
    [self setupHTTPServer];
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
    [self.viewController refresh];
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
    [self copyResDir:[GlobalDefaults templatesFolderName] toDir:[[Helper instance] templatesFolder]];
}

- (void) copyDocroot {
    [self removePrevItemsForBase:[[Helper instance] baseDocrootFolder]];
    [self copyResDir:[GlobalDefaults docrootFolderName] toDir:[[Helper instance] docrootFolder]];
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
@end