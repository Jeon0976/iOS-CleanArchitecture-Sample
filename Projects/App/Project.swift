//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "CleanArchitecture-GitSearch",
    targets: [
        .target(
            name: "CleanArchitecture-GitSearch",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CleanArchitecture-GitSearch",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Projects/DependencyInjection"),
                    status: .none,
                    condition: nil
                )
            ]
        ),
        .target(
            name: "CleanArchitecture-GitSearchTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanArchitecture-GitSearchTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "CleanArchitecture-GitSearch")]
        ),
    ]
)
