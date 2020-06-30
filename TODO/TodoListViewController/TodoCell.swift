//
//  TodoCell.swift
//  TODO
//
//  Created by Matt on 25/06/2020.
//  Copyright © 2020 mindelicious. All rights reserved.
//

import UIKit
import SnapKit
import BEMCheckBox

class TodoCell: UITableViewCell, BEMCheckBoxDelegate {
    
    // MARK: - Properties
    private lazy var cellView = makeCellView()
    private lazy var todoLabel = makeTodoLabel()
    private lazy var deleteBtn = makeDeleteBtn()
    private lazy var categoryIcon = UIButton()
    private lazy var todoDateLabel = makeTodoDate()
    lazy var checkBox = makeCheckBox()
    
    var onBinTapped: (() -> Void)?
    var onCheckBoxtapped: (() -> Void)?
    
    // MARK: - Main
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        todoLabel.text?.removeAll()
        todoDateLabel.text?.removeAll()
        categoryIcon.setImage(nil, for: .normal)
        checkBox.setOn(false, animated: false)
    }
    
    // MARK: - Helper functions
    func setData(task: TodoItem) {
        todoLabel.text = task.todoLabel
        categoryIcon.setImage(UIImage(named: task.category!.rawValue), for: .normal)
        todoDateLabel.text = task.todoDate!.asString()
        checkBox.setOn(false, animated: false)
    }
    
    @objc func binTapped(_ sender: UIButton) {
       onBinTapped?()
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        onCheckBoxtapped?()
    }
    
    func prepareCheckBox() {
        checkBox.tintColor = .white
        checkBox.onTintColor = .green
        checkBox.onCheckColor = .green
        checkBox.onAnimationType = .oneStroke
        checkBox.animationDuration = 1
    }
    
}

// MARK: - Setup & Constraints
extension TodoCell {
    
    func setupUI() {
        prepareCheckBox()
        categoryIcon.isUserInteractionEnabled = false
        addSubview(cellView)
        
        checkBox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        todoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(checkBox.snp.right).offset(10)
            make.right.equalTo(deleteBtn.snp.left).offset(-4)
            make.top.equalToSuperview().offset(9)
            make.bottom.equalTo(categoryIcon.snp.top).offset(-8)
        }
        
        deleteBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        categoryIcon.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalTo(todoLabel.snp.left)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        todoDateLabel.snp.makeConstraints { make in
            make.left.equalTo(categoryIcon.snp.right).offset(15)
            make.centerY.equalTo(categoryIcon)
            make.right.equalTo(deleteBtn.snp.left).offset(-8)
        }
        
        cellView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    func makeCheckBox() -> BEMCheckBox {
        let checkBoxBtn = BEMCheckBox(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        checkBoxBtn.delegate = self
        return checkBoxBtn
    }
    
    func makeTodoLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(19)
        label.textColor = .white
        return label
    }
    
    func makeDeleteBtn() -> UIButton {
        let deleteBtn = UIButton(type: .custom)
        let image = UIImage(named: Constants.bin)
        deleteBtn.setImage(image, for: .normal)
        deleteBtn.tintColor = .white
        deleteBtn.addTarget(self, action: #selector(binTapped), for: .touchUpInside)
        return deleteBtn
    }
    
    func makeTodoDate() -> UILabel {
        let dateLabel = UILabel()
        dateLabel.textAlignment = .right
        dateLabel.textColor = .white
        dateLabel.font = .systemFont(ofSize: 14)
        return dateLabel
    }
    
    func makeCellView() -> UIView {
        let cellView = UIView()
        cellView.backgroundColor = UIColor(named: Constants.cellColor)
        cellView.layer.cornerRadius = 10
        [checkBox, todoLabel, deleteBtn, categoryIcon, todoDateLabel].forEach { cellView.addSubview($0) }
        return cellView
    }
    
}

