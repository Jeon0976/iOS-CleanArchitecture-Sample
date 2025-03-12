//
//  BaseViewModel.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

@MainActor
public protocol CoordinatorActions: AnyObject {}

public protocol ViewModelInput {}
public protocol ViewModelOutput {}

@MainActor
public protocol BaseViewModel {
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput
    
    func transform(input: Input) -> Output
}
