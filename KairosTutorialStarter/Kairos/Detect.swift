//
//  Detect.swift
//  KairosTutorialStarter
//
//  Created by James Rochabrun on 3/2/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

// Example - Detect
extension KairosAPI {
    
    /*
     Takes a photo and returns the facial features it finds.To detect faces, all you need to do is submit a JPG or PNG photo. You can submit the photo either as a publicly accessible URL or Base64 encoded.Finally, we have some advanced options available for your use. We have set these options to sensible defaults, but sometimes there is a need to override them and we have provided that facility for you.One additional thing to note is that the returned coordinates all begin at the top left of the photo.
     */
    
    typealias CompletionHandler = (String) -> Void
    func exampleDetect(_ file: String, completion: @escaping CompletionHandler )  {
        
        //    func exampleDetect(_ image: UIImage) {
        
        let base64ImageData = KairosAPI.sharedInstance.convertImageFileToBase64String(file: file)
        // setup json request params, with base64 data
        let jsonBody = [
            "image": base64ImageData
        ]
        
            KairosAPI.sharedInstance.request(method: "detect", data: jsonBody) { data in
                // check image key exist and get data
                if let image = ((data as? [String : AnyObject])!["images"])! as? [AnyObject] {
                    // get root image and primary key objects
                    let firstImage = image[0]
                    let faces = ((firstImage as? [String : AnyObject])?["faces"])! as! [[String : AnyObject]]
                    let firstFaces = faces[0]
                    
                    if let attributes = firstFaces["attributes"] as? [String : AnyObject] {
                        
                        // get specific enrolled attributes
                        let gender = attributes["gender"]!["type"]!! as! String
                        let gender_type = (gender == "F") ? "female" : "male"
                        let age = attributes["age"]! as! Int
                        let confidence_percent = 100 * (firstFaces["confidence"]! as! Double)
                        
                        let asianConfidence = 100 * (attributes["asian"] as! Double)
                        let blackConfidence = 100 * (attributes["black"] as! Double)
                        let hispanicConfidence = 100 * (attributes["hispanic"] as! Double)
                        let whiteConfidence = 100 * (attributes["white"] as! Double)
                        let glasses = attributes["glasses"] as! String
                        
                        var typeOfGlasses = ""
                        if glasses == "None" {
                            typeOfGlasses = "No glasses"
                        } else if glasses == "Sun" {
                            typeOfGlasses = "Cool sunglasses"
                        } else if glasses == "Eye" {
                            typeOfGlasses = "yeap, glasses"
                        }
                        
                        let smiling = (attributes["lips"] as! String) == "Together" ? "Nope you need to smile" : "Great Smile :)"
                        
                        let apiSuccess = "API request Detect \n\n faces : \(faces.count) \n Gender: \(gender_type) \n Age: \(age) \n Smiling: \(smiling) \n asian: \(asianConfidence), \n black: \(blackConfidence),\n hispanic:  \(hispanicConfidence), \n caucasian: \(whiteConfidence) \n typeOfGlasses: \(typeOfGlasses) \n Confidence Overall: \(confidence_percent)% \n"
                        
                        completion(apiSuccess)
                }
                else {
                    print("Error - Detect: unable to get image data")
                }
            }
        }
    }
}

/// values for smiling: lips : Together || open
/// values for sunglasses: None || Eye || Sun


