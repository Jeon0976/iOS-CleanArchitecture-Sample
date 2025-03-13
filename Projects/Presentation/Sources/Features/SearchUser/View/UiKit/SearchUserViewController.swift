//
//  SearchUserViewController.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import UIKit
import Combine

import Domain

final class SearchUserViewController: BaseViewController {
    // MARK: - Property
    var viewModel: SearchUserViewModel!
    
    private let searchUser = PassthroughSubject<String, Never>()
    private let loadNextPage = PassthroughSubject<Void, Never>()
    private let pushLoginVC = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Component
    private lazy var searchField: SearchField = {
        let view = SearchField()
        
        view.textColor = .black
        view.addTarget(
            self,
            action: #selector(searchFieldEditing(_:)),
            for: .editingDidBegin
        )
        view.addTarget(
            self,
            action: #selector(searchFieldEditing(_:)),
            for: .editingChanged
        )
        
        return view
    }()
    
    private lazy var githubUsersTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SearchUserCell.self,
            forCellReuseIdentifier: SearchUserCell.identifier
        )
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private let emptyUserList: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        label.textColor = .black
        label.text = "Empty"
        
        return label
    }()
    
    private let fullLoadingSpinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.style = .large
        view.startAnimating()
        view.isHidden = true
        view.color = .black
        
        return view
    }()
    
    private var nextPageLoadingSpinner: UIActivityIndicatorView?
    
    init(viewModel: SearchUserViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        [
            searchField,
            githubUsersTableView,
            emptyUserList,
            fullLoadingSpinner
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            searchField.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 16
            ),
            searchField.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -16
            ),
            
            githubUsersTableView.topAnchor.constraint(
                equalTo: searchField.bottomAnchor
            ),
            githubUsersTableView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 16
            ),
            githubUsersTableView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -16
            ),
            githubUsersTableView.bottomAnchor.constraint(
                equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
            ),
            
            emptyUserList.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emptyUserList.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            fullLoadingSpinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            fullLoadingSpinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    override func setupAttribute() {
        self.view.backgroundColor = .white
        
        searchField.delegate = self
        searchField.textFieldShouldSearch = { [weak self] in
            guard let self = self else { return }
            
            self.didSearchUser()
        }
    }
    
    // MARK: - Binding
    override func bind() {
        let input = SearchUserViewModelInput(
            searchUser: searchUser.eraseToAnyPublisher(),
            loadNextPage: loadNextPage.eraseToAnyPublisher(),
            backToLogin: pushLoginVC.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        var isFirstShow = true
        
        output.users
            .sink { [weak self] users in
                guard users.count > 0 else {
                    guard !isFirstShow else {
                        isFirstShow = !isFirstShow
                        return
                    }
                    
                    self?.githubUsersTableView.isHidden = true
                    self?.emptyUserList.isHidden = false
                    
                    return
                }
                
                self?.githubUsersTableView.isHidden = false
                self?.emptyUserList.isHidden = true
                
                self?.githubUsersTableView.reloadData()
            }
            .store(in: &cancellables)
        
                output.isLoading
                    .sink { [weak self] loading in
        
                        if loading.type == .fullScreen {
                            self?.loadingTableViewWhenFullScreen(with: loading.isLoading)
                        } else {
                            self?.loadingTableViewWhenNextpage(with: loading.isLoading)
                        }
                    }
                    .store(in: &cancellables)
        
        output.error
            .sink { [weak self] error in
                if let useCaseError = error as? SearchUserUseCaseError {
                    self?.handleUseCaseError(useCaseError)
                } else {
                    self?.showAlert(
                        title: "에러",
                        message: error.localizedDescription
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadingTableViewWhenFullScreen(with loading: Bool) {
        self.fullLoadingSpinner.isHidden = !loading
        
        if loading {
            self.githubUsersTableView.isHidden = loading
            self.emptyUserList.isHidden = loading
        }
    }
    
    private func loadingTableViewWhenNextpage(with loading: Bool) {
        nextPageLoadingSpinner?.removeFromSuperview()
        
        if loading {
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(
                width: githubUsersTableView.frame.width,
                height: 50)
            )
            
            githubUsersTableView.tableFooterView = nextPageLoadingSpinner
        } else {
            githubUsersTableView.tableFooterView = nil
            nextPageLoadingSpinner = nil
        }
    }
    
    private func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.color = .black
        activityIndicator.frame = .init(origin: .zero, size: size)
        
        return activityIndicator
    }
    
    // MARK: - Error Handling
    // TODO: - 네트워크 통신 후 토큰 만료시 에러 처리 구현 필요
    private func handleUseCaseError(_ error: SearchUserUseCaseError) {
        switch error {
        case .tokenNotFound:
            self.showAlert(
                title: "에러",
                message: "다시 로그인해주세요.",
                actions: [
                    AlertAction(
                        "확인",
                        .default,
                        { [weak self] in
                            self?.pushLoginVC.send()
                        }
                    )
                ]
            )
        case .noNextPage:
            break
        case .queryMissing:
            self.showAlert(
                title: "에러",
                message: "검색어를 입력해주세요."
            )
        }
    }
    
    
    // MARK: - Input
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        if searchField.endEditing(true) {
            self.view.endEditing(true)
        }
    }
    
    @objc private func searchFieldEditing(_ sender: SearchField) {
        if sender.text != "" {
            sender.rightButtonHidden = false
            sender.isEditingField = true
        } else {
            sender.rightButtonHidden = true
        }
    }
    
    private func didSearchUser() {
        guard let user = searchField.text else { return }
        
        searchUser.send(user)
    }
}

extension SearchUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.endEditing(true) {
            self.view.endEditing(true)
            
            didSearchUser()
        }
        
        return true
    }
}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.users.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchUserCell.identifier,
            for: indexPath
        ) as? SearchUserCell else {
            return UITableViewCell()
        }
        
        cell.bind(with: viewModel.users[indexPath.row])
        
        if indexPath.row == viewModel.users.count - 5 {
            loadNextPage.send()
        }
        
        return cell
    }
}

extension SearchUserViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let cell = tableView.cellForRow(at: indexPath)
                as? SearchUserCell else { return }
        
        let url = cell.getURL()
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchField.isEditing {
            if searchField.endEditing(true) {
                self.view.endEditing(true)
            }
        }
    }
}
