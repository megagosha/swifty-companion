//
//  ToolbarPickerView.swift
//  SwiftyCompanion
//
//  Created by George Tevosov on 23.05.2022.
//

import Foundation
import UIKit

protocol ToolbarPickerViewDelegate {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {
        
    public var toolbarDelegate: ToolbarPickerViewDelegate?
    
    public var toolbar: UIToolbar = {
        let toolBar = UIToolbar( frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
//        toolBar.tintColor = .black
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        return toolBar
    }()
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        doneButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        spaceButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
    }
    
    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }
    
    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
}
