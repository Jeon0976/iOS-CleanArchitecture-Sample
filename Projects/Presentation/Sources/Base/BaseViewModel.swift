//
//  BaseViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

@MainActor
protocol CoordinatorActions: AnyObject {}

protocol ViewModelInput {}
protocol ViewModelOutput {}

@MainActor
protocol BaseViewModel {
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput
    
    func transform(input: Input) -> Output
}
