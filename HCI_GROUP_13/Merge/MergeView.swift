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
    
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var sortCategoryButton: UIToolbar!
    @IBOutlet weak var sortPriorityButton: UIToolbar!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showTask: UIView!
    @IBOutlet weak var showEvent: UIView!
    @IBOutlet var entireView: UIView!
    @IBOutlet weak var loadButton: UIButton!
    
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    struct Mtask{
        
        var name: String
        var description: String
        var category: String
        var priority: integer_t
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
    
    var tasks = [Mtask]()
    var events = [event]()
    var merged = [Any]()
    
    var iterator = 0
    var priorityLevel = "All"
    var categoryLevel = "All"
    
    
    func updateView(){
        
        sort()
        filterPriority()
        filterCategory()
        
        
        if(priorityLevel == "All"){
            priorityLabel.isHidden = true
        }
        else{
            priorityLabel.isHidden = false
            priorityLabel.text = priorityLevel
        }
        if(categoryLevel == "All"){
            categoryLabel.isHidden = true
        }
        else{
            categoryLabel.isHidden = false
            categoryLabel.text = categoryLevel
        }
        
        
        if(iterator > merged.count - 1){
            iterator = merged.count - 1
        }
        if merged.count == 0 {
            iterator = 0
            showTask.isHidden = true
            showEvent.isHidden = true
            prevButton.isHidden = true
            nextButton.isHidden = true
            return
        }
        else if merged.count == 1{
            iterator = 0
            prevButton.isHidden = true
            nextButton.isHidden = true
        }
        else if merged.count >= 2 {
            nextButton.isHidden = false
            
        }
        
        
        
        let currStruct = merged[iterator]
        
        if currStruct is Mtask{
            
            showTask.isHidden = false
            showEvent.isHidden = true
            
            let currTask = currStruct as! Mtask
            
            
            taskName.text = currTask.name
            taskDesc.text = "Description: " + currTask.description
            taskCat.text = "Category: " + currTask.category
            
            if(currTask.priority == 1){
                taskPrio.text = "Priority: Low"

            }
            else if(currTask.priority == 2){
                taskPrio.text = "Priority: Medium"

            }
            else if(currTask.priority == 3){
                taskPrio.text = "Priority: High"           }
            
            
            taskRem.text = "Remind: " + currTask.remind
            
        }
        
        if currStruct is event{
            
           
            
            showTask.isHidden = true
            showEvent.isHidden = false
            
            let currEvent = currStruct as! event
            
            
            print("Allday, start time and end time is: ")
            print(currEvent.name)
            print(currEvent.allDay)
            print(currEvent.timeStart)
            print(currEvent.timeEnd)
            
            eventName.text = currEvent.name
            
            let year = currEvent.date / 10000
            let month = (currEvent.date - year * 10000) / 100
            let day = ((currEvent.date - year * 10000) - month * 100)
            
            eventDate.text = "Date: " + String(month) + "/" + String(day) + "/" + String(year)
            
            if(currEvent.allDay){
                print(String(Int(currEvent.timeStart)))
                eventTimeStart.text = "Time Start: " + String(Int(currEvent.timeStart))
                eventTimeEnd.text = "Time End: " + String(Int(currEvent.timeEnd))
            }
            else{
                eventTimeStart.text = "All Day"
                eventTimeEnd.text = ""
            }
            
            
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
        //taskPrio.text = "Priority: " + currStruct.priority
        taskRem.text = "Remind: " + currStruct.remind
        
        
    }
    
    func updateEvent(){
        /*print("This is being printed during updateEvent method: ")
        print(events)
        print(tasks)*/
        
        //sort()
        
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
       
        let dateFormat = (year * 10000) + (month * 100) + day
        
        //let dateAndTime = (dateFormat * 100 + hour)
        
        var sorted = [Any]()
        
        sorted = events.sorted { (($0.date * 100) + $0.timeStart) < (($1.date * 100) + $1.timeStart) }
        
        var sortedTasks = [Any]()
        
        sortedTasks = tasks.sorted { ($0.priority > $1.priority) }
        
        //print(sorted)
        
        for i in 0 ..< tasks.count{
            
            let iTask = sortedTasks[i] as! Mtask
            var dateTemp = Int(dateFormat)
            
            if(iTask.priority == 1){ //low
                dateTemp = dateTemp + 3
            }
            else if(iTask.priority == 2){  //medium
                dateTemp = dateTemp + 1
            }
            else{ //high
                //do nothing
            }
            
            var wasSorted = false
            
            for j in 0 ..< sorted.count{
                
                if(sorted[j] is Mtask){
                    continue
                }
                
                let jEvent = sorted[j] as! event
                let jDate = jEvent.date
                
                if(jDate >= dateTemp){
                    
                    sorted.insert(iTask, at: j)
                    wasSorted = true
                    break
                    
                }
            }
            
            if(wasSorted == false){
                sorted.append(iTask)
            }
            
            
            
        }
        

        
        //print(sorted)
        
        merged = sorted
        
       
        
        
    
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
        updateData()
        

        
        
    }
    
    
    func updateTaskList(){
        
        self.tasks.removeAll()
        
        var currTask = Mtask(name: "", description: "", category: "", priority: 0, remind: "")
        
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
                            currTask.priority = rest2.value as! integer_t
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
            
        })
        
        
    }
    
    
    func updateData(){
        
        merged.removeAll()
        
        updateEventsList()
        updateTaskList()
        getLocalTasks()
        

    
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
    
    func filterPriority(){
        
        if(priorityLevel == "All"){
            return //Don't filter
        }
        
        if(merged.count == 0){
            return
        }
        
        var filtered = [Any]()
        
        
        print("Merged is: ")
        print(merged)
        print("Merged count is: ")
        print(merged.count)
        
        for i in 0 ..< merged.count{
        
            var tempPriority = ""
        
            if merged[i] is Mtask{
                
                let currTask = merged[i] as! Mtask
                
                if(currTask.priority == 1){
                    
                    tempPriority = "Low"
                }
                else if(currTask.priority == 2){
                    tempPriority = "Medium"
                }
                else{
                    tempPriority = "High"
                }
            }
            else{
                let currEvent = merged[i] as! event
                
                tempPriority = currEvent.priority
            }
        
            if(tempPriority == priorityLevel){
                print("tempPriority is: ")
                print(tempPriority)
                print("priorityLevel is: ")
                print(priorityLevel)
                filtered.append(merged[i])
            }
            
        }
  
        print("filtered is: ")
        print(filtered)
        print("filtered count is: ")
        print(filtered.count)
        
        merged = filtered
        
    }
    
    func filterCategory(){
        
        if(categoryLevel == "All"){
            return //Don't filter
        }
        if(merged.count == 0){
            return
        }
        
        var filtered = [Any]()
        
        for i in 0 ..< merged.count{
            
            var tempCategory = ""
            
            if merged[i] is Mtask{
                
                let currTask = merged[i] as! Mtask
               
                tempCategory = currTask.category
               
            }
            else{
                let currEvent = merged[i] as! event
                
                tempCategory = currEvent.category
            }
            
            if(tempCategory == categoryLevel){
                filtered.append(merged[i])
            }
            
        }
        
        merged = filtered
        
    }
    
    
    @IBAction func changePriorityLevel(_ sender: Any) {
        //categoryLevel = "All"
        iterator = 0
        prevButton.isHidden = true
        nextButton.isHidden = false
        print(priorityLevel)
        if(priorityLevel == "All"){
            priorityLevel = "High"
            updateView()
            updateData()
            return
        }
        else if(priorityLevel == "High"){
            priorityLevel = "Medium"
            updateView()
            updateData()
            return
        }
        else if(priorityLevel == "Medium"){
            priorityLevel = "Low"
            updateView()
            updateData()
            return
        }
        else{
            priorityLevel = "All"
            updateView()
            updateData()
            return
        }
        
    }
    
    @IBAction func changeCategoryLevel(_ sender: Any) {
        iterator = 0
        //priorityLevel = "All"
        print(categoryLevel)
        if(categoryLevel == "All"){
            categoryLevel = "Home"
            updateView()
            return
        }
        else if(categoryLevel == "Home"){
            categoryLevel = "Social"
            updateView()
            return
        }
        else if(categoryLevel == "Social"){
            categoryLevel = "School"
            updateView()
            return
        }
        else{
            categoryLevel = "All"
            updateView()
            return
        }
        
        
    }
    
    
    
    
    func getLocalTasks(){
        
        var localTasks = [task]()
        
        localTasks = taskMgr.tasks
        
        let localSize = localTasks.count
        
        
        for i in 0 ..< localSize{
            
            let currTask = localTasks[i]
            let desc = currTask.desc
            let cat = currTask.cat
            let prio = integer_t(currTask.priority) + 1
            let name = currTask.name
            
            
            let currMtask = Mtask(name: name
                , description: desc
                , category: cat
                , priority: prio
                , remind: "")
            
            
            
            
            tasks.append(currMtask);
            merged.append(currMtask);
        }
    
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        

        
        prevButton.tag = 0
        nextButton.tag = 1
        
        iterator = 0
        updateData()
        updateView()
        
        scheduledTimerWithTimeInterval()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    var timer = Timer()
   
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds

        var refreshTimer: Timer!

        refreshTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)

    }
    
   @objc func runTimedCode(){
    
        updateView()
    
        print("hi")
    
    }
    

}
