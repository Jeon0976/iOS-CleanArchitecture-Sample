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
    private let imageSize: CGFloat = 88
    
    private let viewDidLoadTrigger = PassthroughSubject<Void, Never>()
    private let loginButtonTappedTrigger = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()

    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = imageSize / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear

        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Followers: "
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Follwing: "
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .medium)
        
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        
        button.setTitle("로그아웃", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        

        return button
    }()
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        let followStackView = UIStackView()
        
        followStackView.axis = .horizontal
        followStackView.distribution = .fillEqually
        followStackView.alignment = .center
        followStackView.spacing = 16
        
        [
            followersLabel,
            followingLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            followStackView.addArrangedSubview($0)
        }
        
        [
            nameLabel,
            posterImageView,
            locationLabel,
            followStackView,
            logoutButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            nameLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            
            posterImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            posterImageView.heightAnchor.constraint(equalToConstant: imageSize),
            posterImageView.widthAnchor.constraint(equalToConstant: imageSize),
            posterImageView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            locationLabel.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            
            followStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            followStackView.centerXAnchor.constraint(equalTo: locationLabel.centerXAnchor),
            
            logoutButton.topAnchor.constraint(equalTo: followStackView.bottomAnchor, constant: 16),
            logoutButton.centerXAnchor.constraint(equalTo: followStackView.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 120),
            logoutButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .white

        logoutButton.addTarget(
            self,
            action: #selector(logoutButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    override func bind() {

        let input = MyPageViewModelInput(
            viewDidLoadTrigger: viewDidLoadTrigger.eraseToAnyPublisher(),
            logOutButtonTapped: loginButtonTappedTrigger.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        viewDidLoadTrigger.send()
        
        output.user
            .sink { [weak self] user in
                self?.nameLabel.text = user.name
                self?.posterImageView.image = UIImage(data: user.poster)
                self?.locationLabel.text = user.location
                self?.followersLabel.text = (self?.followersLabel.text)! + String(user.followers)
                self?.followingLabel.text = (self?.followingLabel.text)! + String(user.following)
            }
            .store(in: &cancellables)
        
        output.error
            .sink { [weak self] error in
                self?.showAlert(
                    title: "에러",
                    message: error.localizedDescription
                )
            }
            .store(in: &cancellables)
    }
    
    @objc private func logoutButtonTapped(_ sender: UIButton) {
        loginButtonTappedTrigger.send()
    }
}
