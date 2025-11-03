//
//  ShowAllImagesViewController.swift
//  coreML2
//
//  Created by Silstone on 24/05/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import AWSRekognition

class ShowAllImagesViewController: UIViewController {
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var framesImages:[UIImage] = []
    var selectedImages:[UIImage] = []
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusLabel: UILabel!
    @objc var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    @objc var progressBlock: AWSS3TransferUtilityProgressBlock?
    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    
    
    @IBAction func backclick(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        descLabel.text = String(format: "%d", framesImages.count)
//        uploadButtonPressed(image: framesImages[0]);
        
        
        //self.progressView.progress = 0.0;
        //self.statusLabel.text = "Ready"
        
        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
//                if (self.progressView.progress < Float(progress.fractionCompleted)) {
//                    self.progressView.progress = Float(progress.fractionCompleted)
//                }
            })
        }
        
        self.completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    //self.statusLabel.text = "Failed"
                }
//                else if(self.progressView.progress != 1.0) {
//                    //self.statusLabel.text = "Failed"
//                    NSLog("Error: Failed - Likely due to invalid region / filename")
//                }
                else{
                    //self.statusLabel.text = "Success"
                }
            })
        }
    
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func getcategories(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AWSRekoViewController") as? AWSRekoViewController
        vc?.selectedframesImages = self.selectedImages;
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}
extension ShowAllImagesViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK: COLLECTIONVIEW DATASOURCE
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return framesImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllImagesCVCell", for: indexPath) as! AllImagesCVCell
        cell.myimg.image = framesImages[indexPath.item]
        cell.clickImage.tag = indexPath.item
        return cell
    }
    
    
    //MARK: COLLECTIONVIEW DELEGATE
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
          let cell = collectionView.cellForItem(at: indexPath) as! AllImagesCVCell
        if(self.selectedImages.contains(framesImages[indexPath.item]))
        {
            cell.clickImage.image = #imageLiteral(resourceName: "emptyicon")
            let indexVal = self.selectedImages.index(of: framesImages[indexPath.item])
            self.selectedImages.remove(at: indexVal!)
            
        }
        else{
             cell.clickImage.image = #imageLiteral(resourceName: "filledicon")
            self.selectedImages.append(framesImages[indexPath.item])
        }
      
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
