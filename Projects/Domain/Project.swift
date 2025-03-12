//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".Domain",
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
                    target: "Core",
                    path: .relativeToRoot("Projects/Core")
                ),
                .project(
                    target: "Shared",
                    path: .relativeToRoot("Projects/Shared")
                )
            ]
        ),
        .target(
            name: "DomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.organizationName + ".DomainTests",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Domain"),
                .project(
                    target: "Core",
                    path: .relativeToRoot("Projects/Core")
                )
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Domain",
            shared: true,
            buildAction: .buildAction(
                targets: ["Domain"]
            ),
            testAction: .targets(
                ["DomainTests"],
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["Domain"]
                )
            )
        )
    ]
)
