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

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var taskPrio: UILabel!
    @IBOutlet weak var taskRem: UILabel!
    @IBOutlet weak var taskCat: UILabel!
    
    @IBOutlet  var eventName: UILabel!
    @IBOutlet  var eventDate: UILabel!
    @IBOutlet  var eventTimeStart: UILabel!
    @IBOutlet  var eventTimeEnd: UILabel!
    @IBOutlet  var eventLoc: UILabel!
    @IBOutlet  var eventCat: UILabel!
    @IBOutlet  var eventPrio: UILabel!
    @IBOutlet  var eventNoti: UILabel!
    
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showTask: UIView!
    @IBOutlet weak var showEvent: UIView!
    @IBOutlet var entireView: UIView!
    
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    struct task{
        
        var name: String
        var description: String
        var category: String
        var priority: String
        var remind: String
        
    }
    
    struct event{
        
        var name: String
        var description: String
        var date: integer_t
        var allDay: BooleanLiteralType
        var timeStart: integer_t
        var timeEnd: integer_t
        var location: String
        var category: String
        var priority: String
        var notify: String
        
    }
    
    var tasks = [task]()
    var events = [event]()
    var merged = [event]()
    
    var iterator = 0
    
    
    func updateTask(){
        let currStruct = tasks[iterator]
        taskName.text = currStruct.name
        taskDesc.text = "Description: " + currStruct.description
        taskCat.text = "Category: " + currStruct.category
        taskPrio.text = "Priority: " + currStruct.priority
        taskRem.text = "Remind: " + currStruct.remind
        showTask.reloadInputViews()
        print(taskName.text)
        
    }
    
    func updateEvent(){
        let currStruct = events[iterator]
        eventName.text = currStruct.name
        eventDate.text = "Date: " + String(currStruct.date)
        eventTimeStart.text = "Time Start: " + String(currStruct.timeStart)
        eventTimeEnd.text = "Time End: " + String(currStruct.timeEnd)
        eventLoc.text = "Location: " + currStruct.location
        eventCat.text = "Category: " + currStruct.category
        eventPrio.text = "Priority: " + currStruct.priority
        eventNoti.text = "Notify: " + currStruct.notify
    }
    
    @IBAction func prevNextEvent(_ sender: UIButton) {
        
        //updateMerged()
        
        if (sender.tag == 1){
            iterator = iterator + 1
            updateEvent()
        }
        else if(sender.tag == 0){
            iterator = iterator - 1
            updateEvent()
            
        }
        
        if(iterator == 0){
            prevButton.isHidden = true
        }
        else{
            prevButton.isHidden = false
        }
        
        if(iterator == (events.count - 1)){
            nextButton.isHidden = true
        }
        else{
            nextButton.isHidden = false
        }
        
        print(iterator)
        //updateEventsList()
        updateMergedList()

        
        
    }
    
    
    func updateTaskList(){
        
        self.tasks.removeAll()
        
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
                            currTask.name = rest2.value as! String
                        }
                        else if (taskKey == "Description"){
                            currTask.description = rest2.value as! String
                        }
                        else if (taskKey == "Category"){
                            currTask.category = rest2.value as! String
                        }
                        else if (taskKey == "Priority"){
                            currTask.priority = rest2.value as! String
                        }
                        else if (taskKey == "Remind"){
                            currTask.remind = rest2.value as! String
                        }
                        
                        
                    }
                    
                    //print(currTask)
                    self.tasks.append(currTask)
                    //self.merged.append(currTask)
                    
                }
                
                
            }
            
        })
        
    }
    
    
    func updateEventsList(){
        
        events.removeAll()
        
        var currEvent = event(name: "", description: "", date: 0, allDay: false, timeStart: 0, timeEnd: 0, location: "", category: "", priority: "", notify: "")
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("CalendarView").observe(.value, with: { (snapshot) in
            
            if(snapshot.exists() == false){
                //Data Not Found -- Nothing Happens
            }
            else{
                
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    
                    let enumerator2 = rest.children
                    
                    while let rest2 = enumerator2.nextObject() as? DataSnapshot{
                        
                        let eventKey = rest2.key
                        
                        if(eventKey == "name"){
                            currEvent.name = rest2.value as! String
                        }
                        else if (eventKey == "description"){
                            currEvent.description = rest2.value as! String
                        }
                        else if (eventKey == "category"){
                            currEvent.category = rest2.value as! String
                        }
                        else if (eventKey == "priority"){
                            currEvent.priority = rest2.value as! String
                        }
                        else if (eventKey == "notify"){
                            currEvent.notify = rest2.value as! String
                        }
                        else if (eventKey == "date"){
                            currEvent.date = rest2.value as! integer_t
                        }
                        else if (eventKey == "timeStart"){
                            currEvent.timeStart = rest2.value as! integer_t
                        }
                        else if (eventKey == "timeEnd"){
                            currEvent.timeEnd = rest2.value as! integer_t
                        }
                        else if (eventKey == "allDay"){
                            currEvent.allDay = rest2.value as! BooleanLiteralType
                        }
                        else if (eventKey == "location"){
                            currEvent.location = rest2.value as! String
                        }
                        
                    }
                    
                    self.events.append(currEvent)
                    self.merged.append(currEvent)

                    
                }
                
                
            }
            
        })
        
    }
    
    
    
    func updateMergedList(){
        
        merged.removeAll()
        
        //updateTaskList()
        updateEventsList()
        
        print(merged)
        print(events)
        print(tasks)
        //print(events.count)
        
    }
 
    
    override func viewDidLoad() {
        

        
        prevButton.tag = 0
        nextButton.tag = 1
        
        //updateTaskList()
        updateEventsList()
        
        super.viewDidLoad()
        
    }
    

}
