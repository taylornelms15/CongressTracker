//
//  CongressmanList.swift
//  CongressTracker
//
//  Created by Taylor Nelms on 2/19/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation
import CoreData

class CongressmanList: NSManagedObject{
    
    @NSManaged var members: Set<Congressman>
    
    /**
     Adds a congressman to the list
     @param newMember: the congressman to add
     @return whether the member was added
     */
    func addCongressman(newMember: Congressman, inContext context: NSManagedObjectContext) -> Bool{
        
        if (members.contains(newMember)){
            return false;
        }//if already there
        
        members.insert(newMember)
        
        do{
            try context.save()
        }
        catch{
            NSLog(error.localizedDescription)
            return false
        }
        
        return true
        
    }//addCongressman
    
    /**
     Removes a congressman from the list
     @param member: the congressman to remove
     @return whether the member was successfully removed
     */
    func removeCongressman(member: Congressman, inContext context: NSManagedObjectContext) ->  Bool{
        
        var removed = false
        
        if (members.remove(member) != nil){
            removed = true
        }
        else{
            removed = false
        }
        
        do{
            try context.save()
        }
        catch{
            NSLog(error.localizedDescription)
            removed = false
        }
        
        return removed
        
    }//removeCongressman
    
    /**
     Returns the Congressman object with the given id in the list
     @param id: The propubId of the congressman to find
     @return the Congressman in the list with the given id. Returns nil if not found.
     */
    func congressmanWithId(id: String) -> Congressman?{
        
        for member in members{
            if (member.propubId == id){
                return member
            }
        }
        
        return nil
        
    }//congressmanWithId
    
    /**
     Produces an array of all senators in the list
     @return array of senators in the list, defaulted to sorted by last name
    */
    func senatorsInList() -> [Senator]{
        
        var results: [Senator] = []
        
        for member in members{
            if (member.isMember(of: Senator.self)){
                results.append(member as! Senator)
            }//if
        }//for each member
        
        results.sort(by: {
            (first, second) -> Bool in
            if (first.name_last == second.name_last){
                return (first.name_first < second.name_first)
            }
            else{
                return (first.name_last < second.name_last)
            }
        })
        
        return results
        
    }//senatorsInList
    
    /**
     Produces an array of all representatives in the list
     @return array of representatives in the list, defaulted to sorted by last name
     */
    func representativesInList() -> [Representative]{
        
        var results: [Representative] = []
        
        for member in members{
            if (member.isMember(of: Representative.self)){
                results.append(member as! Representative)
            }//if
        }//for each member
        
        results.sort(by: {
            (first, second) -> Bool in
            if (first.name_last == second.name_last){
                return (first.name_first < second.name_first)
            }
            else{
                return (first.name_last < second.name_last)
            }
        })
        
        return results
        
    }//senatorsInList
    
}//CongressmanList
