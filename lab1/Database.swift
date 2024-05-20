//
//  Database.swift
//  lab1
//
//  Created by fedor on 2.03.24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

struct Dat{
    func loadImageForSSD(completion:@escaping (Array<UIImage?>)->Void){
        var array = Array<UIImage?>()
        let storageRef = Storage.storage().reference().child("images/ssd1/")
        storageRef.listAll { (result,error) in
            if let error = error {
                print("Error of receiving file: \(error)")
                return
            }
            for item in result.items {
                item.getData(maxSize: INT64_MAX, completion: {(data,error) in
                    if let error = error {
                        print("Error of receiving file: \(error)")
                        return
                    }
                    guard let imageData = data else{
                        print("Error of receiving file data")
                        return
                    }
                    let image = UIImage(data: imageData)
                    if image != nil {
                        array.append(image)
                        print("Image succesfully loaded")
                    }
                })
                DispatchQueue.main.async {
                    completion(array)
                    print("Array of images returned")
                }
                
            }
        }
    }
}

