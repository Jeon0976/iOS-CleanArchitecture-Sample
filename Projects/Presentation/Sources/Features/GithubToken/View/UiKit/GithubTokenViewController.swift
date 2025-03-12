//
//  GithubTokenViewController.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import UIKit
import Combine

public final class GithubTokenViewController: BaseViewController {
    // MARK: - Property
    var viewModel: GithubTokenViewModel!
    
    private let loginButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Component
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "환영합니다!"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(
            "GitHub AccessToken 불러오기",
            for: .normal
        )
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(viewModel: GithubTokenViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        [
            welcomeLabel,
            loginButton
        ].forEach {
            view.addSubview($0)
        }
                
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: -32
            ),
            welcomeLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            loginButton.topAnchor.constraint(
                equalTo: welcomeLabel.bottomAnchor,
                constant: 32
            ),
            loginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 32
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -32
            ),
            loginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -32
            ),
            
            loginButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    override func setupAttribute() {
        view.backgroundColor = .white
        
        loginButton.addTarget(
            self,
            action: #selector(loginButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    override func bind() {
        let input = GithubTokenViewModel.Input(
            loginButtonTapped: loginButtonTapped.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.url
            .sink { url in
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            .store(in: &cancellables)
        
        output.error
            .sink { [weak self] error in
                guard let self = self else { return }
                
                self.showAlert(
                    title: "에러",
                    message: error.localizedDescription
                )
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        loginButtonTapped.send()
    }
}
