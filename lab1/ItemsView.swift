//
//  ItemsView.swift
//  lab1
//
//  Created by fedor on 2.03.24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ItemsView : View {
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    @State var ssdArray:Array<SSD> = Array<SSD>()
    @State var featuredSSD:Array<SSD> = Array<SSD>()
    
    
    var body : some View {
        
        Text("Catalog").padding().onAppear{
            if !auth.authorized{
                appPage.page = PageEnum.SIGNIN
            }
            SSD.getItemsFromDB(){(array) in
                ssdArray = array
            }
        }
        GeometryReader{geometry in
        List(ssdArray,id:\.self){ item in
            Item(item:item,page:appPage)
        }.frame(height:geometry.size.height * 0.9)
        }
        
        .overlay(HStack{
            Spacer()
            Button(action: {appPage.page = PageEnum.PROFILE}, label: {
                VStack{
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                    Text("Profile")
                        .font(.system(size:14))
                }
            }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .frame(height:50)
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                VStack{
                    Image(systemName: "list.bullet")
                        .resizable()
                        .scaledToFit()
                    Text("Items")
                        .font(.system(size:14))
                }
                    
            }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .frame(height:50)
            Spacer()
            Button(action: {appPage.page = PageEnum.FEATURED}, label: {
                VStack{
                    Image(systemName: "star.circle")
                        .resizable()
                        .scaledToFit()
                    Text("Featured")
                        .font(.system(size:14))
                }
                    
            }).padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            .frame(height:50)
            Spacer()
        }, alignment: .bottom)
        }
    }
    
    


struct Item : View{
    var element: SSD
    var appPage: PageState
    @State private var isExisting:Bool = false
    var body: some View{
        HStack{
            Image(systemName: "externaldrive")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    appPage.page = PageEnum.DESC
                }
            VStack{
                Text(verbatim: "SSD Disk " + String(element.getModel()))
                Text(verbatim: String(element.getPrice()) + "$")
                    .foregroundColor(.red)
            }.frame(alignment: .leading)
            .onAppear{
                setFeaturedStatus(ssdDocument: element.getId())
            }
            .onTapGesture {
                appPage.page = PageEnum.DESC
                SSDProfile.setCurrentSSD(ssd:element)
            }
            Spacer()
            Button(action: {
                if(!isExisting){
                    addFeaturedToDB(ssdDocument: element.getId())
                } else {
                    deleteFeaturedFromDB(ssdDocument: element.getId())
                }
                    
            }, label: {
                Image(systemName: isExisting ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            })
            
        }
        .frame(height:50,alignment: .leading)
    }
    
    public init(item:SSD,page:PageState){
        self.element = item
        self.appPage = page
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
                setFeaturedStatus(ssdDocument: element.getId())
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
                setFeaturedStatus(ssdDocument: element.getId())
                
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
