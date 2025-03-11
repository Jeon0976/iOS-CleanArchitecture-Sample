//
//  SplashViewController.swift
//  presentation
//
//  Created by jinhyerim on 3/5/25.
//  Copyright © 2025 com.maju. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

public final class SplashViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Splash Button", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.addViews()
        self.setupConstraints()
        self.bind()
    }
    
    private func addViews() {
        self.view.addSubview(self.button)
    }
    
    private func setupConstraints() {
        self.button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    private func bind() {
        self.button.rx.tap
            .subscribe(onNext: {
                print("button Tapped!")
            })
            .disposed(by: self.disposeBag)
    }
    
}
