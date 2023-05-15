//
//  AppDelegate.m
//  RenderPipeline
//
//  Created by robertvict on 14/04/23.
//

#import "AppDelegate.h"
#import "Mesh.h"
#import "Renderer.h"

@implementation AppDelegate
{
    //private var here
    NSWindow *_window;
    MTKView* _view;
    Renderer* _renderer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSRect frame = NSMakeRect(0, 0, 512, 512);
    //setup window
    _window = [[NSWindow alloc]
               initWithContentRect:frame
               styleMask:NSWindowStyleMaskClosable|NSWindowStyleMaskTitled
               backing:NSBackingStoreBuffered
               defer:false];
    //load data
    NSArray<Mesh*> *photons;
    NSString *filepath = @"/Users/robertvict/Documents/COMP440/MetalTest/MetalTestObjC/RenderPipeline/PhotonData/PhotonData.txt";
    [Mesh parseData:photons FromFileLocation:filepath];
    
    //setup renderer
    _view = [[MTKView alloc]
             initWithFrame:frame
             device:MTLCreateSystemDefaultDevice()];
    [_view setColorPixelFormat:MTLPixelFormatBGRA8Unorm_sRGB];
    [_view setClearColor: MTLClearColorMake(0.703, 0.812, 0.786, 1.0)];
    
    _renderer = [[Renderer alloc] initWithMetalKitView: _view];
    [_view setDelegate: _renderer];
    //assign to window
    [_window setContentView: _view];
    [_window setTitle:@"Metal Renderer"];
    [_window makeKeyAndOrderFront: nil];    //display window
}

-(bool)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return true;
}

@end
