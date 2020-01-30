 //
//  ViewController.swift
//  StripeDemo
//
//  Created by harikrishna patel on 19/03/19.
//  Copyright © 2019 Softqube. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UIViewController {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var Expiry: UITextField!
    @IBOutlet weak var cvc: UITextField!
    @IBOutlet weak var msgBox: UITextView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom"
          msgBox.text = ""
    }
    
    @IBAction func PaymentTapped(_ sender: UIButton) {
        msgBox.text = ""
        let comps = Expiry.text?.components(separatedBy: "/")
        let f = UInt(comps!.first!)
        let l = UInt(comps!.last!)
        
        let cardParams = STPCardParams()
        cardParams.name = name.text!
        cardParams.number = number.text!
        cardParams.expMonth = f!
        cardParams.expYear =  l!
        cardParams.cvc = cvc.text!
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            print("Printing Strip response:\(String(describing: token?.allResponseFields))\n\n")
            print("Printing Strip Token:\(String(describing: token?.tokenId))")
            
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if token != nil{
                self.msgBox.text = "Transaction success! \n\nHere is the Token: \(String(describing: token!.tokenId))\nCard Type: \(String(describing: token!.card!.funding))\n\nSend this token or detail to your backend server to complete this payment."
            }
        }
    }
    
}

