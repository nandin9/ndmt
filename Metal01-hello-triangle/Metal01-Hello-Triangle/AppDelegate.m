//
//  AppDelegate.m
//  Metal01-Hello-Triangle
//
//  Created by nanding01 on 2025/6/24.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSRect frame = NSMakeRect(0, 0, 800, 600);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled |
                                                          NSWindowStyleMaskClosable |
                                                          NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    self.window.title = @"Metal Triangle";

    ViewController *vc = [[ViewController alloc] init];
    self.window.contentViewController = vc;
    [self.window makeKeyAndOrderFront:nil];
}

@end
