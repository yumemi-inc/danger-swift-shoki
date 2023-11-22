import Foundation
import Danger
import DangerSwiftEda // package: https://github.com/yumemi-inc/danger-swift-eda.git

// MARK: - チェックルーチン
let danger = Danger()

// SwiftLint のワーニング等確認
SwiftLint.lint(.modifiedAndCreatedFiles(directory: nil), inline: true, swiftlintPath: .swiftPackage("$(pwd)/Danger"))

// PR ルーチンチェック
let configuration = GitHubFlow.Configuration(
    suggestsChangeLogUpdate: .no
)
danger.eda.checkPR(workflow: GitHubFlow(configuration: configuration))
