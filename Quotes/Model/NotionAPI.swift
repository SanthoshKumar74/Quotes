//
//  NotionAPI.swift
//  Quotes
//
//  Created by Santhosh on 29/03/22.
//

import Foundation
import SwiftyJSON
import CoreData

class NotionAPI
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static func retriveData(){
        let headers = [
          "Accept": "application/json",
          "Notion-Version": "2022-02-22",
          "Content-Type": "application/json",
          "Authorization": "Bearer secret_qRBPjunNDhcYCkP5WhZ9HcZbZOsTf2lykgZeQewxdyS"
        ]
        
//        let parameters = [
//                "filter": [
//                    "property": "Category",
//                    "multi_select": [
//                        "contains": "Life"
//                    ]
//                ],
//          "page_size": 100
//        ] as [String : Any]


        let url = URL(string: "https://api.notion.com/v1/databases/9c07dc74b3444b7aaaea6fba7a9405fd/query")
        var recquest = URLRequest(url: url!)
        //let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        recquest.httpMethod = "POST"
        recquest.allHTTPHeaderFields = headers
        //recquest.httpBody = postData! as Data

        let session = URLSession(configuration: .default)
       let task =  session.dataTask(with: recquest) { (data, response, error) in
           if let safeData = data {
            
               let json = try! JSON(data: safeData)
               let results = json["results"]
               
               for result in results
               {
                   print(result.1["properties"]["Quote"]["title"][0]["text"]["content"])
                   print(result.1["properties"]["Category"]["multi_select"][0]["name"])
                   print(result.1["properties"]["Author"]["multi_select"][0]["name"])
               }

//
           }
        }
        task.resume()
    }
}
