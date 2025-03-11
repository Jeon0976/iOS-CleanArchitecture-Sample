//
//  Workspace.swift
//  Manifests
//
//  Created by 전성훈 on 3/11/25.
//

import ProjectDescription
import EnvironmentPlugin

let workspace = Workspace(
    name: env.name,
    project: ["Projects/App"]
)
