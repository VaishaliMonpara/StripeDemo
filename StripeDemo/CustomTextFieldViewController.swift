//
//  CustomTextFieldViewController.swift
//  StripeDemo
//
//  Created by harikrishna patel on 19/03/19.
//  Copyright © 2019 Softqube. All rights reserved.
//

import UIKit
import Stripe

class CustomTextFieldViewController: UIViewController,STPPaymentCardTextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet weak var paymentCardTextField: STPPaymentCardTextField!
    
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    
    var stripeUtil = StripeUtil()
    
    var cards = [AnyObject]()
    
    
    var cvc = ""
    var exyr : UInt = 0
    var exdt : UInt = 0
    var cardnum = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentCardTextField.delegate = self
    }
    
    @IBAction func onTapped(_ sender: Any) {
        let f = UInt(exdt)
        let l = UInt(exyr)
        
        let cardParams = STPCardParams()
        cardParams.number = cardnum
        cardParams.expMonth = f
        cardParams.expYear = l
        cardParams.cvc = cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            print("Printing Strip response:\(String(describing: token?.allResponseFields))\n\n")
            print("Printing Strip Token:\(String(describing: token?.tokenId))")
            
            
            if error != nil {
                print(error?.localizedDescription)
            }
            
            if token != nil{
                let msg = "Transaction success! \n\nHere is the Token: \(String(describing: token!.tokenId))\nCard Type: \(String(describing: token!.card!.funding))\n\nSend this token or detail to your backend server to complete this payment."
                let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! cardCell
        
        if let last4 = self.cards[indexPath.row]["last4"] {
            cell.cardNumberLabel.text = "**** **** **** \(last4!)"
        }
        
        if let expirationMonth = self.cards[indexPath.row]["exp_month"], let expirationYear = self.cards[indexPath.row]["exp_year"] {
            cell.expirationLabel.text = "\(expirationMonth!)/\(expirationYear!)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cardParams = STPCardParams()
        let param = "**** **** **** \(self.cards[indexPath.row]["last4"])"
        cardParams.number = param
        self.paymentCardTextField.cardParams = cardParams
    }
    @IBAction func sendCard() {
        //extract the card parameters given by the STPCardTextField
        let params = paymentCardTextField.cardParams
        
        //check if the customerId exist
        if let tokenId = stripeUtil.customerId {
            //if yes, call the createCard method of our stripeUtil object, pass customer id
            self.stripeUtil.createCard(stripeId: tokenId, card: params, completion: { (success) in
                //there is a new card !
                self.stripeUtil.getCardsList(completion: { (result) in
                    if let result = result {
                        self.cards = result
                    }
                    //store results on our cards, clear textfield and reload tableView
                    DispatchQueue.main.async {
                        self.paymentCardTextField.clear()
                        self.cardTableView.reloadData()
                    }
                })
            })
        }
        else {
            //if not, create the user with our createUser method
            self.stripeUtil.createUser(card: params, completion: { (success) in
                self.stripeUtil.getCardsList(completion: { (result) in
                    if let result = result {
                        self.cards = result
                    }
                    //store results on our cards, clear textfield and reload tableView
                    DispatchQueue.main.async {
                        self.paymentCardTextField.clear()
                        self.cardTableView.reloadData()
                    }
                })
            })
        }
    }

}
