//
//  SearchUserItemViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import Foundation
import Combine

import Domain

struct SearchUserItemViewModelInput: ViewModelInput { }

struct SearchUserItemViewModelOutput: ViewModelOutput {
    let imageData: AnyPublisher<Data, Never>
    let error: AnyPublisher<Error, Never>
}

final class SearchUserItemViewModel: BaseViewModel, ObservableObject {
    private let usecase: SearchUserUseCaseInterface
    
    private var cancellables = Set<AnyCancellable>()
    private var imageTask: Task<Void, Never>?

    
    typealias Input = SearchUserItemViewModelInput
    typealias Output = SearchUserItemViewModelOutput
    
    private(set) var user: GithubUser
    
    private let imageDataSubject = PassthroughSubject<Data, Never>()
    private let errorSubject = PassthroughSubject<Error, Never>()

    init(
        usecase: SearchUserUseCaseInterface,
        user: GithubUser
    ) {
        self.usecase = usecase
        self.user = user
    }
    
    deinit {
        imageTask?.cancel()
    }
    
    func transform(input: SearchUserItemViewModelInput) -> SearchUserItemViewModelOutput {
        
        return Output(
            imageData: imageDataSubject.eraseToAnyPublisher(),
            error: errorSubject.eraseToAnyPublisher()
        )
    }
    
    func fetchImage() {
        imageTask?.cancel()
        
        imageTask = Task {
            do {
                let imageData = try await usecase.fetchUserImage(
                    with: user.posterPath,
                    id: user.id
                )
                
                if !Task.isCancelled {
                    imageDataSubject.send(imageData)
                }
            } catch {
                if !Task.isCancelled {
                    errorSubject.send(error)
                }
            }
        }
    }
}

extension SearchUserItemViewModel: Equatable {
    static func == (
        lhs: SearchUserItemViewModel,
        rhs: SearchUserItemViewModel
    ) -> Bool {
        return lhs.user.id == rhs.user.id
    }
}
