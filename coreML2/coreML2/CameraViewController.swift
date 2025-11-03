//
//  CameraViewController.swift
//  coreML2
//
//  Created by Silstone on 24/05/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    let screenWidth = UIScreen.main.bounds.size.width
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaType.video)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevice.Position.back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        print("Capture device found")
                        beginSession()
                    }
                }
            }
        }
        
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            if(device.isLockingFocusWithCustomLensPositionSupported) {
//                device.setFocusModeLocked(lensPosition: value, completionHandler: { (time) -> Void in
//                    //
//                    print("focused")
//                })
                device.unlockForConfiguration()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch = touches.first
        let touchpoint = anyTouch?.location(in: self.view)
        let touchPercent = touchpoint!.x/screenWidth
        focusTo(value: Float(touchPercent))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let anyTouch = touches.first
        let touchpoint = anyTouch?.location(in: self.view)
        let touchPercent = touchpoint!.x/screenWidth
        focusTo(value: Float(touchPercent))
    }
    
    
    func configureDevice() {
        if let device = captureDevice {
           
            let err : NSError? = nil
            do {
                try  device.lockForConfiguration()
            }
            catch _ {
                // Error handling
                print("error: \(String(describing: err?.localizedDescription))")
            }
            device.focusMode = .locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
        
        let err : NSError? = nil
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
        }
        catch _ {
            // Error handling
            print("error: \(String(describing: err?.localizedDescription))")
        }
        
        
        if err != nil {
           
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
}
