//
//  StripeTools.swift
//  StripeDemo
//
//  Created by harikrishna patel on 19/03/19.
//  Copyright © 2019 Softqube. All rights reserved.
//

import Foundation
import Stripe

struct StripeTools {
    
    //store stripe secret key
    private var stripeSecret = "sk_test_3spQGtC2INOpMIggvauJMvuw"
    
    //generate token each time you need to get an api call
    func generateToken(card: STPCardParams, completion: @escaping (_ token: STPToken?) -> Void) {
        STPAPIClient.shared().createToken(withCard: card) { token, error in
            if let token = token {
                completion(token)
            }
            else {
                print(error)
                completion(nil)
            }
        }
    }
    
    func getBasicAuth() -> String{
        return "Bearer \(self.stripeSecret)"
    }
    
}
