//
//  mainViewController.swift
//  coreML2
//
//  Created by Silstone on 24/05/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AWSRekognition
import AVFoundation
import Alamofire
import AWSCore
import AWSAPIGateway


class mainViewController: UIViewController {
    //Declaring capture session
    //vinay here-
    var mycapturedimage = UIImage()
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var error: NSError?
    let client = TUITrainingschedulerClient.default()
    var isforTraiang : Bool = false
    @IBOutlet var returnlbl: UILabel!
    @IBOutlet var captureImageBtn: UIButton!
    @IBOutlet var doneBtn: UIButton!
    var category:String = ""
    
    
    @IBOutlet weak var cameraView: UIView!
    
    
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if isforTraiang {
            self.doneBtn.isHidden = false
        }
        
        //Camera starting function
        self.startingTheCam()
       // self.testingAi()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneBtnAction(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateVideoViewController") as? CreateVideoViewController
        vc?.category =  self.category
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
//    func testingAi()
//    {
//        let image = UIImage(named: "images.jpeg")
//        //  let imgData = UIImageJPEGRepresentation(image!, 0.2)!
//        let imageData = UIImagePNGRepresentation(image!)
//        // let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        // let parameters = ["name": rname] //Optional for extra parameter
//        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
//
//        let json: [String: Any] = ["base64": strBase64,"endpoint": "testEndpoint"]
//
//        APIManager.sharedInstance.invokeModel(dic: json, onSuccess: { json in
//            DispatchQueue.main.async {
//                print(String(describing: json))
//            }
//        }, onFailure: { error in
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.show(alert, sender: nil)
//        })
//    }
    
    
    //MARK: - Starting the camera
    func startingTheCam(){
        
        //Set session preset
        captureSession.sessionPreset = .photo
        
        //Capturing Device
        guard let capturingDevice = AVCaptureDevice.default(for: .video) else { return }
        
        //Capture Input
        guard let capturingInput = try? AVCaptureDeviceInput(device: capturingDevice) else { return }
        
        //Adding input to capture session
        captureSession.addInput(capturingInput)
        
        //Data output
        let cameraDataOutput = AVCaptureVideoDataOutput()
        cameraDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "outputVideo"))
        captureSession.addOutput(cameraDataOutput)
        
        //Construct a camera preview layer
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //Set the frame
        cameraPreviewLayer.frame = cameraView.bounds
        
        //Add this preview layer to sublayer of view
        cameraView.layer.addSublayer(cameraPreviewLayer)
        
        //Start the session
        captureSession.startRunning()
        
    }
    
    //vinay here-
    
    func reko(sampleBuffer : CMSampleBuffer) {
        let rekognitionClient = AWSRekognition.default()
        //let sourceImage = UIImage(named: "aa.jpg")
       // let sourceImage = mycapturedimage
        
        
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(mycapturedimage, 0.7)
        
        guard let request = AWSRekognitionDetectLabelsRequest() else {
            puts("Unable to initialize AWSRekognitionDetectLabelsRequest.")
            return
        }
        
        request.image = image
        request.maxLabels = 1
        request.minConfidence = 90
        
        
        rekognitionClient.detectLabels(request) { (response:AWSRekognitionDetectLabelsResponse?, error:Error?) in
            if error == nil {
                if ((response!.labels?.count)! > 0){
                    
                    //2. Celebrities were found. Lets iterate through all of them
                    for (index, celebFace) in response!.labels!.enumerated(){
                        
                        //Check the confidence value returned by the API for each celebirty identified
                        if(celebFace.confidence!.intValue > 80){ //Adjust the confidence value to whatever you are comfortable with
                            
                            //We are confident this is celebrity. Lets point them out in the image using the main thread
                            DispatchQueue.main.async {
                                if(celebFace.confidence!.intValue > Int(0.5))
                                {
                                    print(celebFace.confidence!.intValue, celebFace.name!)
//                                    self.descLabel.text = String(format: "%.2f%% %@", celebFace.confidence!.floatValue, celebFace.name!)
//                                    self.category = celebFace.name!
//                                    self.uploadImage(endPoint: celebFace.name!)
                                    
                                    //vinay here-
                                    self.descLabel.text = String(format: "%.2f%% %@", celebFace.confidence!.floatValue, "tuwi")
                                    self.category = "tuwi"
                                    self.uploadImage(endPoint: "tuwi")
                                    
                                    //self.invok()
                                    self.captureImageBtn.isEnabled = true
                                    self.captureSession.startRunning()
                                    self.captureSession.removeOutput(self.stillImageOutput)
                                }
                                
                            }
                        }else
                        {
                            DispatchQueue.main.async {
                                self.descLabel.text = "Nothing Detected! Please try again."
                                self.returnlbl.text = ""
                                self.captureImageBtn.isEnabled = true
                                self.captureSession.startRunning()
                                self.captureSession.removeOutput(self.stillImageOutput)
                            }
                        }
                        
                    }
                }else
                {
                    DispatchQueue.main.async {
                        self.descLabel.text = "Nothing Detected! Please try again."
                        self.returnlbl.text = ""
                        self.captureImageBtn.isEnabled = true
                        self.captureSession.startRunning()
                        self.captureSession.removeOutput(self.stillImageOutput)
                    }
                }
                print("response ",response as Any)
                
                
            }
            
            
        }
    }
    
//    func invok()
//    {
//        client.invokeEndpointPost(endpoint: "PcEndpoint").continueWith{ (task: AWSTask?) -> AnyObject? in
//            if let error = task?.error {
//                print("Error occurred: \(error)")
//                return nil
//            }
//
//            if (task?.result) != nil {
//                // Do something with result
//            }
//
//            return nil
//        }
//
//    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, _: false, _: 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func uploadImage(endPoint : String)
    {
        //let image = mycapturedimage
        let image = resizeImage(image: mycapturedimage, targetSize: CGSize(width: 448.0, height: 596.0))
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
       // let imageData = UIImagePNGRepresentation(image)
        // let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        // let parameters = ["name": rname] //Optional for extra parameter
        let strBase64 = imgData.base64EncodedString(options: .lineLength64Characters)
        
        let endPointStr = "\(endPoint)\("Endpoint")"
        let json: [String: Any] = ["base64": strBase64,"endpoint": endPointStr]
        
        APIManager.sharedInstance.invokeModel(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
                let dict = self.convertToDictionary(text: (String(describing: json)))
                if (dict?.values.isEmpty)!
                {
                    self.returnlbl.text = "Object not found! Please try again."
                }else
                {
                    //self.returnlbl.text = dict?["Index"] as? String
                    //self.GetIndexObject(index: dict?["Index"] as! String)
                    DispatchQueue.main.async {
                       // self.GetIndexObject(index: dict?["Index"] as! String)
                        self.GetIndexObject(index: dict?["Index"] as! String, name: endPoint)
                    }
                }
                
                
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    func GetIndexObject(index : String,name : String)
    {
        
        let json: [String: Any] = ["model_name": name]
        
        APIManager.sharedInstance.GetIndexObject(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
                let dict = self.convertToDictionary(text: (String(describing: json)))
                if (dict?.values.isEmpty)!
                {
                    self.returnlbl.text = "Object not found! Please try again."
                }else
                {
                   // self.returnlbl.text = index
                    let modelArray = dict?["objects"] as? NSArray
                    let str = modelArray![NSInteger(index)!] as! String
//                    let arr = str.components(separatedBy: "/")
                    self.returnlbl.text = str
                }
                
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    //method 2-
//    func uploadwithJSONSerialization() {
//        let image = UIImage(named: "aa.jpg")
//        let dataImage = UIImagePNGRepresentation(image!)
//        let strBase64 = dataImage!.base64EncodedString(options: .lineLength64Characters)
//
//        let parameters = ["endpoint" : "testEndpoint","data":strBase64]
//
//        var error: Error? = nil
//        var jsonData: Data? = nil
//        do {
//            jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//        }
//
//        var request = NSMutableURLRequest()
//        request.url = URL(string: "https://fzs6c31wf7.execute-api.eu-west-1.amazonaws.com/api/invoke")
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = jsonData
//
//        var urlResponse: URLResponse? = nil
//        var receivedData: Data? = nil
//        do {
//            receivedData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &urlResponse)
//        } catch {
//        }
//
//        var jsonParsingError: Error? = nil
//        var responseJson: [AnyHashable : Any]? = nil
//        do {
//            responseJson = try JSONSerialization.jsonObject(with: receivedData!, options: []) as? [AnyHashable : Any]
//        } catch let jsonParsingError {
//        }
//        let length = responseJson?.count
//        print(String(format: "%lu", UInt(length ?? 0)))
//        if length == 0 {
//            print("Failed to upload")
//        }
//    }
    
//    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
//    {
//        // Get a CMSampleBuffer's Core Video image buffer for the media data
//        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        // Lock the base address of the pixel buffer
//        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//
//        // Get the number of bytes per row for the pixel buffer
//        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
//
//        // Get the number of bytes per row for the pixel buffer
//        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
//        // Get the pixel buffer width and height
//        let width = CVPixelBufferGetWidth(imageBuffer!);
//        let height = CVPixelBufferGetHeight(imageBuffer!);
//
//        // Create a device-dependent RGB color space
//        let colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        // Create a bitmap graphics context with the sample buffer data
//        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
//        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
//        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
//        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
//        // Create a Quartz image from the pixel data in the bitmap graphics context
//        let quartzImage = context?.makeImage();
//        // Unlock the pixel buffer
//        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//
//        // Create an image object from the Quartz image
//        let image = UIImage.init(cgImage: quartzImage!);
//
//        return (image);
//    }
    @IBAction func captureImage(_ sender: UIButton)
    {
        print("image capture")
        sender.isEnabled = false
        self.descLabel.text = "Processing.."
        self.returnlbl.text = ""
        capturePicture()
//        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
//            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
//                (imageDataSampleBuffer, error) -> Void in
//                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!)
//                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData!)!, nil, nil, nil)
//            }
//        }
    }
    func capturePicture(){
        
        //println("Capturing image")
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.addOutput(stillImageOutput)
        
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                
//                var imageView = UIImageView(image: image)
//                imageView.frame = CGRect(x:0, y:0, width:self.screenSize.width, height:self.screenSize.height)
//
//                //Show the captured image to
//                self.view.addSubview(imageView)
                
                //Save the captured preview to image
                self.captureSession.stopRunning()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                self.mycapturedimage = image
                self.reko(sampleBuffer: sampleBuffer!)
            })
        }
    }

}




extension mainViewController: AVCaptureVideoDataOutputSampleBufferDelegate
{
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        
    }
//    {
//        //vinay here-
//        let ts:CMTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
//        mycapturedimage = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
//        reko(sampleBuffer: sampleBuffer)
//    }
//    {
//
//
//        //Get pixel buffer
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//
//        }
//
//        //get model
//        guard let resNetModel = try? VNCoreMLModel(for: Resnet50().model) else { return }
//
//        //Create a coreml request
//        let requestCoreML = VNCoreMLRequest(model: resNetModel) { (vnReq, err) in
//
//            //handling error and request
//
//            DispatchQueue.main.async {
//                if err == nil{
//
//                    guard let capturedRes = vnReq.results as? [VNClassificationObservation] else { return }
//
//                    guard let firstObserved = capturedRes.first else { return }
//
//
//
//                    if(firstObserved.confidence>0.5)
//                    {
//                     print(firstObserved.identifier, firstObserved.confidence)
//                    self.descLabel.text = String(format: "This may be %.2f%% %@", firstObserved.confidence, firstObserved.identifier)
//                    }
//
//                }
//
//            }
//
//        }
//
//
//        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([requestCoreML])
//
//    }
    
    
}



