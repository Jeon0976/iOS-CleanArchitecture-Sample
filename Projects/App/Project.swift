//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin


let configuration: [Configuration] = [.debug(name: .debug), .release(name: .release)]

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configuration,
    defaultSettings: .recommended
)


let project = Project(
    name: env.name,
    organizationName: env.organizationName,
    settings: settings,
    targets: [
        .target(
            name: env.name,
            destinations: .iOS,
            product: .app,
            bundleId: env.organizationName + "App",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(
                    target: "Data",
                    path: .relativeToRoot("Projects/Data")
                ),
                .project(
                    target: "Presentation",
                    path: .relativeToRoot("Projects/Presentation")
                ),
                .project(
                    target: "Shared",
                    path: .relativeToRoot("Projects/Shared")
                )
            ],
            settings: .settings(base: env.baseSetting)
        ),
        .target(
            name: env.name + "Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.organizationName + "Tests",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: env.name)]
        )
    ],
    schemes: [
        .scheme(
            name: env.name,
            shared: true,
            buildAction: .buildAction(
                targets: ["\(env.name)"]
            ),
            testAction: .targets(
                ["\(env.name)Tests"],
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["\(env.name)"]
                )
            )
            
        )
    ]
)
