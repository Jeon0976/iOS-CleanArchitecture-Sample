//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "Core",
    targets: [
        .target(
            name: "Core",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".Core",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: [
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Projects/DependencyInjection")
                ),
                .project(
                    target: "Shared",
                    path: .relativeToRoot("Projects/Shared")
                )
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Core",
            shared: true,
            buildAction: .buildAction(
                targets: ["Core"]
            )
        )
    ]
)
