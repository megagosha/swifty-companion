//
//  TableView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 20.05.2022.
//

import Foundation
import UIKit


class UserProjectsTable:  UITableView, UITableViewDataSource, UITableViewDelegate {
    private var uVM: UserViewModel
    
    
    //    private var data: User
    //    private var selectedCursus: Int = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("")
        switch section {
        case 0:
            return 1
        case 1:
            return uVM.user.cursus_users[uVM.cursus_ix].skills.count
        case 2:
            return self.uVM.data[uVM.cursus_ix]!.count
        default: 0
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0 && indexPath.section == 0) {
            let cell  = self.dequeueReusableCell(withIdentifier: "TopCell", for: indexPath) as! TopCell
            //            cell.pickerTextField.becomeFirstResponder()
            return cell
        }
        if (indexPath.section == 1) {
            let cell = self.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath)
            cell.textLabel?.text = self.uVM.user.cursus_users[uVM.cursus_ix].skills[indexPath.row].name +  " " + String(self.uVM.user.cursus_users[uVM.cursus_ix].skills[indexPath.row].level)
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            cell.textLabel?.textColor = .black
            return cell
        }
        if (indexPath.section == 2) {
            let cell = self.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
            var status: Bool = false
            if (self.uVM.data[uVM.cursus_ix]![indexPath.row].validated != nil &&
                self.uVM.data[uVM.cursus_ix]![indexPath.row].validated!)
            {
                status = true
            }
            cell.configure(name: self.uVM.data[uVM.cursus_ix]![indexPath.row].project.name,
                           result: self.uVM.data[uVM.cursus_ix]![indexPath.row].final_mark,
                           complete: status)
            return cell
        }
        return UITableViewCell()
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        if (identifier == "TopCell") {
            let cell = TopCell(model: self.uVM, cursus_ix: self.uVM.cursus_ix, table: self)
            return cell
        }
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            return (400)
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    
    init(model: UserViewModel) {
        self.uVM = model
        print("table init")
        print(self.uVM.data[self.uVM.cursus_ix]!.count)
        super.init(frame: CGRect(), style: .plain)
        
        let ix = getActiveCourseIx()
        if (ix == 0)
        {
            print("error")
            //@todo resolve error
            return
        }
        self.uVM.cursus_ix = ix!
        self.register(TableCell.self, forCellReuseIdentifier: "TableCell")
        self.register(TopCell.self, forCellReuseIdentifier: "TopCell")
        self.register(SkillCell.self, forCellReuseIdentifier: "SkillCell")
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = UIColor.white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.bounces = true
        print("table ready")
        
        
        //        self.addSubview(picker)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //    func viewDidLoad() {
    //        print(self.pickerData)
    //        print("LOOOO")
    //
    //        self.backgroundColor = UIColor.white
    //        //        self.register(TableCell.self, forCellReuseIdentifier: "TableCell")
    //        //        self.register(TopCell.self, forCellReuseIdentifier: "TopCell")
    //
    //        self.dataSource = self
    //        self.estimatedRowHeight = 60.0;
    //        self.picker.delegate = self
    //        self.picker.dataSource = self
    //        self.rowHeight = UITableView.automaticDimension;
    //        self.reloadData()
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: tableView.bounds.size.width, height: 30))
        label.textColor = .systemGray
        if (section == 1) {
            label.text = "Skills:"
            headerView.backgroundColor = UIColor.white
        } else if (section == 2) {
            label.text = "Projects:"
            headerView.backgroundColor = UIColor.white
        }
        headerView.addSubview(label)
        
        return headerView
    }
    
    
    func getActiveCourseIx()-> Int? {
        var date: Date = Date(timeIntervalSince1970: 0)
        var ix = 0
        var j = 0
        for i in self.uVM.user.cursus_users {
            let cur_date = parseTime(time: i.begin_at)
            if (cur_date != nil && cur_date! > date) {
                ix = j
                date = cur_date!
            }
            j += 1
        }
        if date == Date(timeIntervalSince1970: 0) {
            return nil
        }
        return ix
    }
    
    
}

class TableCell: UITableViewCell {
    private var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.textColor = .black
        return label
    }()
    
    private var projectStatus: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 20
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10.0)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(projectStatus)
        self.addSubview(name)
    }
    
    public func configure(name: String, result: Int?, complete: Bool = false) {
        if (result == nil) {
            self.projectStatus.text = "In progress"
            self.projectStatus.backgroundColor = UIColor(cgColor: CGColor(red: 230/255.0, green: 178/255.0, blue: 145/255.0, alpha: 1.0))
        }
        else if (complete) {
            self.projectStatus.text = String(result ?? 0)
            self.projectStatus.backgroundColor = UIColor(cgColor: CGColor(red: 93/255.0, green: 184/255.0, blue: 91/255.0, alpha: 1.0))
        }
        else {
            self.projectStatus.text = String(result ?? 0)
            self.projectStatus.backgroundColor = UIColor(cgColor: CGColor(red: 215/255.0, green: 99/255.0, blue: 111/255.0, alpha: 1.0))
        }
        self.name.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.name.text = nil
        self.projectStatus.text = nil
        self.projectStatus.backgroundColor = .clear
    }
    override func layoutSubviews() {
        var constaints : [NSLayoutConstraint] = []
        constaints.append(self.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor))
        constaints.append(projectStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10))
        constaints.append(projectStatus.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constaints.append(projectStatus.widthAnchor.constraint(equalToConstant: 100))
        constaints.append(projectStatus.heightAnchor.constraint(equalToConstant: 30))
        
        
        constaints.append(name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20))
        constaints.append(name.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constaints.append(name.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -140))
        //                constaints.append(name.heightAnchor.constraint(equalToConstant: 30))
        NSLayoutConstraint.activate(constaints)
    }
    
    
}

class SkillCell: UITableViewCell {
    
}

class TopCell: UITableViewCell,  UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, ToolbarPickerViewDelegate {
    private var user: User
    private var model: UserViewModel
    private var userProfilePicture: UIImageView
    private var parentTable: UserProjectsTable
    private var pickerData: [String]
    
    private var picker: ToolbarPickerView = {
        let picker = ToolbarPickerView()
        //        picker.showsSelectionIndicator = true
        //        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    public var pickerTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = true
        textField.textAlignment = .center
        textField.tintColor = .clear
        
        //        textField.textColor = .black
        textField.backgroundColor = .clear
        return textField
    }()
    
    private var lvlSet: Bool = false
    private var level: UIProgressView = {
        let level = UIProgressView(progressViewStyle: .bar)
        level.translatesAutoresizingMaskIntoConstraints = false
        level.progressTintColor =  UIColor(cgColor: CGColor(red: 93/255.0, green: 184/255.0, blue: 91/255.0, alpha: 1.0))
        return level
    }()
    private var levelLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 23.0)
        return label
    }()
    
    private var fullName: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 20.0)
        return name
    }()
    
    private var nickname: UILabel = {
        let name = UILabel()
        name.textColor = .black
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private var wallet: UILabel = {
        let wallet = UILabel()
        wallet.textColor = .black
        wallet.translatesAutoresizingMaskIntoConstraints = false
        return wallet
    }()
    
    private let userInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    
    
    
    
    init(model: UserViewModel, cursus_ix: Int, table: UserProjectsTable) {
        self.user = model.user
        self.model = model
        self.parentTable = table
        self.pickerData = model.user.cursus_users.map { $0.cursus.name }
        self.userProfilePicture = model.img!
        super.init(style: .default, reuseIdentifier: "TopCell")
        
        
        
        
        //        self.clearsContextBeforeDrawing = true
        self.clipsToBounds = true
        //        self.autoresizesSubviews = true
        //        self.isOpaque = true
        
        let lvl = user.cursus_users[cursus_ix].level
        let percent = 1.0 - ( lvl.rounded(.up) - lvl)
        self.level.setProgress(percent, animated: true)
        self.lvlSet = true
        self.levelLabel.text = "level " + String(lvl)
        fullName.text = user.displayname
        nickname.text = user.login
        wallet.text = "Wallet: " + String(user.wallet ?? 0)
        userInfoView.addSubview(level)
        userInfoView.addSubview(levelLabel)
        userInfoView.addSubview(fullName)
        userInfoView.addSubview(nickname)
        userInfoView.addSubview(wallet)
        //        model.user.cursus_users.map { $0.cursus.name }
        self.addSubview(userInfoView)
        //        let img = self.userProfilePicture
        //        let url = URL(string: user.image_url ?? "https://profile.intra.42.fr/images/default.png")
        //        img.load(url: url!)
        self.addSubview(userProfilePicture)
        //        self.setLayout()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.center = self.center
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        self.picker.toolbarDelegate = self
        
        self.backgroundColor = .white
        self.pickerTextField.inputView = picker
        self.pickerTextField.autocorrectionType = .no
        self.pickerTextField.delegate = self
        self.pickerTextField.inputAccessoryView = picker.toolbar
        self.pickerTextField.text = self.model.user.cursus_users[self.model.cursus_ix].cursus.name
        pickerTextField.allowsEditingTextAttributes = false
        self.contentView.addSubview(pickerTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        print("can perform action")
//        print(action)
//        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
//            return false
//        }
//        print("super called")
//        return super.canPerformAction(action, withSender: sender)
        return false
    }
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        print("should change")
       return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.user.cursus_users.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        self.model.cursus_ix = row
        //        self.pickerTextField.text = self.model.user.cursus_users[self.model.cursus_ix].cursus.name
        //        self.parentTable.reloadData()
        //        pickerView.isHidden = true
        //        self.reloadData()
    }
    
    func didTapDone() {
        self.model.cursus_ix = self.picker.selectedRow(inComponent: 0)
        self.pickerTextField.text = self.model.user.cursus_users[self.model.cursus_ix].cursus.name
        self.pickerTextField.resignFirstResponder()
        self.parentTable.reloadSections(IndexSet(integersIn: 1...2), with: .automatic)
//        self.parentTable.reloadData()
        print("Tapped")
    }
    
    func didTapCancel() {
        self.pickerTextField.resignFirstResponder()
    }
    
    //    private func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return false
    //    }
    
    override func layoutSubviews() {
        self.userInfoView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.userProfilePicture.frame = CGRect(x: self.frame.width / 2, y: 50, width: 150, height: 150)
        var constaints : [NSLayoutConstraint] = []
        constaints.append(userProfilePicture.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(userProfilePicture.widthAnchor.constraint(equalToConstant: 150))
        constaints.append(userProfilePicture.heightAnchor.constraint(equalToConstant: 150))
        
        constaints.append(fullName.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(fullName.topAnchor.constraint(equalTo: userProfilePicture.bottomAnchor, constant: 30))
        
        constaints.append(nickname.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(nickname.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 10))
        constaints.append(wallet.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(wallet.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 10))
        
        constaints.append(level.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(level.topAnchor.constraint(equalTo: wallet.bottomAnchor, constant: 20))
        constaints.append(level.heightAnchor.constraint(equalToConstant: 50))
        constaints.append(level.widthAnchor.constraint(equalToConstant: 300))
        
        constaints.append(levelLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(levelLabel.topAnchor.constraint(equalTo: wallet.bottomAnchor, constant: 20))
        constaints.append(levelLabel.heightAnchor.constraint(equalToConstant: 50))
        constaints.append(levelLabel.widthAnchor.constraint(equalToConstant: 300))
        
        constaints.append(pickerTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constaints.append(pickerTextField.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 20))
        constaints.append(pickerTextField.heightAnchor.constraint(equalToConstant: 60))
        constaints.append(pickerTextField.widthAnchor.constraint(equalToConstant: 100))
        
        
        NSLayoutConstraint.activate(constaints)
    }
    
    
}


func parseTime(time: String?)-> Date? {
    if (time == nil) {
        return nil
    }
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    return RFC3339DateFormatter.date(from: time!)
}

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
}
protocol ToolbarPickerViewDelegate {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {
    
    public private(set) var toolbar: UIToolbar?
    public var toolbarDelegate: ToolbarPickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let toolBar = UIToolbar( frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        doneButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        spaceButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.toolbar = toolBar
    }
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
