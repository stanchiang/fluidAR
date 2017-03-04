//
//  CVFImageProcessorDelegate.h
//  CVFunhouse
//
//  Created by John Brewer on 3/7/12.
//  Copyright (c) 2012 Jera Design LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CVFImageProcessor;

@protocol CVFImageProcessorDelegate <NSObject>

-(void) imageProcessor:(CVFImageProcessor*)imageProcessor didCreateImage:(UIImage*)image;
-(void) mouthVerticePositions:(NSMutableArray *)vertices;
-(CGFloat) adjustPPI;
-(bool) showFaceDetect;
-(void) noseBridgePosition: (CGPoint) position;
-(void) noseTipPosition: (CGPoint) position;
-(void) mustachePosition: (CGPoint) position;
-(void) hasDetectedFace: (bool) found;
@end
