//
//  AppDelegate.m
//  RenderPipeline
//
//  Created by robertvict on 14/04/23.
//

#import "AppDelegate.h"
#import "Mesh.h"
#import "Renderer.h"
#import "ViewController.h"

@implementation AppDelegate
{
    //private var here
    NSWindow *_window;
    ViewController *_view_controller;
    //MTKView* _view;
    //Renderer* _renderer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSRect frame = NSMakeRect(0, 0, 512, 512);
    //setup window
    _window = [[NSWindow alloc]
               initWithContentRect:frame
               styleMask:NSWindowStyleMaskClosable|NSWindowStyleMaskTitled|NSWindowStyleMaskResizable
               backing:NSBackingStoreBuffered
               defer:false];
    
    //setup renderer
    _view_controller = [[ViewController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
    [_view_controller view];
    
    //assign to window
    [_window setContentViewController: _view_controller];
    [_window setTitle:@"Metal Renderer"];
    [_window makeKeyAndOrderFront: nil];    //display window
}

-(bool)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return true;
}

@end
