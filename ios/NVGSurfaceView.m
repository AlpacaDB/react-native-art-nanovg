/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NVGSurfaceView.h"
#import "NVGContext.h"

#import "NVGNode.h"
#import <React/RCTLog.h>

@implementation NVGSurfaceView
{
    RCTBridge *_bridge;

    NVGcontext* vg;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  if ((self = [super init])) {
    _bridge = bridge;
    self.context = [bridge.nvgContext getContext];
    self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    self.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    self.opaque = FALSE;
    
    vg = [bridge.nvgContext getNVGContext];
  }
  return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex
{
  [super insertReactSubview:subview atIndex:atIndex];
  [self insertSubview:subview atIndex:atIndex];
  [self invalidate];
}

- (void)removeReactSubview:(UIView *)subview
{
  [super removeReactSubview:subview];
  [self invalidate];
}

- (void)didUpdateReactSubviews
{
  // Do nothing, as subviews are inserted by insertReactSubview:
}

- (void)invalidate
{
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  assert(vg);

  glClearColor(0, 0, 0, 0);
  glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_CULL_FACE);
  glDisable(GL_DEPTH_TEST);
  
  int winWidth = self.frame.size.width;
  int winHeight = self.frame.size.height;
  
  nvgBeginFrame(vg, winWidth, winHeight, [[UIScreen mainScreen] scale]);

  for (NVGNode *node in self.subviews) {
    [node renderTo:vg];
  }
  
  nvgEndFrame(vg);
}

- (void)reactSetInheritedBackgroundColor:(UIColor *)inheritedBackgroundColor
{
  // this keeps Surface transparent
  self.backgroundColor = [UIColor clearColor];
}

@end
