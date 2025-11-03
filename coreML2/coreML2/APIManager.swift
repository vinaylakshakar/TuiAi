//
//  APIManager.swift
//  RESTAPIManager
//
//  Created by Petros Demetrakopoulos on 21/12/2016.
//  Copyright © 2016 Petros Demetrakopoulos. All rights reserved.
//

import UIKit
import SwiftyJSON
class APIManager: NSObject {
    
    //let baseURL = "https://51xty6eh5h.execute-api.eu-west-1.amazonaws.com/api/"
    let baseURL = "https://s7umigu0i9.execute-api.eu-west-1.amazonaws.com/api/"
    static let sharedInstance = APIManager()
   static let startEndpoint = "train"
    
    func getData(onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
    let url : String = baseURL
    let json: [String: Any] = ["data": "ABC"]
        
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
    let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        if(error != nil){
            onFailure(error!)
        } else{
            var result = JSON()
            do{
                result = try JSON(data: data!)
            }
            catch{
                 print(result)
            }
            
            onSuccess(result)
        }
    })
    task.resume()
}
    //vinay here-
    func invokeModel(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "https://s7umigu0i9.execute-api.eu-west-1.amazonaws.com/api/invoke"
        let json: [String: Any] = ["data": dic["base64"] as Any,"endpoint": dic["endpoint"] as Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    //vinay here-
    func generateTrainPath(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "http://34.246.190.9:8000/api/v1/augment"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func generateValidationPath(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "http://34.246.190.9:8000/api/v1/augment"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func generateLst(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "http://34.246.190.9:8000/api/v1/imrec"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func CreateEndPoint(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "https://s7umigu0i9.execute-api.eu-west-1.amazonaws.com/api/create"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func GetIndexObject(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "https://s7umigu0i9.execute-api.eu-west-1.amazonaws.com/api/objects"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func deleteEndPoint(dic:[String: Any],onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = "https://s7umigu0i9.execute-api.eu-west-1.amazonaws.com/api/delete"
        let json: [String: Any] = dic
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }
    
    func startTraining(dic:[String: Any], onSuccess: @escaping(JSON) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL + APIManager.startEndpoint
        let json: [String: Any] = dic //["data": "ABC"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                var result = JSON()
                do{
                    result = try JSON(data: data!)
                }
                catch{
                    print(result)
                }
                
                onSuccess(result)
            }
        })
        task.resume()
    }

}
