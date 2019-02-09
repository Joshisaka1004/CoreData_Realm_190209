//
//  ViewController.swift
//  CoreData_Realm_190209
//
//  Created by Joachim Vetter on 09.02.19.
//  Copyright © 2019 Joachim Vetter. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {

    var myList = [List]()
    
    let myAppPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let myFetch = NSFetchRequest<List>(entityName: "List")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadIt()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        myCell.textLabel?.text = myList[indexPath.row].task!
        return myCell
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var finalTextField = UITextField()
        
        let myAlert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let newTask = List(context: self.myContext)
            newTask.task = finalTextField.text!
            self.myList.append(newTask)
            self.saveIt()
        }
        
        myAlert.addAction(myAction)
        myAlert.addTextField { (myTextField) in
            finalTextField = myTextField
        }
        present(myAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailVC" {
            if let myPath = tableView.indexPathForSelectedRow {
                let myDestinationVC = segue.destination as! DetailVC
                myDestinationVC.test = myList[myPath.row].task!
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailVC", sender: self)
    }
    
    func loadIt() {
        do {
            myList = try myContext.fetch(myFetch)
        }
        catch {
            print("This error is an \(error)")
        }
        self.tableView.reloadData()
    }
    
    func saveIt() {
        
        do {
            try myContext.save()
        }
        catch {
            print("This error is an \(error)")
        }
        self.tableView.reloadData()
    }
}

