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
    
}

struct MyPageViewModelOutput: ViewModelOutput {
    
}

final class MyPageViewModel: BaseViewModel, ObservableObject {
    private var userUseCase: UserUseCaseInterface
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var coordinator: MyPageCoordinatorActions?
    
    typealias Input = MyPageViewModelInput
    typealias Output = MyPageViewModelOutput
    
    init(
        userUseCase: UserUseCaseInterface
    ) {
        self.userUseCase = userUseCase
    }
    
    func transform(input: MyPageViewModelInput) -> MyPageViewModelOutput {
        
        return MyPageViewModelOutput()
    }
    
}
