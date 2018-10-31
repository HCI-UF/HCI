//
//  AddEventController.swift
//  HCI_GROUP_13
//
//  Created by alex on 10/28/18.
//  Copyright © 2018 alex. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddEventController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    @IBOutlet weak var eventTxt: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var timeSelect: UISegmentedControl!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var descrTxt: UITextField!
    @IBOutlet weak var locText: UITextField!
    @IBOutlet var prioritySelect: UISegmentedControl!
    @IBOutlet var categorySelect: UISegmentedControl!
    @IBOutlet weak var addBtn: UIButton!
    
    private var datePicker: UIDatePicker?
    private var datePicker_end: UIDatePicker?
    private var timePicker: UIDatePicker?
    private var timePicker_end: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.addTarget(self, action: #selector(addButtonClicked), for: UIControl.Event.touchUpInside)
        
        startTime.isUserInteractionEnabled = false;
        endTime.isUserInteractionEnabled = false;
        startTime.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:0.4)
        endTime.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha: 0.4)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        startDate.inputView = datePicker
        
        datePicker_end = UIDatePicker()
        datePicker_end?.datePickerMode = .date
        datePicker_end?.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        endDate.inputView = datePicker_end
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(timeChanged(sender:)), for: .valueChanged)
        startTime.inputView = timePicker
        
        timePicker_end = UIDatePicker()
        timePicker_end?.datePickerMode = .time
        timePicker_end?.addTarget(self, action: #selector(timeChanged(sender:)), for: .valueChanged)
        endTime.inputView = timePicker_end
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddEventController.viewTapped(gestureRecognizer:)))
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if (sender == datePicker) {
            startDate.text = dateFormatter.string(from: sender.date)
        }
        else if (sender == datePicker_end) {
            endDate.text = dateFormatter.string(from: sender.date)
        }
        //view.endEditing(true)
    }
    
    
    @objc func timeChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if (sender == timePicker) {
            startTime.text = dateFormatter.string(from: sender.date)
        }
        else if (sender == timePicker_end) {
            endTime.text = dateFormatter.string(from: sender.date)
        }
        //view.endEditing(true)
    }
    
    
    @IBAction func timeSelectChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // All day
            startTime.isUserInteractionEnabled = false
            endTime.isUserInteractionEnabled = false
            startTime.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha: 0.4)
            endTime.backgroundColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha: 0.4)
        case 1: // Select times
            startTime.isUserInteractionEnabled = true
            endTime.isUserInteractionEnabled = true
            startTime.backgroundColor = UIColor.white
            endTime.backgroundColor = UIColor.white
        default:
            break
        }
    }
    
    
    @objc func addButtonClicked(sender: UIButton) {
        guard let text = eventTxt.text, !text.isEmpty else {
            return
        }
        guard let text2 = startDate.text, !text2.isEmpty else {
            return
        }
        guard let text3 = endDate.text, !text3.isEmpty else {
            return
        }
        guard let text6 = descrTxt.text, !text6.isEmpty else {
            return
        }
        guard let text7 = locText.text, !text7.isEmpty else {
            return
        }

        ref = Database.database().reference()
        
        var startT = 0
        var endT = 0
        if startTime.text?.isEmpty ?? true {
            startT = 0
        } else {
            startT = Int(convertTimeFormater(startTime.text!))!
        }
        if endTime.text?.isEmpty ?? true {
            endT = 0
        } else {
            endT = Int(convertTimeFormater(endTime.text!))!
        }
        let startD = Int(convertDateFormater(startDate.text!))
        
        let p = prioritySelect.titleForSegment(at: prioritySelect.selectedSegmentIndex)
        let category = categorySelect.titleForSegment(at: categorySelect.selectedSegmentIndex)

        var timeBool = false
        if categorySelect.selectedSegmentIndex == 0 {
            timeBool = true
        }
        eventMgr.addEvent(allDay: timeBool, name: eventTxt.text!, description: descrTxt.text!, date: startD!, location: locText.text!, priority: p!, category: category!, timeEnd: endT, timeStart: startT)
        
        let newEvent = [
            "allDay" : timeBool,
            "name" : eventTxt.text!,
            "description": descrTxt.text!,
            "date": startD!,
            "location": locText.text!,
            "priority": p!,
            "category": category!,
            "timeEnd": endT,
            "timeStart": startT,
            "notify": "none"
            ] as [String : Any]
        ref.child("CalendarView").childByAutoId().setValue(newEvent)
        
        self.view.endEditing(true)
        
        //reset defaults
        eventTxt.text = ""
        startDate.text = ""
        endDate.text = ""
        startTime.text = ""
        endTime.text = ""
        descrTxt.text = ""
        locText.text = ""
        timeSelect.selectedSegmentIndex = 0
        prioritySelect.selectedSegmentIndex = 0
        categorySelect.selectedSegmentIndex = 0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    

    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyyMMdd"
        return  dateFormatter.string(from: date!)
    }
    func convertTimeFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HHmm"
        return  dateFormatter.string(from: date!)
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
