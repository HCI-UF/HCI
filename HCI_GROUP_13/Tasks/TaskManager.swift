import UIKit

var taskMgr: TaskManager = TaskManager()

struct task{
    var name = "Un-Named"
    var desc = "Un-Described"
    var loc = "No Location"
    var priority = 0
    var cat = "None"
}

class TaskManager: NSObject {
    
    var tasks = [task]()
    
    func addTask(name: String, desc:String, loc: String, priority: Int, cat: String){
        tasks.append(task(name: name, desc: desc, loc: loc, priority: priority, cat: cat))
    }
    
    func updateTask(name: String, desc: String, loc: String, priority: Int, cat: String, index: Int){
        
        
        tasks[index].name = name
        tasks[index].desc = desc
        tasks[index].loc = loc
        tasks[index].priority = priority
        tasks[index].cat = cat
        
        
        
    }
    
    func sortPriority(_ tasks: [task]) -> [task]{
        
        guard tasks.count > 1 else {return tasks}
        let pivot = tasks[tasks.count/2]
        let less = tasks.filter {$0.priority > pivot.priority}
        let equal = tasks.filter {$0.priority == pivot.priority}
        let greater = tasks.filter { $0.priority < pivot.priority}
        
        return sortPriority(less) + equal + sortPriority(greater)
    }
    
    
    func sortName(_ tasks: [task]) -> [task]{
        
        guard tasks.count > 1 else {return tasks}
        let pivot = tasks[tasks.count/2]
        let less = tasks.filter {$0.name < pivot.name}
        let equal = tasks.filter {$0.name == pivot.name}
        let greater = tasks.filter { $0.name > pivot.name}
        
        return sortName(less) + equal + sortName(greater)
    }
}
