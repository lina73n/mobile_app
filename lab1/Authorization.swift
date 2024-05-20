//
//  Authorization.swift
//  lab1
//
//  Created by fedor on 23.02.24.
//

import Foundation
import Firebase

class InAppAuthorization {
    
    func signIn(email: String,password: String){
        Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: {user, error in
            if let error = error as? NSError {
                print(error)
            }})
    }
    
    func signUp(email:String,password:String){
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: {user, error in
            if let err = error as NSError? {
                if let errorCode = AuthErrorCode(rawValue: err.code) {
                    switch(errorCode){
                    case .userDisabled:
                        String("Account is disabled")
                    case .userNotFound:
                        String("Account doesn't exist")
                    case .invalidEmail:
                        String("Email is invalid")
                    case .wrongPassword:
                        String("Password is wrong")
                    default:
                        String("Undefined authorization error")
                    }
                }
            }
        })
    }
}
