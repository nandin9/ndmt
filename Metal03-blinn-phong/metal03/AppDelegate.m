//
//  AppDelegate.m
//  metal03
//
//  Created by nanding01 on 2025/6/29.
//

#import "AppDelegate.h"
#import "MetalView.h"

@interface AppDelegate ()
@property (strong) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // 创建主窗口
    NSRect frame = NSMakeRect(0, 0, 800, 600);
    self.window = [[NSWindow alloc] initWithContentRect:frame
                                               styleMask:(NSWindowStyleMaskTitled |
                                                          NSWindowStyleMaskClosable |
                                                          NSWindowStyleMaskResizable)
                                                 backing:NSBackingStoreBuffered
                                                   defer:NO];
    [self.window setTitle:@"Metal Shader App"];
    [self.window makeKeyAndOrderFront:nil];

    // 设置 MetalView 作为主视图
    self.window.contentView = [[MetalView alloc] initWithFrame:self.window.contentView.bounds];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
