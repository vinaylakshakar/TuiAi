//
//  AWSRekoViewController.swift
//  coreML2
//
//  Created by Silstone on 28/05/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import AWSRekognition
import SwiftyJSON

class AWSRekoViewController: UIViewController {

    var selectedframesImages:[UIImage] = []
   
    var category:String = ""
    @IBOutlet weak var lbl: UITextField!
    @IBOutlet weak var textFld: UITextField!
    @IBOutlet var trainingJobField: UITextField!
    @IBOutlet var s3OutputPathField: UITextField!
    @IBOutlet var s3InputPathTraining: UITextField!
    @IBOutlet var s3InputPathValidation: UITextField!
    @IBOutlet var numClassField: UITextField!
    @IBOutlet var numTrainingSamplesField: UITextField!
    @IBOutlet var miniBatchSizeField: UITextField!
    @IBOutlet var s3InputPathTraininglst: UITextField!
    @IBOutlet var s3InputPathValidationlst: UITextField!
   
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var trainPathImagesNoField: UITextField!
    @IBOutlet var trainpathField: UITextField!
    @IBOutlet var validationPathImagesField: UITextField!
    @IBOutlet var validationPathField: UITextField!
    @IBOutlet var epochsField: UITextField!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var trainingInputModeField: UITextField!
    @IBOutlet var use_pretrained_modelField: UITextField!
    @IBOutlet var InstanceCountField: UITextField!
    @IBOutlet var InstanceTypeField: UITextField!
    @IBOutlet var num_layersField: UITextField!
    @IBOutlet var learning_rateField: UITextField!
    @IBOutlet var image_shapeField: UITextField!
    @IBOutlet var top_kField: UITextField!
    
    @IBOutlet var model_nameField: UITextField!
    @IBOutlet var training_job_nameField: UITextField!
    @IBOutlet var S3ModelArtifactsField: UITextField!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @objc var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    @objc var progressBlock: AWSS3TransferUtilityProgressBlock?
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    @objc lazy var AmazonS3 = {
        AWSS3.default()
    }()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 2100)
        containerView.frame =  CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 2100)
        
        //let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        activityView.center = view.center
        //activityView.startAnimating()
        view.addSubview(activityView)
        //activityView.startAnimating()
    
//        scheduledTimerWithTimeInterval(interval: 10.0)
        
        //vinay here-
        //reko()
        //self.lbl.text = UserDefaults.standard.string(forKey: "modelName")
        self.lbl.text = "tuwi"
        
    }
    
    func scheduledTimerWithTimeInterval(interval: TimeInterval){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval:interval,
                                     target: self,
                                     selector: #selector(updateCounting),
                                     userInfo: [ "foo" : "bar" ],
                                     repeats: false)
    }
    
    @objc func updateCounting(){
        NSLog("counting..")
        activityView.stopAnimating()
        timer.invalidate()
    }
    
    @IBAction func back(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func ApiCall(_ sender: UIButton)
    {
        
        sender.backgroundColor = UIColor.blue;
        
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 600.0)
//     let cate = "\(self.lbl.text ?? "")"
//     let S3OutputPath = "s3://userdatasetupload/\(self.lbl.text ?? "")/output"
//     let S3InputPathTraining = "s3://userdatasetupload/\(self.lbl.text ?? "")/train"
//     let S3InputPathValidation = "s3://userdatasetupload/\(self.lbl.text ?? "")/validation"
//     let num_classes = "1"
//     let num_training_samples = String(self.selectedframesImages.count)
//
        
//         let json: [String: Any] = ["TrainingJobName": cate,
//                                    "S3OutputPath": S3OutputPath,
//                                    "S3InputPathTraining": S3InputPathTraining,
//                                    "S3InputPathValidation": S3InputPathValidation,
//                                    "num_classes": num_classes,
//                                    "num_training_samples": num_training_samples,
//                                    "resize": "224",
//                                    "RoleArn": "arn:aws:iam::204716791960:role/service-role/AmazonSageMaker-ExecutionRole-20190614T024353",
//                                    "mini_batch_size": num_training_samples]
        //vinay here-
        let json: [String: Any] = ["TrainingJobName": trainingJobField.text!,
                                   "S3OutputPath": s3OutputPathField.text!,
                                   "S3InputPathTraining": s3InputPathTraining.text!,
                                   "S3InputPathValidation": s3InputPathValidation.text!,
                                   "S3InputPathTrainingLst": s3InputPathTraininglst.text!,
                                   "S3InputPathValidationLst": s3InputPathValidationlst.text!,
                                   "num_classes": numClassField.text!,
                                   "num_training_samples": numTrainingSamplesField.text!,
                                   "epochs": epochsField.text!,
                                   "resize": "256",
                                   "RoleArn": "arn:aws:iam::204716791960:role/service-role/AmazonSageMaker-ExecutionRole-20190614T024353",
                                   "mini_batch_size": miniBatchSizeField.text!,                               "name":nameField.text!,                 "TrainingImage":"685385470294.dkr.ecr.eu-west-1.amazonaws.com/image-classification:latest",
                                   "TrainingInputMode":trainingInputModeField.text!,
                                   "use_pretrained_model":use_pretrained_modelField.text!,
                                   "InstanceCount":InstanceCountField.text!,
                                   "InstanceType":InstanceTypeField.text!,
                                   "VolumeSizeInGB":"50",
                                   "num_layers":num_layersField.text!,
                                   "learning_rate":learning_rateField.text!,
                                   "image_shape":image_shapeField.text!,
                                   "top_k":top_kField.text!
        ]
        
        APIManager.sharedInstance.startTraining(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })

//        APIManager.sharedInstance.getData(onSuccess: { json in
//            DispatchQueue.main.async {
//               print(String(describing: json))
//            }
//        }, onFailure: { error in
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.show(alert, sender: nil)
//        })
    }
    @IBAction func genrateTrainPath(_ sender: UIButton)
    {
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 90.0)
        
        sender.backgroundColor = UIColor.blue;
        let json: [String: Any] = ["file_path": trainpathField.text!,
                                   "num_files": trainPathImagesNoField.text!]
        
        APIManager.sharedInstance.generateTrainPath(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    @IBAction func generateValidationPath(_ sender: UIButton)
    {
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 90.0)
        
        sender.backgroundColor = UIColor.blue;
        let json: [String: Any] = ["file_path": validationPathField.text!,
                                   "num_files": validationPathImagesField.text!]
        
        APIManager.sharedInstance.generateValidationPath(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    @IBAction func generateTrainLst(_ sender: UIButton)
    {
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 5.0)
        
        sender.backgroundColor = UIColor.blue;
        var trainPath = "\(self.lbl.text!) \("train") "
        trainPath = (trainPath.replacingOccurrences(of: " ", with: "/"))

        let json: [String: Any] = ["file_path": trainPath]
        
        APIManager.sharedInstance.generateLst(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    
    @IBAction func generateValidationLst(_ sender: UIButton)
    {
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 5.0)
        
        sender.backgroundColor = UIColor.blue;
        var validationPath = "\(self.lbl.text!) \("validation") "
        validationPath = (validationPath.replacingOccurrences(of: " ", with: "/"))
        
        let json: [String: Any] = ["file_path": validationPath]
        
        APIManager.sharedInstance.generateLst(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    @IBAction func autofillAction(_ sender: UIButton)
    {
        sender.backgroundColor = UIColor.blue;
        self.GetIndexObject(name: self.lbl.text!)
        //scheduledTimerWithTimeInterval(interval: 30)
        
        self.trainpathField.text = "\(self.lbl.text!)  \("train")  \(self.textFld.text!)"
        self.trainpathField.text = self.trainpathField.text?.replacingOccurrences(of: "  ", with: "/")
        
        self.validationPathField.text = "\(self.lbl.text!)  \("validation")  \(self.textFld.text!)"
        self.validationPathField.text = self.validationPathField.text?.replacingOccurrences(of: "  ", with: "/")
        
        self.s3OutputPathField.text = "\(self.s3OutputPathField.text!)  \(self.lbl.text!)  \("output")"
        self.s3OutputPathField.text = self.s3OutputPathField.text?.replacingOccurrences(of: "  ", with: "/")
        
        self.s3InputPathTraining.text = "\(self.s3InputPathTraining.text!)  \(self.lbl.text!)  \("train")"
        self.s3InputPathTraining.text = self.s3InputPathTraining.text?.replacingOccurrences(of: "  ", with: "/")
        self.s3InputPathValidation.text = "\(self.s3InputPathValidation.text!)  \(self.lbl.text!)  \("validation")"
        self.s3InputPathValidation.text = self.s3InputPathValidation.text?.replacingOccurrences(of: "  ", with: "/")
        
        self.s3InputPathTraininglst.text = "\(self.s3InputPathTraininglst.text!)  \(self.lbl.text!)  \("train_lst")"
        self.s3InputPathTraininglst.text = self.s3InputPathTraininglst.text?.replacingOccurrences(of: "  ", with: "/")
        
        self.s3InputPathValidationlst.text = "\(self.s3InputPathValidationlst.text!)  \(self.lbl.text!)  \("validation_lst")"
        self.s3InputPathValidationlst.text = self.s3InputPathValidationlst.text?.replacingOccurrences(of: "  ", with: "/")
        
        
        let calendar = NSCalendar.current
        let startDate : Date = Date()
        let componetsThatWeWant = calendar.dateComponents([.year, .day, .month, .hour, .minute], from: startDate)
        
        self.trainingJobField.text = "\(self.lbl.text!)\(componetsThatWeWant.year!)\(componetsThatWeWant.month!)\(componetsThatWeWant.day!)\(componetsThatWeWant.hour!)\(componetsThatWeWant.minute!)"
        print(self.trainingJobField.text!)
        
        self.training_job_nameField.text = self.trainingJobField.text
        self.model_nameField.text = self.lbl.text
        self.S3ModelArtifactsField.text = "\(self.S3ModelArtifactsField.text!)  \(self.lbl.text!)  \("output")  \(self.trainingJobField.text!)  \("output")  "
        self.S3ModelArtifactsField.text = self.S3ModelArtifactsField.text?.replacingOccurrences(of: "  ", with: "/")
        
        
    }
    
    func GetIndexObject(name : String)
    {
        
        let json: [String: Any] = ["model_name": name]
        
        APIManager.sharedInstance.GetIndexObject(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
                let dict = self.convertToDictionary(text: (String(describing: json)))
                if (dict?.values.isEmpty)!
                {
                   // self.returnlbl.text = "Object not found! Please try again."
                }else
                {
                    // self.returnlbl.text = index
                    var noOfClasses = dict?["number_of_classes"] as? NSInteger
                    self.numClassField.text = "\(String(describing: noOfClasses!))"
                    noOfClasses = 200 * noOfClasses!
                    //                    let arr = str.components(separatedBy: "/")
                    self.numTrainingSamplesField.text = "\(String(describing: noOfClasses!))"
                }
                
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    @IBAction func deleteEndPoint(_ sender: UIButton)
    {
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 5.0)
        
        sender.backgroundColor = UIColor.blue;
        let json: [String: Any] = ["model_name": self.lbl.text!]
        
        APIManager.sharedInstance.deleteEndPoint(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
                let dict = self.convertToDictionary(text: (String(describing: json)))
                if (dict?.values.isEmpty)!
                {
                    // self.returnlbl.text = "Object not found! Please try again."
                }else
                {
                    // self.returnlbl.text = index
                    
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
    
    @IBAction func uploadImages(_ sender: UIButton) {
       
        sender.backgroundColor = UIColor.blue;
        print(S3ModelArtifactsField.text!)
        
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 10.0)
        
        let splitNumber = self.selectedframesImages.count/2 as NSInteger
        var index = 0;
        
        for item in self.selectedframesImages {
             createOutputFolder()
            
            if index<splitNumber
            {
                uploadImageForValidation(with: item)
            }else
            {
                uploadImageForTraining(with: item)
            }
            
            index+=1
            
        }
    }
    
    func reko() {
        let rekognitionClient = AWSRekognition.default()
        //        let sourceImage = UIImage(named: "aa.jpg")
        let sourceImage = selectedframesImages.last
        
        let image = AWSRekognitionImage()
        image!.bytes = UIImageJPEGRepresentation(sourceImage!, 0.7)
        
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
                        if(celebFace.confidence!.intValue > 90){ //Adjust the confidence value to whatever you are comfortable with
                            
                            //We are confident this is celebrity. Lets point them out in the image using the main thread
                            DispatchQueue.main.async {
                                [weak self] in
                                if(self?.category != "")
                                {
                                    self!.category  =  self!.category + " , " + celebFace.name!
                                    self!.lbl.isHidden = false
                                    self?.lbl.text = self!.category
                                }
                                else
                                {
                                    self!.category  =  celebFace.name!
                                    self!.lbl.isHidden = false
                                    self?.lbl.text = self!.category.replacingOccurrences(of: " ", with: "")
//                                    self?.trainpathField.text = "\(celebFace.name!) \("train") \(self!.category)"
//                                    self?.trainpathField.text = self?.trainpathField.text?.replacingOccurrences(of: " ", with: "\\")
                                }
                                
                                
                                //Create an instance of Celebrity. This class is availabe with the starter application you downloaded
                            }
                        }
                        
                    }
                }
                print("response ",response as Any)
            }
        }
    }
    
    
    
    
    @objc func uploadImageForTraining(with image: UIImage) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        var name = randomString(length: 5)
       
        name = "/\(name).png"
        let cate = "\(self.lbl.text ?? "")"
        let training = "/train"
        let subCategory = "/\(self.textFld.text ?? "")"
        name = cate + training + subCategory + name
        DispatchQueue.main.async(execute: {
            //self.statusLabel.text = ""
            //self.progressView.progress = 0
        })
        let imageData = UIImagePNGRepresentation(image)
        transferUtility.uploadData(imageData!, bucket: "userdatasetupload", key: name, contentType: "image/png", expression: expression,
                                   completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                        
                                        DispatchQueue.main.async {
                                            //self.statusLabel.text = "Failed"
                                        }
                                    }
                                    
                                    if let _ = task.result {
                                        
                                        DispatchQueue.main.async {
                                            //self.statusLabel.text = "Uploading..."
                                            print("Upload Starting!")
                                        }
                                        
                                        // Do something with uploadTask.
                                    }
                                    
                                    return nil;
        }
    }
    @IBAction func createEndPoint(_ sender: UIButton)
    {
        sender.backgroundColor = UIColor.blue;
        
        activityView.startAnimating()
        scheduledTimerWithTimeInterval(interval: 600.0)
//        let json: [String: Any] = ["modelname": self.lbl.text!,"trainingjobname": self.trainingJobField.text!]
       // \("model.tar.gz")
        self.S3ModelArtifactsField.text = "\(self.S3ModelArtifactsField.text!)\("model.tar.gz")"
        let json: [String: Any] = ["model_name": self.model_nameField.text!,"training_job_name": self.training_job_nameField.text!,"S3ModelArtifacts": self.S3ModelArtifactsField.text!]
        
        APIManager.sharedInstance.CreateEndPoint(dic: json, onSuccess: { json in
            DispatchQueue.main.async {
                print(String(describing: json))
            }
        }, onFailure: { error in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.show(alert, sender: nil)
        })
    }
    
    
    @objc func createOutputFolder()
    {
        let cate = "\(self.lbl.text ?? "")"
        let output = "/output/"
        let name = cate + output
        let request = AWSS3PutObjectRequest()
        request?.bucket = "userdatasetupload"
        request?.key = name
        AmazonS3.putObject(request!)
    }
    
    
    @objc func uploadImageForValidation(with image: UIImage) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock
        var name = randomString(length: 5)
        
        name = "/\(name).png"
        let cate = "\(self.lbl.text ?? "")"
        let training = "/validation"
        let subCategory = "/\(self.textFld.text ?? "")"
        name = cate + training + subCategory + name
        DispatchQueue.main.async(execute: {
            //self.statusLabel.text = ""
            //self.progressView.progress = 0
        })
        let imageData = UIImagePNGRepresentation(image)
        transferUtility.uploadData(imageData!, bucket: "userdatasetupload", key: name, contentType: "image/png", expression: expression,
                                   completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
                                    if let error = task.error {
                                        print("Error: \(error.localizedDescription)")
                                        
                                        DispatchQueue.main.async {
                                            //self.statusLabel.text = "Failed"
                                        }
                                    }
                                    
                                    if let _ = task.result {
                                        
                                        DispatchQueue.main.async {
                                            //self.statusLabel.text = "Uploading..."
                                            print("Upload Starting!")
                                        }
                                        
                                        // Do something with uploadTask.
                                    }
                                    
                                    return nil;
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}


extension AWSRekoViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        textField.resignFirstResponder()
        return true
    }
    
}
