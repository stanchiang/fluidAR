//
//  SessionHandler.swift
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 15.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

import AVFoundation

class CameraHandler : NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate, CVFImageProcessorDelegate {
    var session = AVCaptureSession()
    let layer = AVSampleBufferDisplayLayer()
    let sampleQueue = DispatchQueue(label: "com.stan.fluidAR.sampleQueue", attributes: [])
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var faceDetect = CVFFaceDetect()
    
    var delaunay:NSMutableArray = NSMutableArray()
    
    override init() {
        super.init()
        faceDetect.delegate = self
        delaunay.add([1,2])
        delaunay.add([3,4])
    }
    
    func openSession() {
        let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        
        let input = try! AVCaptureDeviceInput(device: device)
        
        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: sampleQueue)
        
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.sessionPreset = AVCaptureSessionPresetHigh
        session.commitConfiguration()
        
        let settings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCVPixelFormatType_32BGRA)]
        output.videoSettings = settings
        
        session.startRunning()
    }
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        faceDetect.processImageBuffer(pixelBuffer, withMirroring: false)
    }
    
    func mouthVerticePositions(_ vertices: NSMutableArray!) {
        //parse new mouth location and shape from nsmutable array vertices
        appDelegate.mouth = vertices.map({($0 as AnyObject).cgPointValue})
    }
    
    func imageProcessor(_ imageProcessor: CVFImageProcessor!, didCreateImage image: UIImage!) {
        (appDelegate.window?.rootViewController as! GameGallery).cameraImage.image = image
    }
    
    func adjustPPI() -> CGFloat {
        return (appDelegate.window?.rootViewController as! GameGallery).debugView.getAdjustedPPI()
    }
    
    func showFaceDetect() -> Bool {
        return true
    }

    func noseBridgePosition(_ position: CGPoint) {
        appDelegate.noseBridge = position
    }
    
    func mustachePosition(_ position: CGPoint) {
        appDelegate.mustache = position
    }
    
    func noseTipPosition(_ position: CGPoint) {
        appDelegate.noseTip = position
    }
    
    func hasDetectedFace(_ found: Bool) {
        
    }
}
