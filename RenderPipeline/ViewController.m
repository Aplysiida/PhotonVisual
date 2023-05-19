//
//  ViewController.m
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"
#import "ViewController.h"

@implementation ViewController
{
    MTKView *_view;
    Renderer *_renderer;
}

-(void) loadView
{
    NSRect frame = NSMakeRect(0, 0, 512, 512);
    _view = [[MTKView alloc]
             initWithFrame:frame
             device:MTLCreateSystemDefaultDevice()];
    _view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
    _view.clearColor = MTLClearColorMake(0.703, 0.812, 0.786, 1.0);
    
    self.view = _view;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    _renderer = [[Renderer alloc] initWithMetalKitView:_view];
    [_renderer mtkView:_view drawableSizeWillChange:_view.drawableSize];
    
    //load data
    NSArray * args = [[NSProcessInfo processInfo] arguments];
    NSString *filepath = args[1];   //get filepath as argument
    NSArray *photons = [Mesh parseDataFromFileLocation:filepath];
    
    [_renderer loadMetalWithMeshes:photons];
    
    _view.delegate = self;
}

-(void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    [_renderer mtkView:view drawableSizeWillChange:size];
}

-(void)drawInMTKView:(MTKView *)view
{
    [_renderer drawToView: view];
}

//add keyboard and mouse support here

@end
