//
//  MockSearchUserCoordinator.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

import Presentation

final class MockSearchUserCoordinator: SearchUserCoordinatorActions {
    
    var backToLoginCalled = false
    
    func backToLogin() {
        backToLoginCalled = true
    }
}
