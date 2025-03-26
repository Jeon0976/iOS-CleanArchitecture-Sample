//
//  ViewModelFactory.swift
//  Presentation
//
//  Created by 전성훈 on 3/26/25.
//

@MainActor
final class PreviewViewFactory {

    static let shared = PreviewViewFactory()
    
    private init() { }
    
    func makeGithubTokenView() -> GithubTokenView {
        GithubTokenView(viewModel: GithubTokenViewModel(githubTokenUseCase: MockGithubTokenUseCase()))
    }
}
