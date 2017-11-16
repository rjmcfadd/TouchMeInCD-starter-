//
//  TouchIDAuthentication.swift
//  TouchMeIn
//
//  Created by Ryan McFadden on 11/16/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDAuth {
    let context = LAContext()
    
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    func authenticateUser(completion: @escaping (String?) -> Void) { // 1
        // 2
        guard canEvaluatePolicy() else {
            completion("Touch ID not available")
            return
        }
        
        // 3
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
                                // 4
                                if success {
                                    DispatchQueue.main.async {
                                        // User authenticated successfully, take appropriate action
                                        completion(nil)
                                    }
                                } else {
                                    // 1
                                    let message: String
                                    
                                    // 2
                                    switch evaluateError {
                                    // 3
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = "You pressed cancel."
                                    case LAError.userFallback?:
                                        message = "You pressed password."
                                    default:
                                        message = "Touch ID may not be configured"
                                    }
                                    // 4
                                    completion(message)
                                }
        }
    }
}
