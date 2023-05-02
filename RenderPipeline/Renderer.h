//
//  ViewRenderer.h
//  RenderPipeline
//
//  Created by robertvict on 21/04/23.
//

#import <AppKit/AppKit.h>
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>

@interface Renderer : NSObject<MTKViewDelegate>
-(nonnull instancetype)initWithMetalKitView : (nonnull MTKView *)mtkView;
@end
