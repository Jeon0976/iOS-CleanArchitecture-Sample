//
//  GithubTokenView.swift
//  Presentation
//
//  Created by 전성훈 on 3/11/25.
//

import SwiftUI
import Combine

struct GithubTokenView: View {
    @ObservedObject var viewModel: GithubTokenViewModel
    
    @State private var showErrorAlert = false
    @State private var errorDescription: String = ""
    
    private let loginButtonTapped = PassthroughSubject<Void, Never>()
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            WelcomeLabel()
            
            Spacer()
            
            GithubLoginButton()
                .padding()
        }
    }
}

private extension GithubTokenView {
    func WelcomeLabel() -> some View {
        Text("환영합니다!")
        .font(.system(size: 20, weight: .medium))
        .foregroundStyle(.black)
        .multilineTextAlignment(.center)
    }
    
    func GithubLoginButton() -> some View {
        Button(action: {
            loginButtonTapped.send()
        }, label: {
            Text("GitHub AccessToken 불러오기")
            .foregroundStyle(.white)
            .padding()
            .background(.black)
            .clipShape(.rect(cornerRadius: 6))
        })
        .frame(height: 55)
    }
}

private extension GithubTokenView {
    func bind() {    }
}

#Preview {
    PreviewViewFactory.shared.makeGithubTokenView()
}
