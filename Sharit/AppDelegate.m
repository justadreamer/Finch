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
#import "SharesHTTPConnection.h"

@interface AppDelegate()
@property (nonatomic,strong) HTTPServer* httpServer;
@property (nonatomic,strong) Reachability* reachabilityWiFi;
@property (nonatomic,strong) Reachability* reachabilityForInternet;

- (void) setupHTTPServer;
- (void) setupReachability;
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
    [self setupHTTPServer];
    [self setupReachability];
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
#pragma mark Setup HTTP Server
- (void) copyTemplateDir {
    NSString* fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[Helper templatesFolderName]];
    NSString* toPath = [[Helper instance] templatesFolder];
    NSError* error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
        NSError* error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:toPath error:&error];
        if (error)
            VLog(error);
    }
    [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:&error];
    if (error) 
        VLog(error);
}

- (void) setupHTTPServer {
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setPort:[Helper port]];
    [self.httpServer setDocumentRoot:[[Helper instance] documentsRoot]];
    [self.httpServer setConnectionClass:[SharesHTTPConnection class]];

    [self copyTemplateDir];
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

@end