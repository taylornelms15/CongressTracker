//
//  Committee.swift
//  CongressTracker
//
//  Created by Taylor Nelms on 2/21/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import Foundation
import CoreData

class Committee: NSManagedObject{
    
    @NSManaged var chairId: String
    @NSManaged var propubId: String
    @NSManaged var name: String
    @NSManaged var isSenateCommittee: Bool
    
    @NSManaged var memberList: CongressmanList
    
    lazy var chairman: Congressman? = {
        return self.memberList.congressmanWithId(id: self.chairId)
    }()//chairman
    
}//Committee
