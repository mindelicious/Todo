//
//  TodoManager.swift
//  TODO
//
//  Created by Matt on 28/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit

class TodoManager {
    
    static let shared = TodoManager()
    private var savedTodos: [TodoItem] = []
    private let TodoKey = "todos"
    
    private init() {}
    
    func saveTodo(todo: TodoItem) {
        savedTodos.append(todo)
        saveState()
    }
    
    private func saveState() {
        let todoData = try! JSONEncoder().encode(savedTodos)
        UserDefaults.standard.set(todoData, forKey: TodoKey)
    }
    
    func getTodo() -> [TodoItem] {
        guard let savedData = UserDefaults.standard.data(forKey: TodoKey) else { return savedTodos }
        let savedArray = try! JSONDecoder().decode([TodoItem].self, from: savedData)
        savedTodos = savedArray
        return savedTodos
    }
    
    func removeTodo(atIndex: Int) {
        savedTodos.remove(at: atIndex)
        saveState()
    }
}
