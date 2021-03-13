//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Svetlana Romanenko on 14/03/2021
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    // MARK: - Private properties
    
    private let context = StorageManager.context
    
    private let cellID = "cell"
    private var taskList: [Task] = []
    
    private let cell = UITableViewCell()

    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - Private methods / Setup Navigation bar
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Private methods / Fetch Data
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Private methods / AlertController
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            if self.taskList.contains(where: { $0.name == title }) {
                self.updateName(task)
            } else {
                self.save(task)
                }
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // MARK: - Private methods / Save, Rename Tasks
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func save(_ taskName: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        task.name = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateName (_ taskName: String) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }

        taskList[indexPath.row].name = taskName
        tableView.reloadData()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }

        }
    }
}

// MARK: - Table View Data Source

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Table View Delegate / Delete Tasks, Save changes

extension TaskListViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deletingTask = taskList[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(deletingTask)
            taskList.remove(at: indexPath.row)
            }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let title = taskList[indexPath.row].name else { return }
            
        showAlert(with: title, and: "Do you want to save changes?")
    }
}
