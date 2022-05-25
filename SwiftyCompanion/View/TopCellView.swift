//
//  TopCellView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation
import UIKit

class TopCell: UITableViewCell {
    
    private var user: User
    
    private var model: UserViewModel
    
    private var userProfilePicture: UIImageView
    
    private var parentTable: UserProjectsTable
    
    private var pickerData: [String]
    
    private var picker: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    public var pickerTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
//        textField.tintColor = .clear
//        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.allowsEditingTextAttributes = false
        return textField
    }()
    
    private var level: UIProgressView = {
        let level = UIProgressView(progressViewStyle: .bar)
        level.translatesAutoresizingMaskIntoConstraints = false
        level.progressTintColor =  UIColor(cgColor: CGColor(red: 93/255.0, green: 184/255.0, blue: 91/255.0, alpha: 1.0))
        level.layer.cornerRadius = 10
        return level
    }()
    
    private var levelLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    private var fullName: UILabel = {
        let name = UILabel()
//        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 20.0)
        return name
    }()
    
    private var nickname: UILabel = {
        let name = UILabel()
//        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private var wallet: UILabel = {
        let wallet = UILabel()
//        wallet.textColor = .black
        wallet.translatesAutoresizingMaskIntoConstraints = false
        return wallet
    }()
    
    private let userInfoView: UIView = {
        let view = UIView()
//        view.backgroundColor = .white
        return view
    }()
    
    init(model: UserViewModel, cursus_ix: Int, table: UserProjectsTable) {
        user = model.user
        self.model = model
        userProfilePicture = model.img!
        parentTable = table
        pickerData = model.user.cursus_users.map { $0.cursus.name }
        super.init(style: .default, reuseIdentifier: "TopCell")
        clipsToBounds = true
//        backgroundColor = .white
        setSubViews()
        setConstraints()
    }
    
    private func setSubViews() {
        setLevelInfo()
        setPicker()
        fullName.text = user.displayname
        nickname.text = user.login
        wallet.text = "Wallet: " + String(user.wallet ?? 0)
        userProfilePicture.contentMode = .scaleAspectFill
        userInfoView.addSubview(level)
        userInfoView.addSubview(levelLabel)
        userInfoView.addSubview(fullName)
        userInfoView.addSubview(nickname)
        userInfoView.addSubview(wallet)
        
        addSubview(userInfoView)
        addSubview(userProfilePicture)
        contentView.addSubview(pickerTextField)
    }
    
    private func setLevelInfo() {
        let lvl = user.cursus_users[model.cursus_ix].level
        let percent = 1.0 - ( lvl.rounded(.up) - lvl)
        level.setProgress(percent, animated: true)
        levelLabel.text = "level " + String(lvl)
    }
    
    private func setPicker() {
        pickerData.removeAll(where: {$0 == model.user.cursus_users[model.cursus_ix].cursus.name})
        pickerData.insert(model.user.cursus_users[model.cursus_ix].cursus.name, at: 0)
        picker.delegate = self
        picker.dataSource = self
        picker.center = self.center
        picker.toolbarDelegate = self
        pickerTextField.delegate = self
        pickerTextField.inputAccessoryView = picker.toolbar
        pickerTextField.text = self.model.user.cursus_users[self.model.cursus_ix].cursus.name
        pickerTextField.inputView = picker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setConstraints() {
        self.userInfoView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.userProfilePicture.frame = CGRect(x: self.frame.width / 2, y: 50, width: 150, height: 150)
        var constraints : [NSLayoutConstraint] = []
        constraints.append(userProfilePicture.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(userProfilePicture.widthAnchor.constraint(equalToConstant: 150))
        constraints.append(userProfilePicture.heightAnchor.constraint(equalToConstant: 150))
        
        constraints.append(fullName.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(fullName.topAnchor.constraint(equalTo: userProfilePicture.bottomAnchor, constant: 30))
        
        constraints.append(nickname.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(nickname.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 10))
        constraints.append(wallet.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(wallet.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 10))
        
        constraints.append(level.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(level.topAnchor.constraint(equalTo: wallet.bottomAnchor, constant: 20))
        constraints.append(level.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(level.widthAnchor.constraint(equalToConstant: 300))
        
        constraints.append(levelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(levelLabel.topAnchor.constraint(equalTo: wallet.bottomAnchor, constant: 20))
        constraints.append(levelLabel.heightAnchor.constraint(equalToConstant: 50))
        constraints.append(levelLabel.widthAnchor.constraint(equalToConstant: 300))
        
        constraints.append(pickerTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraints.append(pickerTextField.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20))
        constraints.append(pickerTextField.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(pickerTextField.widthAnchor.constraint(equalToConstant: 100))
        
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension TopCell: UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.user.cursus_users.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    func didTapDone() {
        self.model.cursus_ix = self.model.key_cursus[self.pickerData[self.picker.selectedRow(inComponent: 0)]]!
        self.pickerTextField.text = self.model.user.cursus_users[self.model.cursus_ix].cursus.name
        self.pickerTextField.resignFirstResponder()
//        self.parentTable.beginUpdates()
//        self.parentTable.reloadData()
//        self.parentTable.endUpdates()
        self.parentTable.reloadSections(IndexSet(integersIn: 1...2), with: .automatic)
        self.setLevelInfo()
//        self.parentTable.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.level.setNeedsDisplay()
    }
    
    func didTapCancel() {
        self.pickerTextField.resignFirstResponder()
    }
}

extension TopCell: UITextFieldDelegate {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
