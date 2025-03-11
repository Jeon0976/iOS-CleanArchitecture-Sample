//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "DependencyInjection",
    targets: [
        .target(
            name: "DependencyInjection",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".DependencyInjection",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ],
    schemes: [
        .scheme(
            name: "DependencyInjection",
            shared: true,
            buildAction: .buildAction(
                targets: ["DependencyInjection"]
            )
        )
    ]
)
