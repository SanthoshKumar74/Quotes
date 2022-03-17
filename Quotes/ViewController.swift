//
//  ViewController.swift
//  Quotes
//
//  Created by Santhosh on 10/03/22.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController{
    let signInConfig = GIDConfiguration.init(clientID: "1080783319032-v0lsnm8m7jptp9n7pi2qodsmpeg7e6rj.apps.googleusercontent.com",serverClientID: "1080783319032-odt03u9s2jtomohb5acv67vsljgp8kbu.apps.googleusercontent.com")
    

    
    @IBAction func signInButton(_ sender: Any) {
    
    
        // GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          //  guard error == nil
            // else { return }
             //guard let user = user else {return}
             self.performSegue(withIdentifier: "goToQuotes", sender: sender)
          //}
    
   }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

