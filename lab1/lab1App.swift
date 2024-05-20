//
//  lab1App.swift
//  lab1
//
//  Created by fedor on 23.02.24.
//

import SwiftUI
import FirebaseCore


enum PageEnum {
    case SIGNIN
    case DESC
    case FEATURED
    case PROFILE
    case ITEMS
    case SIGNUP
}

class PageState: ObservableObject {
    @Published var page: PageEnum
    
    init(page: PageEnum){
        self.page = page
    }
}

class AuthState: ObservableObject {
    @Published var authorized: Bool
    
    init(authorized: Bool){
        self.authorized = false;
    }
}

@main
struct lab1App: App {
    @ObservedObject var appPage = PageState(page: PageEnum.SIGNIN)
    @ObservedObject var auth = AuthState(authorized: false)
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            switch(appPage.page){
            case PageEnum.SIGNIN:
                SignInView(email:"",password: "").environmentObject(appPage)
                .environmentObject(auth)
            case PageEnum.SIGNUP:
                SignUpView(email:"",password: "").environmentObject(appPage)
                .environmentObject(auth)
            case PageEnum.ITEMS:
                let array = Array<SSD>()
                ItemsView(ssdArray: array).environmentObject(appPage)
                .environmentObject(auth)
            case PageEnum.DESC:
                SSDProfile().environmentObject(appPage)
                    .environmentObject(auth)
            case PageEnum.PROFILE:
                UserProfile().environmentObject(appPage)
                    .environmentObject(auth)
            case PageEnum.FEATURED:
                FeaturedItemsView().environmentObject(appPage)
                    .environmentObject(auth)
            default:
                SignInView(email:"",password:"").environmentObject(appPage)
                .environmentObject(auth)
            }
        }
    }
}
