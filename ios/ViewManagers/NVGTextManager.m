/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NVGTextManager.h"

#import "NVGText.h"
#import "RCTConvert+NVG.h"

@implementation NVGTextManager

RCT_EXPORT_MODULE()

- (NVGRenderable *)node
{
  return [NVGText new];
}

RCT_EXPORT_VIEW_PROPERTY(alignment, CTTextAlignment)
RCT_REMAP_VIEW_PROPERTY(frame, textFrame, NVGTextFrame)

@end
