import UIKit

class AddTaskController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtTask: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet var txtLoc:  UITextField!
    @IBOutlet var prioritySelc: UISegmentedControl!
    @IBOutlet var categorySelc: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //add task to array
    @IBAction func buttonAddTask_Click(sender: UIButton) {
        let prior = prioritySelc.titleForSegment(at: prioritySelc.selectedSegmentIndex)
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
        let category = categorySelc.titleForSegment(at: categorySelc.selectedSegmentIndex)
        
        taskMgr.addTask(name: txtTask.text!, desc: txtDesc.text!, loc: txtLoc.text!, priority: priorNum, cat: category!)
        
        self.view.endEditing(true)
        
        txtTask.text = ""
        txtDesc.text = ""
        txtLoc.text = ""
        prioritySelc.selectedSegmentIndex = 0
        categorySelc.selectedSegmentIndex = 0
        
        
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

