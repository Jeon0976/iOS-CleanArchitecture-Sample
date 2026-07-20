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
            deploymentTargets: env.deploymentTargets,
            // 시크릿은 하드코딩하지 않는다 — 빌드 설정($(변수))으로 치환되며,
            // 실제 값은 루트 Secrets.xcconfig(gitignore 대상)에서 주입된다.
            infoPlist: .extendingDefault(with: [
                "Github_Client_Id": "$(GITHUB_CLIENT_ID)",
                "Github_Client_secrets": "$(GITHUB_CLIENT_SECRET)"
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
            ],
            settings: .settings(
                configurations: [
                    .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/Data.xcconfig")),
                    .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/Data.xcconfig"))
                ]
            )
        ),
        .target(
            name: "DataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: env.organizationName + ".DataTests",
            deploymentTargets: env.deploymentTargets,
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
