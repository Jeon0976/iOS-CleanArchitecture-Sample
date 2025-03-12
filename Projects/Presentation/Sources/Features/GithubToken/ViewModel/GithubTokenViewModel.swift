//
//  GithubTokenViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation
import Combine

import Domain

public protocol GithubTokenCoordinatorActions: AnyObject {
    func moveToRoot()
}

struct GithubTokenViewInput: ViewModelInput {
    let loginButtonTapped: AnyPublisher<Void, Never>
}

struct GithubTokenViewOutput: ViewModelOutput {
    let url: AnyPublisher<URL, Never>
    let error: AnyPublisher<Error, Never>
}

final class GithubTokenViewModel: BaseViewModel, ObservableObject {
    private var tokenUseCase: GithubTokenUseCaseInterface!
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: GithubTokenCoordinatorActions?
    
    typealias Input = GithubTokenViewInput
    typealias Output = GithubTokenViewOutput
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let urlSubject = PassthroughSubject<URL, Never>()
    
    init(githubTokenUseCase: GithubTokenUseCaseInterface) {
        self.tokenUseCase = githubTokenUseCase
    }
    
    func transform(
        input: GithubTokenViewInput
    ) -> GithubTokenViewOutput {
        
        bindLoginButtonTapped(input.loginButtonTapped)
        
        return Output(
            url: urlSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
    
    private func bindLoginButtonTapped(_ buttonTapped: AnyPublisher<Void, Never>) {
        buttonTapped
            .sink { [weak self] in
                self?.requestAuthorizationCode()
            }
            .store(in: &cancellables)
    }
    
    private func requestAuthorizationCode() {
        do {
            let url = try tokenUseCase.requestCode()
            
            urlSubject.send(url)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        errorSubject.send(error)
    }
    
    func handleAuthorizationCode(_ code: String) {
        Task {
            do {
                try await tokenUseCase.fetchGithubToken(with: code)
                
                navigateToRoot()
            } catch {
                handleError(error)
            }
        }
    }
    
    private func navigateToRoot() {
        coordinator?.moveToRoot()
    }
}
