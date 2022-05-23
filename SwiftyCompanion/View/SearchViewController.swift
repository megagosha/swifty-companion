//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import UIKit
import AuthenticationServices
class SearchViewController: UIViewController  {

    let searchModel = SearchViewModel()
    
    private let searchView: UIView = {
        let view = UIView()
//        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchField: UISearchTextField = {
        let myTextField: UISearchTextField = UISearchTextField();
        myTextField.frame.size = CGSize(width: UIScreen.main.bounds.width - 50, height: 50.0)
        myTextField.placeholder = "edebi"
        myTextField.text = ""
        myTextField.borderStyle = .roundedRect
        myTextField.font = UIFont.systemFont(ofSize: 20)
//        myTextField.textColor = .none
        myTextField.backgroundColor = .none
        myTextField.setBottomBorderOnlyWith(color: UIColor.clear.cgColor)
        return myTextField
    }()
    
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 300, height: 50)
//        button.backgroundColor = .none
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
//        button.titleLabel?.textColor = .none
        button.tintColor = .none
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchActionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = UIColor.systemBackground
//        view.backgroundColor = .none
        view.addSubview(searchView)
        searchView.addSubview(searchButton)
        searchView.addSubview(searchField)
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: searchView.centerXAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: -60).isActive = true
    }
    
    @objc func searchActionButton() {
        guard searchField.text != nil else {
            return
        }
        self.searchModel.getUser(userInput: self.searchField.text!) { user in
            if (user == nil)
            {
                DispatchQueue.main.async {
                    self.searchField.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                }
                print("error user not found")
            }
            else
            {
                let userViewModel = UserViewModel(user: user!)
                userViewModel.loadImg(finished: {
                    let vc = UserViewController(user: userViewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
}


extension UITextField {
    func setBottomBorderOnlyWith(color: CGColor) {
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func isError(baseColor: CGColor, numberOfShakes shakes: Float, revert: Bool) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "shadowColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.4
        if revert { animation.autoreverses = true } else { animation.autoreverses = false }
        self.layer.add(animation, forKey: "")
        let shake: CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.07
        shake.repeatCount = shakes
        if revert { shake.autoreverses = true  } else { shake.autoreverses = false }
        shake.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(shake, forKey: "position")
    }
}
