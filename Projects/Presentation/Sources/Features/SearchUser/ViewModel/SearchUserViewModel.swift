//
//  SearchUserViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation
import Combine

import Domain

typealias loadingType = (type: SearchUserLoadingType, isLoading: Bool)

public protocol SearchUserCoordinatorActions: AnyObject {
    func backToLogin()
}

enum SearchUserLoadingType {
    case fullScreen
    case nextPage
}

struct SearchUserViewModelInput: ViewModelInput {
    let searchUser: AnyPublisher<String, Never>
    let loadNextPage: AnyPublisher<Void, Never>
    let backToLogin: AnyPublisher<Void, Never>
}

struct SearchUserViewModelOutput: ViewModelOutput {
    let users: AnyPublisher<[SearchUserItemViewModel], Never>
    let error: AnyPublisher<Error, Never>
    let isLoading: AnyPublisher<(type: SearchUserLoadingType, isLoading: Bool), Never>
}

final class SearchUserViewModel: BaseViewModel, ObservableObject {
    private var searchUserUseCase: SearchUserUseCaseInterface
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: SearchUserCoordinatorActions?
    
    typealias Input = SearchUserViewModelInput
    typealias Output = SearchUserViewModelOutput
    
    private var searchTask: Task<Void, Never>?
    private var loadNextPageTask: Task<Void, Never>?
    
    private let usersSubject = CurrentValueSubject<[SearchUserItemViewModel], Never>([])
    private let errorSubject = PassthroughSubject<Error, Never>()
    private let isLoadingSubject = CurrentValueSubject<loadingType, Never>((.fullScreen, false))
    
    var users: [SearchUserItemViewModel] {
        get {
            usersSubject.value
        }
    }
    
    init(
        searchUserUseCase: SearchUserUseCaseInterface
    ) {
        self.searchUserUseCase = searchUserUseCase
    }
    
    deinit {
        searchTask?.cancel()
        loadNextPageTask?.cancel()
    }
    
    func transform(input: SearchUserViewModelInput) -> SearchUserViewModelOutput {
        
        input.searchUser
            .filter { !$0.isEmpty }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                self?.searchUsers(query: query)
            }
            .store(in: &cancellables)
        
        input.loadNextPage
            .filter { [weak self] in
                return self?.searchUserUseCase.hasNextPage ?? false
            }
            .sink { [weak self] in
                self?.loadNextPage()
            }
            .store(in: &cancellables)
        
        input.backToLogin
            .sink { [weak self] in
                self?.coordinator?.backToLogin()
            }
            .store(in: &cancellables)
        
        return Output(
            users: usersSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher(),
            isLoading: isLoadingSubject.eraseToAnyPublisher()
        )
    }
    
    private func searchUsers(query: String) {
        searchTask?.cancel()
        
        isLoadingSubject.send((.fullScreen, true))
        
        searchTask = Task {
            do {
                let users = try await searchUserUseCase.searchInitialUsers(query: query)
                
                if !Task.isCancelled {
                    let viewModels = users.map { user in
                        return SearchUserItemViewModel(
                            usecase: searchUserUseCase,
                            user: user
                        )
                    }
                    
                    usersSubject.send(viewModels)
                }
            } catch {
                if !Task.isCancelled {
                    errorSubject.send(error)
                }
            }
            
            if !Task.isCancelled {
                isLoadingSubject.value.isLoading = false
            }
        }
    }
    
    private func loadNextPage() {
        guard loadNextPageTask == nil else { return }
        
        isLoadingSubject.send((.nextPage, true))
        
        loadNextPageTask = Task {
            do {
                let users = try await searchUserUseCase.loadNextPage()
                
                if !Task.isCancelled {
                    let viewModels = users.map { user in
                        return SearchUserItemViewModel(
                            usecase: searchUserUseCase,
                            user: user
                        )
                    }
                    
                    let existingIds = Set(usersSubject.value.map(\.user.id))
                    let uniqueViewModels = viewModels.filter { !existingIds.contains($0.user.id) }
                    
                    usersSubject.value.append(contentsOf: uniqueViewModels)
                }
            } catch {
                if !Task.isCancelled {
                    errorSubject.send(error)
                }
            }
            
            if !Task.isCancelled {
                isLoadingSubject.value.isLoading = false
                loadNextPageTask = nil
            }
        }
    }
}
