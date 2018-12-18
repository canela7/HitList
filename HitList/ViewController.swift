//
//  ViewController.swift
//  HitList
//
//  Created by Brian Canela on 12/17/18.
//  Copyright © 2018 Brian Canela. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var people: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func addName(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else{
                return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    func save(name:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
             return
        }
        
        //GET REFERENCE TO APP DELEGATE
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE MANAGED OBJECT CONTEXT
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //SET THE NAME ATTRIBUTE
        person.setValue(name, forKey: "name")
        
        //COMMIT CHANGES TO PERSON AND SAVE TO DISK
        do {
            try managedContext.save()
            people.append(person)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    
}


//Mark: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String   //names[indexPath.row]
        
        return cell
    }
    
    
    
    
    
}
