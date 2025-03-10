import ProjectDescription

let project = Project(
    name: "CleanArchitecture-GitSearch",
    targets: [
        .target(
            name: "CleanArchitecture-GitSearch",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CleanArchitecture-GitSearch",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["CleanArchitecture-GitSearch/Sources/**"],
            resources: ["CleanArchitecture-GitSearch/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "CleanArchitecture-GitSearchTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanArchitecture-GitSearchTests",
            infoPlist: .default,
            sources: ["CleanArchitecture-GitSearch/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CleanArchitecture-GitSearch")]
        ),
    ]
)
