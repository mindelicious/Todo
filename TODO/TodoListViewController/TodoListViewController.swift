//
//  TodoListViewController.swift
//  TODO
//
//  Created by Matt on 25/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import SnapKit
import BEMCheckBox

class TodoListViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var emptyListLabel = makeEmptyListLabel()
    private lazy var emptyListIcon = makeEmptyListIcon()
    private let tableView = UITableView()
    var todoItem: TodoItem!
    var todoList: [TodoItem] {
        return TodoManager.shared.getTodo()
    }
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareTableView()
        tableView.reloadData()
    }
    
    // MARK: - Helper functions
    @objc func onAddTap() {
        let toDoDetailVC = TodoDetailViewController()
        let navigationController = UINavigationController(rootViewController: toDoDetailVC)
        toDoDetailVC.onAddTodo = { todoItem in
            TodoManager.shared.saveTodo(todo: todoItem)
        }
        
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func showEmptyListLabel(show: Bool) {
        tableView.isHidden = show
        emptyListLabel.isHidden = !show
        emptyListIcon.isHidden = !show
    }
    
    func handleDeletingTask(indexPath: IndexPath) {
        TodoManager.shared.removeTodo(atIndex: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
    }

}

// MARK: - TabelView Delegate & DataSource
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(TodoCell.self, forCellReuseIdentifier: Constants.todoCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showEmptyListLabel(show: todoList.isEmpty)
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.todoCell, for: indexPath) as! TodoCell
        let task = todoList[indexPath.row]
        cell.setData(task: task)
        
        cell.onBinTapped = { [weak self] in
            self?.handleDeletingTask(indexPath: indexPath)
        }
        cell.onCheckBoxtapped = { [weak self] in
            cell.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self?.handleDeletingTask(indexPath: indexPath)
            }
        }
        
        cell.isUserInteractionEnabled = true
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            handleDeletingTask(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}

// MARK: - SetupUI & Constraints
extension TodoListViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(onAddTap))
        [tableView, emptyListLabel, emptyListIcon].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyListLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyListIcon.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        emptyListIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    func makeEmptyListLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.text = "empty_list".localized()
        label.textAlignment = .center
        return label
    }
    
    func makeEmptyListIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.emptyList)
        return imageView
    }
}
