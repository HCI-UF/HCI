//
//  ViewController.swift
//  calendar
//
//  Created by Joshua John on 10/22/18.
//  Copyright © 2018 Joshua John. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    
//    var handle:DatabaseHandle?
    var ref:DatabaseReference?
    
    let outsideMonthColor = #colorLiteral(red: 0.3450980392, green: 0.2901960784, blue: 0.4, alpha: 1)
    let monthColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let selectedMonthColor = #colorLiteral(red: 0.2274509804, green: 0.1607843137, blue: 0.2941176471, alpha: 1)
    let currentDateSelectedViewColor = #colorLiteral(red: 0.3058823529, green: 0.2470588235, blue: 0.3647058824, alpha: 1)
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        ref = Database.database().reference()
        
        ref?.child("CalendarView").observe(DataEventType.value, with: {(snapshot) in
            
            if snapshot.childrenCount > 0 {
                for CalendarView in snapshot.children.allObjects as! [DataSnapshot]{
                    let calendarObject = CalendarView.value as? [String: AnyObject]
                    let name = calendarObject?["name"]
                    let allDay = calendarObject?["allDay"]
                    let category = calendarObject?["category"]
                    let date = calendarObject?["date"]
                    let description = calendarObject?["description"]
                    let location = calendarObject?["location"]
                    let priority = calendarObject?["priority"]
                    let timeEnd = calendarObject?["timeEnd"]
                    let timeStart = calendarObject?["timeStart"]
                    
                    eventMgr.events.append(event(allDay: (allDay != nil), category: (category as! String), date: (date as! Int), description: (description as! String), name: (name as! String), location: (location as! String), priority: (priority as! String), timeEnd: (timeEnd as! Int), timeStart: (timeStart as! Int)))
                    self.myTableView.reloadData()
                }
            }
//            if let item = snapshot.value as? String{
//                self.myList.append(item)
//                self.myTableView.reloadData()
//            }
        })
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //set up previews
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventMgr.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"table")
        cell.textLabel?.text = eventMgr.events[indexPath.row].name
        return cell
    }
    // finished setting up previews
    
    func setupCalendarView(){
        // setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // setup labels
        calendarView.visibleDates{(visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
            
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else{return}
        
        if cellState.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else {return}
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMM"
        self.month.text = self.formatter.string(from: date)    }
}

extension ViewController: JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        _ = cell as! CustomCell
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")
        let endDate = formatter.date(from: "2018 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate:endDate!)
        return parameters
    }
}

extension ViewController:JTAppleCalendarViewDelegate{
    //display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    //select
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    //deselect
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}
