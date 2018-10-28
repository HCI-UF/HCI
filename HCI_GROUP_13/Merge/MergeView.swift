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

    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showTask: UIView!
    @IBOutlet weak var showEvent: UIView!
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDesc: UILabel!
    @IBOutlet weak var taskPrio: UILabel!
    @IBOutlet weak var taskRem: UILabel!
    @IBOutlet weak var taskCat: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTimeStart: UILabel!
    @IBOutlet weak var eventTimeEnd: UILabel!
    @IBOutlet weak var eventLoc: UILabel!
    @IBOutlet weak var eventCat: UILabel!
    @IBOutlet weak var eventPrio: UILabel!
    @IBOutlet weak var eventNoti: UILabel!
    


    
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
    var merged = [Any]()
    
    var iterator = 0
    
    
    func updateView(){
        
        let currStruct = merged[iterator]
        
        if currStruct is task{
            
            showTask.isHidden = false
            showEvent.isHidden = true
            
            let currTask = currStruct as! task
            
            taskName.text = currTask.name
            taskDesc.text = "Description: " + currTask.description
            taskCat.text = "Category: " + currTask.category
            taskPrio.text = "Priority: " + currTask.priority
            taskRem.text = "Remind: " + currTask.remind
            
        }
        
        if currStruct is event{
            
            showTask.isHidden = true
            showEvent.isHidden = false
            
            let currEvent = currStruct as! event
            
            eventName.text = currEvent.name
            eventDate.text = "Date: " + String(currEvent.date)
            eventTimeStart.text = "Time Start: " + String(currEvent.timeStart)
            eventTimeEnd.text = "Time End: " + String(currEvent.timeEnd)
            eventLoc.text = "Location: " + currEvent.location
            eventCat.text = "Category: " + currEvent.category
            eventPrio.text = "Priority: " + currEvent.priority
            eventNoti.text = "Notify: " + currEvent.notify
  
        }
        
        
        
    }
    
    
    func updateTask(){
        let currStruct = tasks[iterator]
        taskName.text = currStruct.name
        taskDesc.text = "Description: " + currStruct.description
        taskCat.text = "Category: " + currStruct.category
        taskPrio.text = "Priority: " + currStruct.priority
        taskRem.text = "Remind: " + currStruct.remind
        
        
    }
    
    func updateEvent(){
        /*print("This is being printed during updateEvent method: ")
        print(events)
        print(tasks)*/
        
        sort()
        
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
    
    func sort(){
    
        //print(tasks)
        //print(events)
 
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        //let minutes = calendar.component(.minute, from:date)
       
        let dateFormat = (month * 1000000) + (day * 10000) + year
        
        var sorted = [Any]()
        
      /*  for i in 0 ..< events.count{
        
            let iEvent = events[i]
            
            
            for j in 0 ..< sorted.count{
                
                let jEvent = sorted[j]
                
                if(jEvent)
                
                
                
                
                
            }
            
            if sorted.isEmpty{
                sorted.append(events[i])
            }
 
        }
        
        */
    
    }
    
    
    
    
    @IBAction func prevNextEvent(_ sender: UIButton) {
        
        //updateMerged()
        
      //  print(merged)
      //  print("merged count is: ")
      //  print(merged.count - 1)
        
        if (sender.tag == 1){
            iterator = iterator + 1
            print("iterator is: ")
            print(iterator)
            updateView()
        }
        else if(sender.tag == 0){
            iterator = iterator - 1
            print("iterator is: ")
            print(iterator)
            updateView()
            
        }
        
        
        
        if(iterator == 0){
            prevButton.isHidden = true
        }
        else{
            prevButton.isHidden = false
        }
        
        if(iterator == (merged.count - 1)){
            nextButton.isHidden = true
        }
        else{
            nextButton.isHidden = false
        }
        
        //print(iterator)
        //updateEventsList()
        
        sort()
        updateData()
        

        
        
    }
    
    
    func updateTaskList(){
        
        //self.tasks.removeAll()
        
        //var currTask = task(name: "", description: "", category: "", priority: "", remind: "")
        
        let ref = Database.database().reference()
        /*
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
                    self.merged.append(currTask)
                    
                    
                }
                
                
            }
            
        })*/
        
        
    }
    
    
    func updateData(){
        
        merged.removeAll()
        
        updateEventsList()
        updateTaskList()
        

    
    }
    
    
    func updateEventsList(){
        
        events.removeAll()
        //print("This is the events list after removal: ")
        //print(events)
        
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
                   // print("This is the events list after adding: ")
                   // print(self.events)

                }
                
            }
        })
        
        //print("This is the events list at the very end of the function: ")
        //print(events)
        //print(self.events)
        
    }
    
 
  
 
    override func viewDidLoad() {
        

        
        prevButton.tag = 0
        nextButton.tag = 1
        
        
        //print("Test1")
        
        //updateData()
        updateTaskList()
        
        //print("Test2")
        
        super.viewDidLoad()
        
    }
    

}
