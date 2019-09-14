//
//  ViewController.swift
//  TestTodoList(realm)
//
//  Created by Amir Daliri on 9/13/19.
//  Copyright © 2019 Amir Daliri. All rights reserved.
//

import UIKit

class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var lists : Results<TodoList>!
    var currentCreateAction:UIAlertAction!
    var isEditingMode = false

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
    
    
    // MARK: - Fetch Data Methode

    func fetchData() {
        lists = uiRealm.objects(TodoList.self)
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    // MARK: - Alert Methode
    
    func showListAlert(_ updatedList: TodoList!) {
        var title = "New Tasks List"
        var doneTitle = "Create"
        if updatedList != nil{
            title = "Update Tasks List"
            doneTitle = "Update"
        }

        let alert = UIAlertController(title: title, message: "Write the name of your tasks list.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: {(Bool) in })
        let action = UIAlertAction(title: doneTitle, style: .default) { (actopn) in
            let listName = alert.textFields?.first?.text
            self.listAlertAction(updatedList, listName: listName)
        }
        
        alert.addAction(action)
        action.isEnabled = false
        self.currentCreateAction = action
        alert.addAction(cancel)

        alert.addTextField { (textField) in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(self.listNameFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            if updatedList != nil{
                textField.text = updatedList.subject
            }
        }
        
        self.present(alert, animated: true, completion:nil)
    }

    
    // MARK: - Action Methode
    
    func listAlertAction(_ updatedList: TodoList!, listName: String?) {
        if updatedList != nil{
            // update mode
            try! uiRealm.write{
                updatedList.subject = listName!
                self.fetchData()
            }
        }
        else{
            let newTaskList = TodoList()
            newTaskList.subject = listName!
            
            try! uiRealm.write{
                
                uiRealm.add(newTaskList)
                self.fetchData()
            }
        }
    }
    
    @objc func listNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.count)! > 0
    }

    @IBAction func addBarButtonItemTapped(_ sender: UIBarButtonItem) {
        showListAlert(nil)
    }
    
    @IBAction func editBarButtonItemTapped(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func refreshBarButtonItemTapped(_ sender: UIBarButtonItem) {
        Helpers.showSortActionSheetAlert(self, atoZHandler: { (actino) in
            self.lists = self.lists.sorted(byKeyPath: "subject")
            self.tableView.reloadData()
        }) { (actino) in
            self.lists = self.lists.sorted(byKeyPath: "createdAt", ascending:false)
            self.tableView.reloadData()
        }
    }
}

// MARK: - UItableView Methode

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = lists {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableViewCell", for: indexPath)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.subject
        cell.detailTextLabel?.text = "\(list.todos.count) Todo"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            // TODO:  Deletion
            let listToBeDeleted = self.lists[indexPath.row]
            try! uiRealm.write{
                
                uiRealm.delete(listToBeDeleted)
                self.fetchData()
            }
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // TODO:  Editing
            let listToBeUpdated = self.lists[indexPath.row]
            self.showListAlert(listToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
