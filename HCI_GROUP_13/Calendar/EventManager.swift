//
//  EventManager.swift
//  HCI_GROUP_13
//
//  Created by alex on 10/30/18.
//  Copyright © 2018 John Mooney. All rights reserved.
//

import UIKit

var eventMgr: EventManager = EventManager()

struct event{
    var allDay = false
    var category = "None"
    var date = 0
    var description = "Un-Described"
    var name = "Un-Named"
    var location = "No Location"
    var priority = "Low"
    var timeEnd = 0
    var timeStart = 0
}

class EventManager: NSObject {
    
    var events = [event]()
    
    func addEvent(allDay: Bool, name: String, description: String, date: Int, location: String, priority: String, category: String, timeEnd: Int, timeStart: Int) {
        events.append(event(allDay: allDay, category: category, date: date, description: description, name: name, location: location, priority: priority, timeEnd: timeEnd, timeStart: timeStart))
        
    }
    
    func updateEvent(allDay: Bool, name: String, description:String, date: Int, location: String, priority: String, category: String, timeEnd: Int, timeStart: Int, index: Int) {
        
        events[index].allDay = allDay
        events[index].name = name
        events[index].description = description
        events[index].location = location
        events[index].priority = priority
        events[index].category = category
        events[index].date = date
        events[index].timeEnd = timeEnd
        events[index].timeStart = timeStart
    }
}
