//
//  BaseViewController.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit

@MainActor
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupAttribute()
        bind()
    }
    
    func setupLayout() {}
    func setupAttribute() {}
    func bind() {}
}
