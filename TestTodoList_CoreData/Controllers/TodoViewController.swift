//
//  ViewController.swift
//  TestTodoList(realm)
//
//  Created by Amir Daliri on 9/13/19.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var list : [Todo] = []
    var currentCreateAction:UIAlertAction!
    var isEditingMode = false

    // Managed Object Context
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Alert Methode
    
    private func showAddAlert() {
        let alert = UIAlertController(
            title: "New Task",
            message: "What do you want to do?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }
            
            self.save(task)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    func showEditAlert(at row: Int) {
        let alert = UIAlertController(
            title: "Edit task",
            message: "Do you want to change this?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }
            
            self.update(at: row, newTaskName: task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.textFields?.first?.text = list[row].name
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Action Methode

    
    @objc func listNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.count)! > 0
    }

    @IBAction func addBarButtonItemTapped(_ sender: UIBarButtonItem) {
        showAddAlert()
    }
    
    @IBAction func editBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.tableView.setEditing(isEditingMode, animated: true)
    }
}

// MARK: - UItableView Methode

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableViewCell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditAlert(at: indexPath.row)

    }
}




extension TodoViewController {
    
    // MARK: - Work with Core Data
    func save(_ taskName: String) {
        
        // Entity Description
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext) else { return }
        
        // Entity (Task model instance from Core Data)
        let task = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Todo
        task.name = taskName
        
        // Saving
        do {
            try managedContext.save()
            list.append(task)
            self.tableView.insertRows(
                at: [IndexPath(row: self.list.count - 1, section: 0)],
                with: .automatic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Fetch Data

    func fetchData() {
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            list = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Delete Data

    func delete(at index: Int) {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            let taskToDelete = tasks[index] as NSManagedObject
            managedContext.delete(taskToDelete)
            self.list.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Update Data

    func update(at index: Int, newTaskName: String) {
        
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            let taskToUpdate = tasks[index] as NSManagedObject
            taskToUpdate.setValue(newTaskName, forKey: "name")
            
            self.list[index].name = newTaskName
            self.tableView.reloadRows(
                at: [IndexPath(row: index, section: 0)],
                with: .automatic)
            
            do {
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
