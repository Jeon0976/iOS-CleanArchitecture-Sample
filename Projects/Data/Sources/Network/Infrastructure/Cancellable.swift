//
//  Cancellable.swift
//  Data
//
//  Created by 전성훈 on 3/11/25.
//

import Foundation

protocol Cancellable {
    func cancel()
}

final class NetworkCancellable: Cancellable {
    private var task: URLSessionTask?
    
    init(task: URLSessionTask) {
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
    }
}
