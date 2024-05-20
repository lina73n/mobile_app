//
//  SignInView.swift
//  lab1
//
//  Created by fedor on 28.02.24.
//

import Foundation
import SwiftUI
import Firebase

struct SignInView: View {
    @State private var name:String = ""
    @State private var surname:String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var age: String = ""
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    var body: some View {
        ScrollView{
            Text("Sign In:").font(.system(size:25)).padding()
        VStack{
        Text("Name(*):").padding()
        TextField("Enter name",text: $name).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        Text("surname(*):").padding()
        TextField("Enter surname",text: $surname).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        Text("Age(*):").padding()
        TextField("Enter age",text: $age).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        }
        VStack{
        Text("Email(*):").padding().onAppear{
            if let user = Auth.auth().currentUser {
                auth.authorized = true
                appPage.page = PageEnum.ITEMS
            }
        }
        TextField("Enter email",text: $email).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        Text("Password(*):").padding()
        SecureField("Enter password",text: $password).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        }
        Button (
        action: {
        InAppAuthorization().signIn(email:email,password:password)
        auth.authorized = true
        appPage.page = PageEnum.ITEMS
        },label: { Text("Sign In").foregroundColor(.white)})
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color(.blue))
            .clipShape(Capsule())
            
        Button(action: {appPage.page = PageEnum.SIGNUP}, label: {Text("Already has account? Sign up")}).padding()
        }
    }
    public init(email:String,password:String){
        self.password = password
        self.email = email
    }
}
