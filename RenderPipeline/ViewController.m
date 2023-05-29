//
//  ViewController.m
//  RenderPipeline
//
//  Created by robertvict on 18/05/23.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"
#import "ViewController.h"
#import "CameraController.h"

@implementation ViewController
{
    MTKView *_view;
    Renderer *_renderer;
    
    bool _update_view_mat;
    NSPoint _current_mouse_pos;
    NSPoint _prev_mouse_pos;
    CameraController *_cam_controller;
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
    
    _update_view_mat = true;
    //initialise mouse position
    _current_mouse_pos = NSZeroPoint;
    _prev_mouse_pos = NSZeroPoint;
    _cam_controller = [[CameraController alloc] init];
    
    //set up renderer
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
    //update view if needed
    if(_update_view_mat) {
        //lookat;
        simd_float4x4 view = [CameraController calcLookFromEye:[_cam_controller getCamPos]
                                                      AtCentre:simd_make_float3(0.0f)
                                                        WithUp:simd_make_float3(0.0f, 1.0f, 0.0f)];
        [_renderer updateView: view];
        _update_view_mat = false;
    }
    [_renderer drawToView: view];
}

//add keyboard and mouse support here
-(bool) becomeFirstResponder
{
    return true;
}

-(void)mouseDragged:(NSEvent *)event
{
    NSPoint new_mouse_pos = NSEvent.mouseLocation;
    _update_view_mat = true;
        
    _prev_mouse_pos = _current_mouse_pos;
    _current_mouse_pos = new_mouse_pos;
    //update camera transformation
    NSPoint offset = NSMakePoint(event.deltaX, event.deltaY);
    [_cam_controller updateAngles:offset];
}

@end
