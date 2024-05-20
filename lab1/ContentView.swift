//
//  ContentView.swift
//  lab1
//
//  Created by fedor on 23.02.24.
//

import SwiftUI
import Foundation



struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    
    var body: some View {
        
        Text("Start page")
            .padding()
            .onAppear{
                if(!auth.authorized) {
                appPage.page = PageEnum.SIGNIN
                }}
        TextField("Username",
                  text: $username)
            .padding()
        TextField("Password",
                  text: $password)
            .padding()
        Button(action: {
            appPage.page = PageEnum.MAIN
        }, label: {
            Text("Log In")
        }).padding()
        Button(action: {
            appPage.page = PageEnum.SIGNIN
        }, label: {
            Text("Sign Up")
        }).padding()
    }
}

func signIn()->String{
    return "Hey";
}
