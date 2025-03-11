//
//  ProjectEnvironment.swift
//  EnvironmentPlugin
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription

public struct ProjectEnvironment: Sendable {
    public let name: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let destination: Set<Destination>
    public let baseSetting: SettingsDictionary
}

public let env = ProjectEnvironment(
    name: "GitSearch",
    organizationName: "com.gitsearch.iOS",
    deploymentTargets: .iOS("16.0"),
    destination: [.iPhone],
    baseSetting: SettingsDictionary()
        .marketingVersion("0.0.1")
        .currentProjectVersion("1")
)
