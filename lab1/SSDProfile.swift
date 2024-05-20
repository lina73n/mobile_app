//
//  SSDProfile.swift
//  lab1
//
//  Created by fedor on 5.03.24.
//

import Foundation
import Firebase
import FirebaseStorage
import SwiftUI

struct SSDProfile : View {
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    @State var arrayOfImages = Array<UIImage>()
    @State private var selection = 0
    @State private var isExisting:Bool = false
    private static var currentSSD:SSD = SSD()
    
    public static func getCurrentSSD()->SSD{
        return self.currentSSD
    }
    
    public static func setCurrentSSD(ssd:SSD){
        self.currentSSD = ssd
    }
    
    var body : some View {
        ScrollView(.vertical){
        HStack{
            Image(systemName:"arrow.left").onAppear{
                loadImageForSSD()
                setFeaturedStatus(ssdDocument: SSDProfile.currentSSD.getId())
            }.frame(alignment:.leading).onTapGesture {
                appPage.page = PageEnum.ITEMS
            }
            .padding()
            Spacer()
            
        }
        HStack{
            if(arrayOfImages.count > 0){
                Image(uiImage: arrayOfImages[0])
                    .resizable()
                    .scaledToFit()
                    .frame(width:60,height:60)
                    
                    
            } else {
                if let image = UIImage(systemName: "xmark.icloud.fill"){
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width:60,height:60)
                }
            }
            Text(String(SSDProfile.currentSSD.getModel()))

        }
        Text("Price: " + String(SSDProfile.currentSSD.getPrice()) + "$")
            .bold()
            Button(action: {
                
            }, label: {
                
                Image(systemName:"cart.fill")
                    .foregroundColor(.white)
                Text("Buy in One Click")
                    .foregroundColor(.white)

            }).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color(.green))
            .clipShape(Capsule())
        Button(action: {
            if(isExisting){
                deleteFeaturedFromDB(ssdDocument: SSDProfile.currentSSD.getId())
            } else{
                addFeaturedToDB(ssdDocument: SSDProfile.currentSSD.getId())
            }
            setFeaturedStatus(ssdDocument: SSDProfile.currentSSD.getId())
        }, label: {
            if(!isExisting){
                Image(systemName:"plus.app")
                    .foregroundColor(.white)
                Text("Add to Featured")
                    .foregroundColor(.white)
            } else{
                Image(systemName:"xmark.bin.fill")
                    .foregroundColor(.white)
                Text("Remove from Featured")
                    .foregroundColor(.white)
            }
        })
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color(isExisting ? .red : .blue))
        .clipShape(Capsule())
        Text("Images of SSD:")
            .font(.system(size:20))
        VStack{
            TabView(selection:$selection){
                    if(arrayOfImages.count == 0){
                        Image(systemName: "xmark.icloud.fill")
                        .resizable()
                        .scaledToFit()
                         
                    } else {
                       
                        ForEach(arrayOfImages,id:\.self){ item in
                            if let curr = item {
                                Image(uiImage: curr)
                                    .resizable()
                                    .scaledToFit()
                                    
                            }
                        }
                    }
                }
                .id(UUID())
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height:200,alignment: .center)
            }
        Text("Characteristics:")
            .font(.system(size:20))
        VStack{
            TableRow(text: "SSD Model:",gradation: "",value: SSDProfile.currentSSD.getModel())
            TableRow(text: "SSD Memory Size(GB):",gradation: "GB",value: SSDProfile.currentSSD.getMemory())
            TableRow(text: "SSD Writing Speed(MB/s):",gradation: "MB/s",value: SSDProfile.currentSSD.getWriteSpeed())
            TableRow(text: "SSD Reading Speed(MB/s):",gradation: "MB/s",value: SSDProfile.currentSSD.getReadSpeed())
        }
        }
    }
    
    func loadImageForSSD(){
        let storageRef = Storage.storage().reference().child(SSDProfile.currentSSD.getImagePath())
        print(SSDProfile.currentSSD.getImagePath())
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
                    if let image = UIImage(data: imageData){
                        arrayOfImages.append(image)
                        print("Image succesfully loaded")
                    }
                })
            }
        }
    }
    
    func addFeaturedToDB(ssdDocument:String)->Void{
        
        var isExisting: Bool = false
        let db = Firestore.firestore()
        var userEmail:String = ""
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? ""
        } else {
            print("Unauthorized user")
            return
        }
        let data: [String: Any] = ["ssdDocument": ssdDocument]
        db.collection(userEmail).getDocuments(completion: {(snapshot,error) in
            if let error = error {
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents{
                let data = document.data()
                if(data["ssdDocument"] as? String == ssdDocument){
                    isExisting = true
                }
            }
            if(!isExisting) {
                db.collection(userEmail).addDocument(data: data){error in
                    if let error = error {
                        print("Error in addition of document: \(error)")
                    }
                }
                setFeaturedStatus(ssdDocument: SSDProfile.currentSSD.getId())
            }
        })
    }
    
    func deleteFeaturedFromDB(ssdDocument:String)->Void{
        
        var isExisting: Bool = false
        var documentToDelete: String = ""
        let db = Firestore.firestore()
        var userEmail:String = ""
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? ""
        } else {
            print("Unauthorized user")
            return
        }
        let data: [String: Any] = ["ssdDocument": ssdDocument]
        db.collection(userEmail).getDocuments(completion: {(snapshot,error) in
            if let error = error {
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents{
                let data = document.data()
                if(data["ssdDocument"] as? String == ssdDocument){
                    isExisting = true
                    documentToDelete = document.documentID
                }
            }
            if(isExisting) {
                db.collection(userEmail).document(documentToDelete).delete(completion: {(error) in
                    if let error = error {
                        print("Error in deleting of document: \(error)")
                    }
                    
                })
                setFeaturedStatus(ssdDocument: SSDProfile.currentSSD.getId())
                
            }
        })
    }
    
    func setFeaturedStatus(ssdDocument:String)->Void{
        let db = Firestore.firestore()
        var userEmail:String = ""
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? ""
        } else {
            print("Unauthorized user")
            return
        }
        let data: [String: Any] = ["ssdDocument": ssdDocument]
        db.collection(userEmail).getDocuments(completion: {(snapshot,error) in
            if let error = error {
                return
            }
            guard let snapshot = snapshot else {
                return
            }
            for document in snapshot.documents{
                let data = document.data()
                if(data["ssdDocument"] as? String == ssdDocument){
                    isExisting = true
                    return
                }
            }
            isExisting = false
            
        })
    }
}

struct TableRow: View {
    
    private var text:String
    private var gradation:String
    private var value:Any
    
    var body: some View{
        GeometryReader{geometry in
            HStack{
                Image(systemName:"bookmark.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1)
                VStack{
                    Text(text)
                        .frame(alignment:.leading)
                    Text(String(reflecting:value) + " " + gradation).frame(alignment: .leading)
                }
                   
            }.frame(maxWidth:.infinity, alignment:.leading)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 1)
            )
        }.padding()
        
    }
    
    public init(text:String,gradation:String,value:Any){
        self.text = text
        self.gradation = gradation
        self.value = value
    }
}

