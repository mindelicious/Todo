//
//  TodoDetailViewController.swift
//  TODO
//
//  Created by Matt on 25/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import SnapKit
import BEMCheckBox

class TodoDetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private lazy var todoTextField = makeTextField()
    private lazy var datePickerTextField = makeTextField()
    private lazy var workCategoryBtn = makeCategoryBtn()
    private lazy var shoppingCategoryBtn = makeCategoryBtn()
    private lazy var otherCategoryBtn = makeCategoryBtn()
    private lazy var categoryStackView = makeStackView([workCategoryBtn, shoppingCategoryBtn, otherCategoryBtn])
    
    var todoItem = TodoItem(todoLabel: nil, todoDate: nil, category: nil)
    var onAddTodo: ((TodoItem) -> Void)?
    
    let datePicker = UIDatePicker()
    
    // MARK: - Main
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Handle TextField
    func setupTodoTextField() {
        todoTextField.delegate = self
        todoTextField.addTarget(self, action: #selector(todoTextFieldChange(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func todoTextFieldChange(_ textField: UITextField) {
        todoItem.todoLabel = todoTextField.text
    }
 
    // MARK: - Handle DatePicker
    func setupDatePicker() {
        datePickerTextField.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
        datePickerTextField.inputAccessoryView = toolbar
        datePickerTextField.inputView = datePicker
        datePickerTextField.placeholder = "when".localized()
    }
    
    @objc func doneTapped() {
        datePickerTextField.text = datePicker.date.asString()
        todoItem.todoDate = datePicker.date
        dismissKeyboard()
    }

    
    // MARK: - Handle Category
    func prepareCategory() {
        prepareCategoryBtn(button: workCategoryBtn, btnImage: Constants.work, btnName: "work".localized())
        prepareCategoryBtn(button: shoppingCategoryBtn, btnImage: Constants.shopping, btnName: "shopping".localized())
        prepareCategoryBtn(button: otherCategoryBtn, btnImage: Constants.other, btnName: "other".localized())
    }
    
    func prepareCategoryBtn(button: UIButton, btnImage: String, btnName: String) {
        button.setImage(UIImage(named: btnImage), for: .normal)
        button.setTitle(btnName, for: .normal)
    }
    
    @objc func categoryBtnTapped(_ sender: UIButton) {
        switch sender {
        case workCategoryBtn:
            pickedCategory(for: workCategoryBtn, category: .work)
        case shoppingCategoryBtn:
            pickedCategory(for: shoppingCategoryBtn,category: .shopping)
        case otherCategoryBtn:
            pickedCategory(for: otherCategoryBtn, category: .other)
        default:
            return
        }
    }
    
    func pickedCategory(for button: UIButton, category: Category) {
        let categoryBtn = [workCategoryBtn, shoppingCategoryBtn, otherCategoryBtn]
        categoryBtn.forEach { $0.backgroundColor = .gray }
        button.backgroundColor = .systemRed
        todoItem.category = category
    }
    
    func disableCategoryColor(button: UIButton, color: UIColor) {
        button.backgroundColor = color
    }
    
    // MARK: - Helper functions
    @objc func addBtnTapped() {
        dismissKeyboard()
        
        if todoItem.todoDate == nil {
            todoItem.todoDate = Date()
        }
    
        if todoItem.todoLabel == nil || todoItem.todoLabel == "" {
            fillDataAlert()
        }
    
        guard let todo = todoItem.todoLabel, let date = todoItem.todoDate, let category = todoItem.category else { return }
        onAddTodo!(TodoItem(todoLabel: todo, todoDate: date, category: category))
        let alert = UIAlertController(title: "",
                                      message: "task_was_added".localized(),
                                      preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
        
    }
    
    @objc func cancelBtnTapped() {
        dismissKeyboard()
        dismissTaskAlert()
    }
    
    func fillDataAlert() {
        let alert = UIAlertController(title: String(format: "fill_task".localized()),
                                     message: nil,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func dismissTaskAlert() {
        let alert = UIAlertController(title: String(format: "do_you_want_to_quit".localized()),
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "no".localized(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func prepareNavigation() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add".localized(), style: .done, target: self, action: #selector(addBtnTapped))
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.title = "new_task".localized()
    }
    
    func checkDevice() {
        if UIScreen.main.bounds.width < 370.0 {
            categoryStackView.axis = .vertical
            categoryStackView.spacing = 10
        }
    }
    
}

// MARK: - SetupUI & Constraints
extension TodoDetailViewController {
    
    func setupUI() {
        setupTodoTextField()
        setupDatePicker()
        prepareCategory()
        prepareNavigation()
        checkDevice()
        
        todoTextField.becomeFirstResponder()
        todoItem.category = .other
        otherCategoryBtn.backgroundColor = .systemRed
        
        view.backgroundColor = .white
        [todoTextField, datePickerTextField, categoryStackView, ].forEach { view.addSubview($0) }
        
        todoTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-15)
            make.height.equalTo(30)
            make.bottom.equalTo(categoryStackView.snp.top).offset(-80)
        }
        
        datePickerTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-60)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-15)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(datePickerTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.rightMargin).offset(-15)
        }
        
    }
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        
        textField.textAlignment = .center
        textField.placeholder = "need_to_do_something_placeholder".localized()
        textField.font = .systemFont(ofSize: 16)
        textField.setBottomBorder()
        return textField
    }
    
    func makeStackView(_ stackItems: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackItems.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }
    
    func makeCategoryBtn() -> UIButton {
        let categoryBtn = UIButton()
        categoryBtn.setTitleColor(.white, for: .normal)
        categoryBtn.layer.cornerRadius = 6
        categoryBtn.backgroundColor = .gray
        
        let spacing: CGFloat = 6
        categoryBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        categoryBtn.addTarget(self, action: #selector(categoryBtnTapped), for: .touchUpInside)
        return categoryBtn
    }
   
}
