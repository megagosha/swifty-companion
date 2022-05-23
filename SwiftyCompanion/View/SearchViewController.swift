//
//  ViewController.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 18.05.2022.
//

import UIKit
import AuthenticationServices
class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "yoo"
    }
    
    let searchModel = SearchViewModel()
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //        view.layer.borderWidth = 1
        //        view.layer.borderColor = UIColor.black.cgColor
        //        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    private let searchField: UISearchTextField = {
        let myTextField: UISearchTextField = UISearchTextField();
        myTextField.frame.size = CGSize(width: UIScreen.main.bounds.width - 50, height: 50.0)
        myTextField.placeholder = "42 username"
        myTextField.text = ""
        myTextField.borderStyle = .roundedRect
        myTextField.font = UIFont.systemFont(ofSize: 20)
        myTextField.setBottomBorderOnlyWith(color: UIColor.gray.cgColor)
        return myTextField
    }()
    
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame.size = CGSize(width: 300, height: 50)
        button.backgroundColor = .white
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        button.tintColor = .black
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchActionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.addSubview(searchButton)
        searchView.addSubview(searchField)
        //        view.addSubview(titleLabel)
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(searchView)
        
//        let picker = UIPickerView()
//        let textField = UITextField(frame: CGRect(x: 100, y: 450, width: <#T##Int#>))
//        textField.inputView = picker
//        textField.widthAnchor.constraint(equalToConstant: 100)
//        textField.backgroundColor = .red
//        picker.dataSource = self
//        picker.delegate = self
//        view.addSubview(picker)
//        view.addSubview(textField)
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupAutoLayout()
    }
    
    
    
    
    @objc func searchActionButton() {
        //        self.searchModel.getUser(user: "edebi", completion: { user in
        //            print(user?.cursus_users)
        //        })
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
//                userViewModel.prepareData()
                print(userViewModel.data[userViewModel.cursus_ix]!.count)
                userViewModel.loadImg(finished: {
                    let vc = UserViewController(user: userViewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                print("show user info")
            }
        }
    }
    
    func setupAutoLayout() {
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: view.frame.height / 3).isActive = true
        searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //        searchField.centerXAnchor.constraint(equalTo: searchView.centerXAnchor).isActive = true
        //        searchField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: -100).isActive = true
        searchButton.centerXAnchor.constraint(equalTo: searchView.centerXAnchor).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor, constant: -60).isActive = true
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
