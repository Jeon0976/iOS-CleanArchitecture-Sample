//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Shared",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".Shared",
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [],
            dependencies: []
        )
    ],
    schemes: [
        .scheme(
            name: "Shared",
            shared: true,
            buildAction: .buildAction(
                targets: ["Shared"]
            )
        )
    ]
)
