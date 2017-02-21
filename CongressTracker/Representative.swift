//
//  Congressman.swift
//  CongressTracker
//
//  Created by Taylor Nelms on 2/16/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation
import CoreData

class Representative: Congressman{
    
    @NSManaged var district: Int16
    
    static let houseURLText = "https://api.propublica.org/congress/v1/115/house/members.json"
    
    override func stateAndDistrict() -> String{return "\(self.party):\(self.state)-\(self.district)"}
    
    override public var description: String{
        return "Name: \(name_first)\(name_middle != nil ? " \(name_middle!)" : "" ) \(name_last)\n\(party):\(state)-\(district)\nid: \(propubId)"
    }
    
    
    /**
     Builds the list of all represenatives in the current congress.
     @return: list of current representatives
     */
    static func buildRepresentativeList(context: NSManagedObjectContext) -> [Representative]{
        let completedURLSemaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        
        var myRequest: URLRequest = URLRequest.init(url: URL(string: Representative.houseURLText)!)
        myRequest.addValue(ProPub_API_Key, forHTTPHeaderField: "X-API-Key")
        
        
        var resultList: [Representative] = []
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: myRequest, completionHandler: {
            (data, response, error) -> Void in
            
            if (error != nil){
                print(error!.localizedDescription)
            }//if error
            
            
            do{
                
                var newCongressman: Representative
                
                let jsonRead = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
                
                let results0 = jsonRead["results"] as! [Any]
                let results1 = results0[0] as! [String: Any]
                let members = results1["members"] as! [[String: String?]]
                
                
                for member in members{
                    
                    newCongressman = Representative(context: context)
                    
                    newCongressman.name_last = member["last_name"]!!
                    if (member["middle_name"]! != nil && member["middle_name"]! != ""){
                        newCongressman.name_middle = member["middle_name"]!!
                    }//if middle_name exists
                    else{
                        newCongressman.name_middle = nil
                    }
                    newCongressman.name_first = member["first_name"]!!
                    newCongressman.propubId = member["id"]!!
                    newCongressman.party = member["party"]!!
                    newCongressman.state = member["state"]!!
                    newCongressman.district = Int16(member["district"]!!)!
                    
                    newCongressman.name_first = Congressman.cleanNameOfApostrophes(oldName: newCongressman.name_first)
                    if (newCongressman.name_middle != nil){
                        newCongressman.name_middle = Congressman.cleanNameOfApostrophes(oldName: newCongressman.name_middle!)
                    }//if
                    newCongressman.name_last = Congressman.cleanNameOfApostrophes(oldName: newCongressman.name_last)
                    
                    resultList.append(newCongressman)
                }//for each member
                
                try context.save()
                
            }//do
            catch{
                print(error.localizedDescription)
            }//catch
            
            completedURLSemaphore.signal()
        })
        
        task.resume()
        
        completedURLSemaphore.wait()
        
        return resultList

        
    }//buildRepList
    
}//Congressman
