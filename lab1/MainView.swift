//
//  MainView.swift
//  lab1
//
//  Created by fedor on 28.02.24.
//

import Foundation
import SwiftUI

struct PageView : View {
    @EnvironmentObject var appPage: PageState
    @EnvironmentObject var auth: AuthState
    var body: some View {
        Text("Hugo").padding()
        Button(action:{
            //appPage.page = PageEnum.AUTH
        },label: {Text("Back")})
    }
}

