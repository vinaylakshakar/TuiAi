//
//  ViewController.swift
//  coreML2
//
//  Created by Silstone on 15/02/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    @IBOutlet weak var nameView: UIView!
    var openCamera:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.classifier.text = "Thinking..."
        openCamera = true;
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        if(openCamera)
//        {
//        camera(self);
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addImagesAction(_ sender: UIButton)
    {
        //vinay here-
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mainViewController") as? mainViewController
        vc!.isforTraiang = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func detectPhoto()
    {
//        let imageName = "aa.jpg"
//        let image1 = UIImage(named: imageName)
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            fatalError("failed to load model")
        }
        
        //create a vision request.
        
        let request = VNCoreMLRequest(model: model) {[weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else{
                    fatalError("failed to load model")
            }
            
            // update the main UI
            DispatchQueue.main.async {
                [weak self] in
                //update label
                self?.nameView.isHidden = false;
                let myValue = Float(topResult.confidence);
                
//                if(myValue<0.70) {
//                    // number is of type Int
//                    print("please try again")
//                    self?.classifier.text = "Please try again";
//                }
//                else{
                self?.classifier.text = topResult.identifier.uppercased() + String(myValue)
//                }
                
                print(topResult.identifier)
            }
        }
        
        guard let ciImage = CIImage(image: self.cameraImageView.image!)
            else{
                fatalError("image not display")
        }
        
        // run the model
        let handler = VNImageRequestHandler(ciImage: ciImage)
        DispatchQueue.global().async {
            do
            {
                try handler.perform([request])
            }
            catch
            {
                print(error)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        
    camera(self)
    }
    
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        openCamera = false;
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         openCamera = false;
        picker.dismiss(animated: true)
        //classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        cameraImageView.image = newImage
        detectPhoto()
    }


}



