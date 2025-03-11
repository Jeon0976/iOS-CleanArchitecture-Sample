//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: env.name,
    targets: [
        .target(
            name: env.name,
            destinations: .iOS,
            product: .app,
            bundleId: env.organizationName,
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
                    target: "Data",
                    path: .relativeToRoot("Projects/Data"),
                    status: .none,
                    condition: nil
                ),
                .project(
                    target: "Presentation",
                    path: .relativeToRoot("Projects/Presentation"),
                    status: .none,
                    condition: nil
                )
            ]
        ),
        .target(
            name: env.name + "Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.name + "Tests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: env.name)]
        )
    ]
)
