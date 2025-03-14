//
//  MyPageViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/13/25.
//

import Foundation
import Combine

import Domain

protocol MyPageCoordinatorActions: AnyObject {
    func backToLogin()
}

struct MyPageViewModelInput: ViewModelInput {
    let viewDidLoadTrigger: AnyPublisher<Void, Never>
    let logOutButtonTapped: AnyPublisher<Void, Never>
}

struct MyPageViewModelOutput: ViewModelOutput {
    let user: AnyPublisher<User, Never>
    let error: AnyPublisher<Error, Never>
}

final class MyPageViewModel: BaseViewModel, ObservableObject {
    private var userUseCase: UserUseCaseInterface
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: MyPageCoordinatorActions?
    
    typealias Input = MyPageViewModelInput
    typealias Output = MyPageViewModelOutput
    
    private var userSubject = PassthroughSubject<User, Never>()
    private var errorSubject = PassthroughSubject<Error, Never>()
    
    init(
        userUseCase: UserUseCaseInterface
    ) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        
        input.viewDidLoadTrigger
            .sink { [weak self] in
                self?.fetchUser()
            }
            .store(in: &cancellables)
        
        input.logOutButtonTapped
            .sink { [weak self] in
                self?.userUseCase.logout()
                self?.coordinator?.backToLogin()
            }
            .store(in: &cancellables)
        
        return MyPageViewModelOutput(
            user: userSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
    
    private func fetchUser() {
        Task {
            do {
                let user = try await userUseCase.fetchUser()
                userSubject.send(user)
            } catch {
                errorSubject.send(error)
            }
        }
    }
}
