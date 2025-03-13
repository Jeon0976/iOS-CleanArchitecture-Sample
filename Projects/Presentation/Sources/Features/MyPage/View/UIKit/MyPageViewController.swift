//
//  MyPageViewController.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit
import Combine

import Domain

final class MyPageViewController: BaseViewController {
    // MARK: - Property
    var viewModel: MyPageViewModel!
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        
    }
    
    override func setupAttribute() {
        
    }
    
    override func bind() {
        
    }
}
