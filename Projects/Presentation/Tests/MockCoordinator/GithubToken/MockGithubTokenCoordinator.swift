//
//  MockGithubTokenCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/12/25.
//

import Presentation

final class MockGithubTokenCoordinator: GithubTokenCoordinatorActions {
    
    var moveToRootCalled = false
    
    func moveToRoot() {
        moveToRootCalled = true
    }
}
