//
//  mergeView.swift
//  HCI_GROUP_13
//
//  Created by Tyler Fonzi  on 10/23/18.
//  Copyright © 2018 John Mooney. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MergeView: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventCat: UILabel!
    @IBOutlet weak var eventPrio: UILabel!
    @IBOutlet weak var eventRem: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    struct task{
        
        var name: String?
        var description: String?
        var category: String?
        var priority: String?
        var remind: String?
        
    }
    
    var tasks = [task]()
    
    var eventNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        prevButton.tag = 0
        nextButton.tag = 1
        
        updateTaskList()
        
       /* let currStruct = tasks[eventNumber]
        eventName.text = currStruct.name
        eventDesc.text = currStruct.description
        eventCat.text = currStruct.category
        eventPrio.text = currStruct.priority
        eventRem.text = currStruct.remind
        */
    }
    

    @IBAction func goToCalendarView(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func goToTaskView(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func prevNextEvent(_ sender: UIButton) {
        
        
        if (sender.tag == 1){
            eventNumber = eventNumber + 1
            let currStruct = tasks[eventNumber]
            eventName.text = currStruct.name
            eventDesc.text = currStruct.description
            eventCat.text = currStruct.category
            eventPrio.text = currStruct.priority
            eventRem.text = currStruct.remind
        }
        else if(sender.tag == 0){
            eventNumber = eventNumber - 1
            let currStruct = tasks[eventNumber]

            eventName.text = currStruct.name
            eventDesc.text = currStruct.description
            eventCat.text = currStruct.category
            eventPrio.text = currStruct.priority
            eventRem.text = currStruct.remind
        }
        
        if(eventNumber == 0){
            prevButton.isHidden = true
        }
        else{
            prevButton.isHidden = false
        }
        
        if(eventNumber == 2){
            nextButton.isHidden = true
        }
        else{
            nextButton.isHidden = false
        }
    }
    

    func updateTaskList(){
        
        var currTask = task(name: "", description: "", category: "", priority: "", remind: "")
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("TaskView").observe(.value, with: { (snapshot) in
            
            if(snapshot.exists() == false){
                //Data Not Found -- Nothing Happens
            }
            else{
                
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    
                    let enumerator2 = rest.children
                    
                    while let rest2 = enumerator2.nextObject() as? DataSnapshot{
                        
                        let taskKey = rest2.key
                        
                        if(taskKey == "Name"){
                            currTask.name = rest2.value as? String
                        }
                        else if (taskKey == "Description"){
                            currTask.description = rest2.value as? String
                        }
                        else if (taskKey == "Category"){
                            currTask.category = rest2.value as? String
                        }
                        else if (taskKey == "Priority"){
                            currTask.priority = rest2.value as? String
                        }
                        else if (taskKey == "Remind"){
                            currTask.remind = rest2.value as? String
                        }
                        
                        
                    }
                    
                    self.tasks.append(currTask)
                    
                }
                
            
            }
            
        })
        
    }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
