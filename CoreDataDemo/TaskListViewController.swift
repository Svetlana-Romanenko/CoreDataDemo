//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by Alexey Efimov on 10.03.2021.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cell"
    private var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation Bar Appearence
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
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.modalPresentationStyle = .fullScreen
        present(newTaskVC, animated: true)
    }
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

// MARK: - TAble View Data Source
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

