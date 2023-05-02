//
//  main.m
//  RenderPipeline
//
//  Created by robertvict on 14/04/23.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApp = [NSApplication sharedApplication];
        AppDelegate *AppDel = [[AppDelegate alloc] init];//iissue here
        [NSApp setDelegate: AppDel];
        [NSApp run];
    }
    return 0;
}
