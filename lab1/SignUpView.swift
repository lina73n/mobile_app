//
//  SignUpView.swift
//  lab1
//
//  Created by fedor on 29.02.24.
//

import Foundation
import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    var body: some View {
        Text("Sign Up").padding().onAppear{
            if let user = Auth.auth().currentUser {
                auth.authorized  = true
                appPage.page = PageEnum.ITEMS
            }
        }
        TextField("Enter email",text: $email).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        SecureField("Enter password",text: $password).padding().overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
        ).padding()
        Button (
        action: {
        InAppAuthorization().signUp(email:email,password:password)
        auth.authorized = true
        appPage.page = PageEnum.ITEMS
        },label: { Text("Sign Up").foregroundColor(.white)}).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .background(Color(.blue))
            .clipShape(Capsule())
    }
    public init(email:String,password:String){
        self.password = password
        self.email = email
    }
}
