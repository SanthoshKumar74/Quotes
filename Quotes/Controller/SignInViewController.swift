//
//  ViewController.swift
//  Quotes
//
//  Created by Santhosh on 10/03/22.
//

import UIKit
import GoogleSignIn

class SignInViewController: UIViewController{
    let signInConfig = GIDConfiguration.init(clientID: "1080783319032-v0lsnm8m7jptp9n7pi2qodsmpeg7e6rj.apps.googleusercontent.com",serverClientID: "1080783319032-odt03u9s2jtomohb5acv67vsljgp8kbu.apps.googleusercontent.com")
    

    
    @IBAction func signInButton(_ sender: Any) {
    
    
        // GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          //  guard error == nil
            // else { return }
             //guard let user = user else {return}
             self.performSegue(withIdentifier: "goToQuotes", sender: sender)
        
//        let headers = [
//          "Accept": "application/json",
//          "Notion-Version": "2022-02-22",
//          "Content-Type": "application/json",
//          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
//        ]
//
//        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
//        var recquest = URLRequest(url: url!)
//        recquest.httpMethod = "POST"
//        recquest.allHTTPHeaderFields = headers
//
//        let session = URLSession(configuration: .default)
//       let task =  session.dataTask(with: recquest) { (data, response, error) in
//           if let safeData = data {
//               print(safeData)
////               let jsonString = try? JSONSerialization.jsonObject(with: safeData, options: .json5Allowed)
//               let decoder = JSONDecoder()
//               let decodedData = try! decoder.decode(QuotesData.self, from: safeData)
//               print(decodedData)
//           }
//        }
//        task.resume()
//          //}
    
   }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

