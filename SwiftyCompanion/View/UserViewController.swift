//
//  MainView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import Foundation
import UIKit


class UserViewController: UIViewController, UIScrollViewDelegate {
    var userModel: UserViewModel
    var projects: UserProjectsTable?
    
    
    
//    private var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.bounces = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.showsHorizontalScrollIndicator = false
//        view.showsVerticalScrollIndicator = true
//        return view
//    }()
    
    
    private let userStatsView: UIView = {
        return UIView()
    }()
    
    private let userProjectsView: UITableView = {
        
        return UITableView()
    }()
    
    
    init(user: UserViewModel) {
        self.userModel = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.projects =  UserProjectsTable(model: self.userModel)

        self.view.addSubview(self.projects!)

        self.title = "User info"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
//        view.backgroundColor = .white
        
        setupAutoLayout()
    }
    
//    override func viewDidLayoutSubviews() {
//        self.viewDidLayoutSubviews()
//        if (self.projects != nil) {
//        self.projects!.frame = view.bounds
//        }
//        else
//        {
//            print("not ready")
//        }
//    }
    private func setupAutoLayout() {
        var constaints : [NSLayoutConstraint] = []
 
//        constaints.append(userInfoView.topAnchor.constraint(equalTo: self.view.topAnchor))
//        constaints.append(userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
//        constaints.append(userInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
//        constaints.append(userInfoView.heightAnchor.constraint(equalToConstant: 400))
//
//        constaints.append(userProfilePicture.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
//        constaints.append(userProfilePicture.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
//        constaints.append(userProfilePicture.widthAnchor.constraint(equalToConstant: 150))
//        constaints.append(userProfilePicture.heightAnchor.constraint(equalToConstant: 150))
        
//        constaints.append(userInfoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
//        constaints.append(userInfoView.heightAnchor.constraint(equalToConstant: 400))
//        
        constaints.append(projects!.topAnchor.constraint(equalTo: self.view.topAnchor))
        constaints.append(projects!.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constaints.append(projects!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ))
        constaints.append(projects!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
//        constaints.append(projects!.heightAnchor.constraint(equalToConstant: projects!.contentSize.height))
//        constaints.append(scrollView.heightAnchor.constraint(equalToConstant: projects!.contentSize.height * 2))
//        constaints.append(scrollView.widthAnchor.constraint(equalToConstant: projects!.contentSize.width * 2))

        //        constaints.append(projects!.heightAnchor.constraint(equalToConstant: projects!.contentSize.height))
        NSLayoutConstraint.activate(constaints)
        //        projects!.topAnchor.constraint(equalTo: userInfoView.bottomAnchor).isActive = true
        //        projects!.centerXAnchor.constraint(equalTo: userInfoView.centerXAnchor, constant: 0).isActive = true
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
                print("failed to create UIIMage")
            }
            else
            {
                print("img download failed")
            }
        }
    }
}
