//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "Presentation",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".Presentation",
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
                    target: "Domain",
                    path: .relativeToRoot("Projects/Domain")
                ),
                .project(
                    target: "Shared",
                    path: .relativeToRoot("Projects/Shared")
                )
            ]
        ),
        .target(
            name: "PresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.organizationName + ".PresentationTests",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Presentation"),
                .project(
                    target: "Domain",
                    path: .relativeToRoot("Projects/Domain")
                )
            ]
        ),
        .target(
            name: "PresentationUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: env.organizationName + ".PresentationUITests",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .default,
            sources: ["UITests/**"],
            resources: [],
            dependencies: [
                .target(name: "Presentation")]
        ),
    ],
    schemes: [
        .scheme(
            name: "Presentation",
            shared: true,
            buildAction: .buildAction(
                targets: ["Presentation"]
            ),
            testAction: .targets(
                ["PresentationTests", "PresentationUITests"],
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["Presentation"]
                )
            )
        )
    ]
)

