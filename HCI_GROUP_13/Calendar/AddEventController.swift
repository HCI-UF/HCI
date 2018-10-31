//
//  AddEventController.swift
//  HCI_GROUP_13
//
//  Created by alex on 10/28/18.
//  Copyright © 2018 John Mooney. All rights reserved.
//

import UIKit

class AddEventController: UIViewController {


    @IBOutlet weak var eventTxt: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var timeSelect: UISegmentedControl!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var descrTxt: UITextField!
    @IBOutlet weak var locText: UITextField!
    @IBOutlet weak var prioritySelect: UISegmentedControl!
    @IBOutlet weak var categorySelect: UISegmentedControl!
    

    private var datePicker: UIDatePicker?
    private var datePicker_end: UIDatePicker?
    private var timePicker: UIDatePicker?
    private var timePicker_end: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    //add task to array
    @IBAction func buttonAddEvent_Click(sender: UIButton) {
        let prior = prioritySelect.titleForSegment(at: prioritySelect.selectedSegmentIndex)
        var priorNum = 0
        if prior == "Low" {
            priorNum = 0
        }
        else if prior == "Medium" {
            priorNum = 1
        }
        else {
            priorNum = 2
        }
        let category = categorySelect.titleForSegment(at: categorySelect.selectedSegmentIndex)
        
        //taskMgr.addTask(name: eventTxt.text!, desc: descrTxt.text!, loc: locTxt.text!, priority: priorNum, cat: category!)
        
        self.view.endEditing(true)
        
        eventTxt.text = ""
        descrTxt.text = ""
        locText.text = ""
        prioritySelect.selectedSegmentIndex = 0
        categorySelect.selectedSegmentIndex = 0
        
        
    }
    
    //descelect type
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
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
