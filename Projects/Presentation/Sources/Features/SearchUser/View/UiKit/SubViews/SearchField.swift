//
//  SearchField.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit

final class SearchField: UITextField {
    private let innerInset: CGFloat = 16
    private let buttonSize: CGFloat = 24
    
    private let rightButton = UIButton()
    
    private let xCircleImage = UIImage(systemName: "x.circle")
    private let searchGlassImage = UIImage(systemName: "magnifyingglass")
        
    private lazy var inset = UIEdgeInsets(
        top: innerInset,
        left: innerInset,
        bottom: innerInset,
        right: innerInset + self.buttonSize + 2
    )
    
    private var _isEditingField: Bool = false
    var isEditingField: Bool {
        get { return _isEditingField }
        set {
            if !(newValue == _isEditingField) {
                let image = newValue ? xCircleImage : searchGlassImage
                rightButton.setImage(image, for: .normal)
                
                _isEditingField = newValue
            }
        }
    }
    
    var rightButtonHidden = false {
        didSet {
            rightView?.isHidden = rightButtonHidden
        }
    }
    
    var textFieldShouldSearch: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAttribute()
        setupRightButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: inset)
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        self.rightButtonHidden = !force
        self.isEditingField = !force
        
        return force
    }
    
    private func setupAttribute() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.returnKeyType = .search
    }
    
    private func setupRightButton() {
        rightButton.setImage(searchGlassImage, for: .normal)
        rightButton.tintColor = .black
        rightButton.frame = .init(
            x: 0,
            y: 0,
            width: buttonSize,
            height: buttonSize
        )
        rightButton.addTarget(
            self,
            action: #selector(rightButtonTapped(_:)),
            for: .touchUpInside
        )
        
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: buttonSize + innerInset,
            height: buttonSize)
        )
        
        paddingView.addSubview(rightButton)
        
        rightView = paddingView
        rightViewMode = .always
    }
    
    @objc private func rightButtonTapped(_ sender: UIButton) {
        if isEditingField {
            self.rightButtonHidden = true
            self.text = ""
        } else {
            if self.text == "" {
                self.becomeFirstResponder()
            } else {
                self.textFieldShouldSearch?()
            }
        }
    }
}
