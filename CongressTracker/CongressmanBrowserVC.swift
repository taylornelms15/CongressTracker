//
//  CongressmanBrowserVC.swift
//  CongressTracker
//
//  Created by Taylor Nelms on 2/19/17.
//  Copyright © 2017 Taylor. All rights reserved.
//

import UIKit
import CoreData
let ProPub_API_Key = "lgnH55v6W792ZBJrFlv3s7v91QTW7jb29RZh70gf"

class CongressmanBrowserVC: UITableViewController{

    //MARK: Outlets
    @IBOutlet var congressmanBrowserTableView: UITableView!
    
    
    //MARK: Variables
    var senators: [Senator] = []
    var representatives: [Representative] = []
    
    
    //MARK: VC Methods
    override func viewDidLoad(){
        super.viewDidLoad()
        
        congressmanBrowserTableView.delegate = self
        congressmanBrowserTableView.dataSource = self
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = Senator.fetchRequest()
        let request2 = Representative.fetchRequest()
        do{
            let results = try context.fetch(request)
            let results2 = try context.fetch(request2)
            
            if (results.count == 0){
                senators = Senator.buildSenatorList(context: context)
            }//if no senators, make senators
            else{
                senators = results as! [Senator]
                


            }
            if (results2.count == 0){
                representatives = Representative.buildRepresentativeList(context: context)
            }
            else{
                representatives = results2 as! [Representative]
            }
            
            senators.sort(by: {
                (first, second) -> Bool in
                return Congressman.sortBy(first: first, second: second)
            })
            representatives.sort(by: {
                (first, second) -> Bool in
                return Congressman.sortBy(first: first, second: second)
            })
            
            
        }//do
        catch{
            print("Error with request: \(error)")
        }

        
    }//viewDidLoad
    
    func viewWillAppear(){
        
        
        
    }//viewWillAppear
    
    func viewDidAppear(){
        
    }//viewDidAppear
    
    //MARK: UITableView Delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }//numberOfSections
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return senators.count
        case 1:
            return representatives.count
        default:
            return 0
        }
    }//numberOfRowsInSection
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Senators"
        case 1:
            return "Representatives"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = congressmanBrowserTableView.dequeueReusableCell(withIdentifier: "congressBrowserCell")!
        var congressMember: Congressman? = nil
        
        switch (indexPath.section){
        case 0:
            congressMember = senators[indexPath.row]
        case 1:
            congressMember = representatives[indexPath.row]
        default:
            break;
        }
        
        cell.textLabel?.text = congressMember!.name
        cell.detailTextLabel?.text = congressMember!.stateAndDistrict()
        
        
        return cell
        
    }//cellForRow
    
}//CongressmanBrowserVC
