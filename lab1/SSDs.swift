//
//  SSDs.swift
//  lab1
//
//  Created by fedor on 3.03.24.
//

import Foundation
import Firebase
import FirebaseFirestore


class SSD : Hashable{
   
    
    private static let db = Firestore.firestore()
    private var id:String = ""
    private var model:String = ""
    private var memory:Int = 0
    private var writeSpeed:Int = 0
    private var readSpeed:Int = 0
    private var price:Int = 0
    private var imagePath:String = ""
    
    public func getModel()->String{
        return self.model
    }
    public func getMemory()->Int{
        return self.memory
    }
    public func getWriteSpeed()->Int{
        return self.writeSpeed
    }
    public func getReadSpeed()->Int{
        return self.readSpeed
    }
    public func getPrice()->Int{
        return self.price
    }
    public func getId()->String{
        return self.id
    }
    
    public func getImagePath()->String{
        return self.imagePath
    }
    
    public func setId(id:String)->Void{
        self.id = id
    }
    
    public func setModel(model:String)->Void{
        self.model = model
    }
    public func setMemory(memory:Int)->Void{
        self.memory = memory
    }
    public func setWriteSpeed(writeSpeed:Int)->Void{
        self.writeSpeed = writeSpeed
    }
    public func setReadSpeed(readSpeed:Int)->Void{
        self.readSpeed = readSpeed
    }
    public func setPrice(price:Int)->Void{
        self.price = price
    }
    
    public func setImagePath(imagePath:String)->Void{
        self.imagePath = imagePath
    }
    
    public static func getItemsFromDB(completion:@escaping(Array<SSD>)->Void){
        let collectionRef = db.collection("ssd")
        var array = Array<SSD>()
        collectionRef.getDocuments{(snapshot,error) in
            if let error = error {
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents{
                let ssd = SSD()
                ssd.setId(id:document.documentID)
                let data = document.data()
                if let value = data["model"] as? String{
                    //print("Model: \(value)")
                    ssd.setModel(model: value)
                }
                if let value = data["memory"] as? Int {
                    //print("Memory: \(value)")
                    ssd.setMemory(memory: value)
                }
                if let value = data["writeSpeed"] as? Int {
                    //print("Write Speed: \(value)")
                    ssd.setWriteSpeed(writeSpeed:value)
                }
                if let value = data["readSpeed"] as? Int{
                    //print("Read Speed: \(value)")
                    ssd.setReadSpeed(readSpeed:value)
                }
                if let value = data["price"] as? Int{
                    //print("Price: \(value)")
                    ssd.setPrice(price:value)
                }
                if let value = data["imagePath"] as? String{
                    //print("Price: \(value)")
                    ssd.setImagePath(imagePath: value)
                }
                array.append(ssd)
                
            }
            completion(array)
        }
    }
    
    static func == (lhs: SSD, rhs: SSD) -> Bool {
        var equal:Bool = true
        equal = equal && lhs.getId() == rhs.getId()
        equal = equal && lhs.getModel() == rhs.getModel()
        equal = equal && lhs.getPrice() == rhs.getPrice()
        equal = equal && lhs.getMemory() == rhs.getMemory()
        equal = equal && lhs.getReadSpeed() == rhs.getReadSpeed()
        equal = equal && lhs.getWriteSpeed() == rhs.getWriteSpeed()
        equal = equal && lhs.getImagePath() == rhs.getImagePath()
        return equal
    }
    
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
        hasher.combine(model)
        hasher.combine(writeSpeed)
        hasher.combine(readSpeed)
        hasher.combine(memory)
        hasher.combine(price)
        hasher.combine(imagePath)
    }
    
}
