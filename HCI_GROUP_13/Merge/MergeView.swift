//
//  mergeView.swift
//  HCI_GROUP_13
//
//  Created by Tyler Fonzi  on 10/23/18.
//  Copyright © 2018 John Mooney. All rights reserved.
//

import UIKit

class MergeView: UIViewController {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDesc: UILabel!
    @IBOutlet weak var eventCat: UILabel!
    @IBOutlet weak var eventPrio: UILabel!
    @IBOutlet weak var eventRem: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var eventNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        prevButton.tag = 0
        nextButton.tag = 1
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToCalendarView(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func goToTaskView(_ sender: UIBarButtonItem) {
    }
    
   /*
    @IBAction func nextEventButton(_ sender: Any) {
        eventNumber = eventNumber + 1
        eventName.text = String(eventNumber)
        eventDesc.text = "Right"
        eventCat.text = "Right"
        eventPrio.text = "Right"
        eventRem.text = "Right"
        self.viewDidLoad()

    }
    
    
    @IBAction func prevEventButton(_ sender: Any) {
        eventNumber = eventNumber - 1
        eventName.text = String(eventNumber)
        eventDesc.text = "Left"
        eventCat.text = "Left"
        eventPrio.text = "Left"
        eventRem.text = "Left"
        
        self.viewDidLoad()
    }
    */
    
    @IBAction func prevNextEvent(_ sender: UIButton) {
        
        if (sender.tag == 1){
            eventNumber = eventNumber + 1
            eventName.text = String(eventNumber)
            eventDesc.text = "Right"
            eventCat.text = "Right"
            eventPrio.text = "Right"
            eventRem.text = "Right"
            self.viewDidLoad()

        }
        if(sender.tag == 0){
            eventNumber = eventNumber - 1
            eventName.text = String(eventNumber)
            eventDesc.text = "Left"
            eventCat.text = "Left"
            eventPrio.text = "Left"
            eventRem.text = "Left"
            self.viewDidLoad()
            
        }
     
        
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
