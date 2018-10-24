//
//  FirstViewController.swift
//  HCI_GROUP_13
//
//  Created by John Mooney on 10/11/18.
//  Copyright © 2018 John Mooney. All rights reserved.
//

import UIKit

var selectedCellNumber = 0

class taskTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblTasks: UITableView!
    @IBOutlet var sort: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //list update
    override func viewWillAppear(_ animated: Bool) {
        tblTasks.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskMgr.tasks.count
    }

    //populate description of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "test")
        
        cell.textLabel?.text = taskMgr.tasks[indexPath.row].name
        cell.detailTextLabel?.text = taskMgr.tasks[indexPath.row].desc
        if taskMgr.tasks[indexPath.row].cat == "Home" {
            cell.backgroundColor = UIColor.orange
        }
        else if taskMgr.tasks[indexPath.row].cat == "School" {
            cell.backgroundColor = UIColor.yellow
        }
        else {
            cell.backgroundColor = UIColor.green
        }
        
        
        let button: UIButton = UIButton(type:UIButton.ButtonType.custom) as UIButton
        let label: UILabel = UILabel() as UILabel
        
        button.frame = CGRect(origin: CGPoint(x: 50, y: 60), size: CGSize(width: 70, height: 24))
        let cellHeight: CGFloat = 44.0
        button.center = CGPoint(x: view.bounds.width - 50, y: cellHeight / 2.0)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        button.setTitle("Details", for: UIControl.State.normal)
        button.tag = indexPath.row
        button.addTarget(self, action: #selector(detailsButtonTapped), for: UIControl.Event.touchUpInside)
 
        cell.addSubview(button)
 
        label.frame = CGRect(x: 10, y: 10, width: 50, height: 30)
        label.center = CGPoint(x: view.bounds.width - 100, y: 22)
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 36)//set font here
        
        if taskMgr.tasks[indexPath.row].priority == 0 {
            label.text = "!"
        }
        else if taskMgr.tasks[indexPath.row].priority == 1 {
            label.text = "!!"
        }
        else {
            label.text = "!!!"
        }
        
        cell.addSubview(label)
        
        cell.tag = indexPath.row
        
        return cell
    }

    @objc func detailsButtonTapped(_ sender: UIButton!) {
        let buttonPosition : CGPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.tblTasks)
        let indexPath = self.tblTasks.indexPathForRow(at: buttonPosition)
        selectedCellNumber = indexPath!.row
        
    }
    // go to Cell Description
    @objc func buttonClicked(sender : UIButton!) {
        if sender.titleLabel?.text == "Details" {
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.5, execute: {
                self.performSegue(withIdentifier: "ListToDetails",sender: self)
            })
        }
 
    }
    
    @IBAction func sortPriorityButtonTap(_ sender: Any) {
        taskMgr.tasks = taskMgr.sortPriority(taskMgr.tasks)
        tblTasks.reloadData()
        
    }
    
    @IBAction func sortNameButtonTap(_ sender: Any) {
        taskMgr.tasks = taskMgr.sortName(taskMgr.tasks)
        tblTasks.reloadData()
        
    }
    
    
    //delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            taskMgr.tasks.remove(at: indexPath.row)
            tblTasks.reloadData()
        }
    }
}

