//
//  ProfileView.swift
//  lab1
//
//  Created by fedor on 2.03.24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct UserProfile : View {
    @State private var isDelete: Bool = false
    @State private var isLogOut: Bool = false
    @State private var name:String = "Polina"
    @State private var surname:String = "Yarkevich"
    @State private var age:String = "18"
    @State private var sex:String = "Male"
    @State private var film:String = "Minsk"
    @State private var country:String = "Belarus"
    @State private var address:String = "Gykalo,4"
    @State private var phone:String = "+375447778899"
    @State private var mailIndex:String = "220112"
    @State private var email:String = "mail@domain.com"
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    
    var body : some View {
        Spacer().onAppear{
            if !auth.authorized {
                appPage.page = PageEnum.SIGNIN
            }
            getProfileDataFromDB()
        }
        VStack{
            VStack{
                Image(systemName:"person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width:40,height:40)
                HStack{
                    Text(name)
                    Text(surname)
                }
            }
            VStack{
                HStack{
                    Text("Name")
                    TextField("Enter your name",text: $name)
                }
                HStack{
                    Text("surname")
                    TextField("Enter your surname",text: $surname)
                }
                HStack{
                    Text("Age")
                    TextField("Enter birth data",text: $age)
                }
                HStack{
                    Text("Sex")
                    Menu {
                        Button(action: {
                            sex = "Male"
                        }, label: {
                            Text("Male")
                        })
                        Button(action: {
                            sex = "Female"
                        }, label: {
                            Text("Female")
                        })
                    } label: {
                        TextField("",text:$sex)
                    }
                }
                HStack{
                    Text("Country")
                    TextField("Enter your country",text: $country)
                }
                HStack{
                    Text("Film")
                    TextField("Enter your film",text: $film)
                }
                HStack{
                    Text("Address")
                    TextField("Enter your address",text:$address)
                }
                HStack{
                    Text("Phone number")
                    TextField("Enter your phone number",text:$phone)
                }
                HStack{
                    Text("Mail index")
                    TextField("Enter your mail index",text:$mailIndex)
                }
                HStack{
                    Text("Email")
                    TextField("Enter your email",text:$email)
                }
            }
        }.padding()
        
        Button(action: {isDelete = true}, label: {
            Text("Delete Account")
                .foregroundColor(.white)
                .bold()
        }).alert(isPresented: $isDelete, content: {
            Alert(
                title: Text("Account deletion"),
                message: Text("Are you sure to delete your account(all information will be lost, you cannot undo this action)?"),
                primaryButton: .destructive(Text("Delete")){
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                    let db = Firestore.firestore()
                        db.collection(user.email ?? "").getDocuments{(snapshot,error) in
                            if let error = error {
                               print("\(error)")
                            }
                            guard let snapshot = snapshot else {
                                return
                            }
                            for document in snapshot.documents{
                                let docRef = db.collection(user.email ?? "").document(document.documentID)
                                docRef.delete{error in
                                    if let error = error {
                                        print("\(error)")
                                    }
                                }
                            }
                        }
                    user.delete{error in
                        if let error = error {
                            print("\(error)")
                        } else {
                            
                        }
                    }
                    }else {
                    }
                    auth.authorized = false
                    appPage.page = PageEnum.SIGNIN
                },
                secondaryButton: .cancel()
            )
        })
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color(red:1,green:0,blue:0))
        .clipShape(Capsule())
        
        Button(action:{
            isLogOut = true
        },label:{
            Text("Log Out")
                .foregroundColor(.white)
                .bold()
        }).alert(isPresented: $isLogOut, content: {
            Alert(
                title: Text("Log Out"),
                message: Text("Are you sure to log out of your account?"),
                primaryButton: .destructive(Text("Log Out")){
                    do {
                       try Auth.auth().signOut()
                       auth.authorized = false
                       appPage.page = PageEnum.SIGNIN
                    } catch {
                        // error alert handling
                    }
                },
                secondaryButton: .cancel()
            )
        })
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color(red:1,green:0,blue:0))
        .clipShape(Capsule())
        Spacer()
        HStack{
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
            Button(action: {appPage.page = PageEnum.ITEMS
                updateProfileData()
            }, label: {
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
            Button(action: {appPage.page = PageEnum.FEATURED
                updateProfileData()
            }, label: {
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
        }.frame(height: 50, alignment: .bottom)
    }
    
    private func getProfileDataFromDB(){
        let db = Firestore.firestore()
        var userEmail:String = ""
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? ""
        } else {
            print("Unauthorized user")
            return
        }
        let docRef = db.collection(userEmail)
        docRef.getDocuments(source: .default,completion: {(snapshot,error) in
            if let error = error {
                return
            }
            guard let doc = snapshot else {
                return
            }
            for document in doc.documents {
                let data = document.data()
                if let username = data["name"] as? String {
                    name = username
                    surname = data["surname"] as? String ?? "default"
                    age = data["age"] as? String ?? "18"
                    sex = data["sex"] as? String ?? "Male"
                    country = data["country"] as? String ?? "Belarus"
                    film = data["film"] as? String ?? "Minsk"
                    address = data["address"] as? String ?? "Gykalo,4"
                    mailIndex = data["mailIndex"] as? String ?? "222222"
                    phone = data["phone"] as? String ?? "+375444444444"
                    email = Auth.auth().currentUser?.email ?? "mail@domain.com"
                }
            }
        })
    }
    
    private func updateProfileData(){
        let db = Firestore.firestore()
        var userEmail:String = ""
        if let currentUser = Auth.auth().currentUser {
            userEmail = currentUser.email ?? ""
        } else {
            print("Unauthorized user")
            return
        }
        let docRef = db.collection(userEmail)
        docRef.getDocuments(source: .default,completion: {(snapshot,error) in
            if let error = error {
                return
            }
            guard let doc = snapshot else {
                return
            }
            for document in doc.documents {
                let data = document.data()
                if let username = data["name"] as? String {
                    docRef.document(document.documentID).setData([
                        "name" : name,
                        "surname" : surname,
                        "age" : age,
                        "country" : country,
                        "sex" : sex,
                        "phone" : phone,
                        "mailIndex" : mailIndex,
                        "film" : film,
                        "address" : address
                    ])
                }
            }
        })
    }
}
