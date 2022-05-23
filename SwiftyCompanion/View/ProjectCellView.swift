//
//  ProjectCellView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation
import UIKit

class ProjectCell: UITableViewCell {
    
    private var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
//        label.textColor = .black
        return label
    }()
    
    private var projectStatus: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 15
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        return label
    }()
    
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
        constaints.append(projectStatus.widthAnchor.constraint(equalToConstant: 80))
        constaints.append(projectStatus.heightAnchor.constraint(equalToConstant: 30))
        
        constaints.append(name.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20))
        constaints.append(name.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constaints.append(name.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -140))
        //                constaints.append(name.heightAnchor.constraint(equalToConstant: 30))
        NSLayoutConstraint.activate(constaints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(projectStatus)
        self.addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
