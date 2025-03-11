//
//  Project.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

import EnvironmentPlugin

let project = Project(
    name: "Data",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .framework,
            bundleId: env.organizationName + ".Data",
            infoPlist: .extendingDefault(with: [
                "Github_Client_Id": "Ov23liG36Nf0oA1Dbs8I",
                "Github_Client_secrets": "eacf64e05e0b265452dcc0a4c0396f1e83e2be50"
            ]),
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
            name: "DataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.organizationName + ".DataTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [
                .target(name: "Data")
            ]
        )
    ],
    schemes: [
        .scheme(
            name: "Data",
            shared: true,
            buildAction: .buildAction(
                targets: ["Data"]
            ),
            testAction: .targets(
                ["DataTests"],
                options: .options(
                    coverage: true,
                    codeCoverageTargets: ["Data"]
                )
            )
        )
    ]
)
