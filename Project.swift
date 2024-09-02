import ProjectDescription

let project = Project(
    name: "Calendar",
    targets: [
        .target(
            name: "Calendar",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.reazon.Calendar",
            deploymentTargets: .macOS("14.5"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Calendar/Sources/**"],
            resources: ["Calendar/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "CalendarTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.reazon.CalendarTests",
            infoPlist: .default,
            sources: ["Calendar/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Calendar")]
        ),
    ]
)
