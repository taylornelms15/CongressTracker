//
//  CongressTrackerTests.swift
//  CongressTrackerTests
//
//  Created by Taylor Nelms on 2/16/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import XCTest
import CoreData
@testable import CongressTracker

class CongressTrackerTests: XCTestCase {
    
    let googleURLText = "https://www.google.com"
    let testURLText = "https://a.4cdn.org/boards.json"
    let senateURLText = "https://api.propublica.org/congress/v1/115/senate/members.json"
    let committeeURLText = "https://api.propublica.org/congress/v1/115/senate/committees.json"
    let ProPub_API_Key = "lgnH55v6W792ZBJrFlv3s7v91QTW7jb29RZh70gf"
    
    var senators: [Congressman] = []
    var receivedData: Data? = nil
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    override func setUp() {
        super.setUp()
        
        //let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        //sessionConfig.httpAdditionalHeaders = ["X-API-Key" : ProPub_API_Key]
        
        
        //let session: URLSession = URLSession.shared

        
        //MARK: URL things (ignoring for now)
        
        var myRequest: URLRequest = URLRequest.init(url: URL(string: committeeURLText)!)
        myRequest.addValue(ProPub_API_Key, forHTTPHeaderField: "X-API-Key")

        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: myRequest, completionHandler: {
            (data, response, error) -> Void in
            
            print("--------------------------------")
            print(error!.localizedDescription)
            
            self.receiveCongressmanData(data: data!)

            print(response)
            print("|||||||||||||||||||||||||||||||||")
        })

        task.resume()
 
        
        //MARK: JSON reading/parsing
        
        
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        //let managedObjectContext: NSManagedObjectContext = delegate.persistentContainer.viewContext
        
        /*
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        
        let path = Bundle.main.path(forResource: "senateMembers", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)

        
        parseMembersJson(jsonFileData: jsonData!, context: managedObjectContext)
        */
        
        

        
    }//setup
    

    
    
    func receiveCongressmanData(data: Data){
        

        print(data)
        print("+++++++++++++++")
        
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options:[])
            print("Array: \(jsonArray)")
        }
        catch {
            print("Error: \(error)")
        }
        
        self.receivedData = data
        
        
    }//receiveCongressmanData
    
    override func tearDown() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext: NSManagedObjectContext = delegate.persistentContainer.viewContext
        
        for senator in senators{
            managedObjectContext.delete(senator)
        }
        
        super.tearDown()
    }
    
    func testMadeSenators() {
        /*
        for senator in senators{
            print(senator)
            
            XCTAssertFalse(senator.propubId == "")
            
        }//for each senator
        */
        
    }//testMadeSenators
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
