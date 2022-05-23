//
//  MainView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import Foundation
import UIKit


class UserViewController: UIViewController {
    var userModel: UserViewModel
    
    var projects: UserProjectsTable?
    
    private let userStatsView: UIView = {
        return UIView()
    }()
    
    private let userProjectsView: UITableView = {
        return UITableView()
    }()

    private func setupAutoLayout() {
        var constaints : [NSLayoutConstraint] = []
        constaints.append(projects!.topAnchor.constraint(equalTo: self.view.topAnchor))
        constaints.append(projects!.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constaints.append(projects!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ))
        constaints.append(projects!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        NSLayoutConstraint.activate(constaints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.projects =  UserProjectsTable(model: self.userModel)
        self.view.addSubview(self.projects!)
        self.title = "User info"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupAutoLayout()
    }
    
    init(user: UserViewModel) {
        self.userModel = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}
