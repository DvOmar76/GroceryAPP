//
//  LoginVC.swift
//  GroceryAPP
//
//  Created by DvOmar on 09/06/1443 AH.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginVC: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fieldError: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(K.isOnline)
        let defaults = UserDefaults.standard
        
            K.isLoged=defaults.bool(forKey: "isLoged")
           if K.isLoged {
                 defaults.string(forKey: "Password")
                self.performSegue(withIdentifier: K.Segue.toListGroceries, sender: self)
            }
        
        
       
    }
    

    @IBAction func clickOnLogin(_ sender: Any) {
        
        //get input from user
        let userEmail=email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userPassword=password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Functions.signIn(email: userEmail, password: userPassword,loginVC: self)
    }
    @IBAction func clickOnSignUp(_ sender: Any) {
        
        // get input from user
        let userEmail=email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userPassword=password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Functions.signUp(email: userEmail, password: userPassword, loginVC: self)
        
    }
    
    @IBAction func clickOnLoginWithGoogle(_ sender: Any) {
        Functions.login(loginVC: self)
    }
    
    
   
}
