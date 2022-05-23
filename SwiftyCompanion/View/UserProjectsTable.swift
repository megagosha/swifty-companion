//
//  TableView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 20.05.2022.
//

import Foundation
import UIKit


class UserProjectsTable:  UITableView {
    
    private var uVM: UserViewModel
    
    init(model: UserViewModel) {
        self.uVM = model
        super.init(frame: CGRect(), style: .plain)
        self.register(ProjectCell.self, forCellReuseIdentifier: "ProjectCell")
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserProjectsTable: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        if (identifier == "TopCell") {
            let cell = TopCell(model: self.uVM, cursus_ix: self.uVM.cursus_ix, table: self)
            return cell
        }
        return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return uVM.user.cursus_users[uVM.cursus_ix].skills.count
        case 2:
            return self.uVM.data[uVM.cursus_ix]!.count
        default:
            return 0
        }
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
            let cell = self.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectCell
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            return (400)
        }
        return UITableView.automaticDimension
    }
    
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
}

class SkillCell: UITableViewCell {
    
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

