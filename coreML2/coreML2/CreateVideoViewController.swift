//
//  CreateVideoViewController.swift
//  coreML2
//
//  Created by Silstone on 24/05/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class CreateVideoViewController: UIViewController,AVCaptureFileOutputRecordingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        camera(self);
        // Do any additional setup after loading the view.
    }


    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var movieOutput = AVCaptureMovieFileOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var videoUrl:URL = URL.init(fileURLWithPath: "") // use your own url
    var frames:[UIImage] = []
    var generator:AVAssetImageGenerator!
    //vinay here-
    var category:String = ""
    
    @IBOutlet var cameraView: UIView!
    var timer = Timer()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.previewLayer.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.width+10)
        UserDefaults.standard.set(category, forKey: "modelName")
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("updateCounting")), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){
        NSLog("counting..")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.cameraView = self.view
        
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == AVCaptureDevice.Position.back{
                
                
                do{
                    
                    let input = try AVCaptureDeviceInput(device: device )
                    
                    if captureSession.canAddInput(input){
                        
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
                        
                        if captureSession.canAddOutput(sessionOutput){
                            
                            captureSession.addOutput(sessionOutput)
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            previewLayer.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(previewLayer)
                            cameraView.addSubview(createStartbutton())
                            cameraView.addSubview(createStopbutton())
                            cameraView.addSubview(createBackbutton())
                            
                            
                            previewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
//                            previewLayer.position = CGPoint(x: 224, y: 224)
                            previewLayer.bounds = cameraView.frame
                            
                            
                        }
                        
                        captureSession.addOutput(movieOutput)
                        
                        captureSession.startRunning()
                        
                        
//                        let delayTime = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(5 * Double(NSEC_PER_SEC)))
//                        dispatch_after(delayTime, dispatch_get_main_queue()) {
//                            print("stopping")
//                            self.movieOutput.stopRecording()
//                        }
                    }
                    
                }
                catch{
                    
                    print("Error")
                }
                
            }
        }
        
    }
    
@objc func pressedStop(sender: UIButton!) {
    sender.backgroundColor = UIColor.blue;
       self.movieOutput.stopRecording()
    }
    
    @objc func pressedStart(sender: UIButton!) {
        
        sender.backgroundColor = UIColor.blue;
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mov")
        try? FileManager.default.removeItem(at: fileUrl)
        movieOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    @objc func pressedBack(sender: UIButton!) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func createStopbutton() -> UIButton {
        let myFirstButton = UIButton(frame: CGRect(x: 10, y: 50, width: 100, height: 30))
        myFirstButton.setTitle("Stop", for: .normal)
        myFirstButton.backgroundColor = UIColor.lightGray;
        myFirstButton.setTitleColor(UIColor.white, for: .normal)
        myFirstButton.layer.cornerRadius = 5;
        let xPostion:CGFloat = 240
        let yPostion:CGFloat = self.view.frame.height - 120   //620
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        myFirstButton.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        myFirstButton.addTarget(self, action: #selector(pressedStop), for: .touchUpInside)
        return myFirstButton
    }
    
    func createStartbutton() -> UIButton {
        let myFirstButton = UIButton(frame: CGRect(x: 10, y: 50, width: 100, height: 30))
        myFirstButton.setTitle("Start", for: .normal)
        myFirstButton.backgroundColor = UIColor.lightGray;
         myFirstButton.layer.cornerRadius = 5;
        myFirstButton.setTitleColor(UIColor.white, for: .normal)
        let xPostion:CGFloat = 50
        let yPostion:CGFloat = self.view.frame.height - 120
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        myFirstButton.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        myFirstButton.addTarget(self, action: #selector(pressedStart), for: .touchUpInside)
        return myFirstButton
    }
    
    func createBackbutton() -> UIButton {
        let myFirstButton = UIButton(frame: CGRect(x: 10, y: 25, width: 100, height: 30))
        myFirstButton.setTitle("Back", for: .normal)
        myFirstButton.backgroundColor = UIColor.lightGray;
        myFirstButton.layer.cornerRadius = 5;
        myFirstButton.setTitleColor(UIColor.white, for: .normal)
        let xPostion:CGFloat = 10
        let yPostion:CGFloat = 25
        let buttonWidth:CGFloat = 100
        let buttonHeight:CGFloat = 30
        
        myFirstButton.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        myFirstButton.addTarget(self, action: #selector(pressedBack), for: .touchUpInside)
        return myFirstButton
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            self.videoUrl = outputFileURL
            self.getAllFrames()
        }
        
    }

    
    
    

    
    func getAllFrames() {
        let asset:AVAsset = AVAsset(url:self.videoUrl)
        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        self.generator = AVAssetImageGenerator(asset:asset)
        self.generator.appliesPreferredTrackTransform = true
        self.frames = []
        for index:Int in 0 ..< Int(duration) {
            self.getFrame(fromTime:Float64(index))
        }
        //push to next page
        self.generator = nil
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowAllImagesViewController") as? ShowAllImagesViewController
        vc!.framesImages = self.frames;
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func getFrame(fromTime:Float64) {
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, 600)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            return
        }
        let generateImage:UIImage = resizeImage(image: UIImage(cgImage:image), targetSize: CGSize(width: 224,height: 224))
        self.frames.append(generateImage)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio < heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
