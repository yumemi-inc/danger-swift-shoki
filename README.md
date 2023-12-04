[![CI](https://github.com/yumemi-inc/danger-swift-shoki/actions/workflows/ci.yml/badge.svg)](https://github.com/yumemi-inc/danger-swift-shoki/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyumemi-inc%2Fdanger-swift-shoki%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yumemi-inc/danger-swift-shoki)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyumemi-inc%2Fdanger-swift-shoki%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yumemi-inc/danger-swift-shoki)

# DangerSwiftShoki

A danger-swift plug-in to manage/post danger checking results with markdown style

## Install DangerSwiftShoki

### SwiftPM (Recommended)

- Add dependency package to your `Package.swift` file which you import danger-swift

    ```swift
    // swift-tools-version:5.5
    ...
    let package = Package(
        ...
        dependencies: [
            ...
            // Danger Plugins
            .package(name: "DangerSwiftShoki", url: "https://www.github.com/yumemi-inc/danger-swift-shoki.git", from: "0.1.0"),
            ...
        ],
        ...
    )
    ```

- Add the correct import to your `Dangerfile.swift` file

    ```swift
    import DangerSwiftShoki
    ```

### Marathon ([Tool Deprecated](https://github.com/JohnSundell/Marathon))

- Just add the dependency import to your `Dangerfile.swift` file like this:

    ```swift
    import DangerSwiftShoki // package: https://github.com/yumemi-inc/danger-swift-shoki.git
    ```

## Usage

Basically just use `.shoki` property from a `DangerDSL` instance to access all features provided by DangerSwiftShoki

Examples below assume you have initialized a `danger` using `Danger()` in your `Dangerfile.swift`

- First of all create a report data structure with `makeInitialReport` method

    ```swift
    var report = danger.shoki.makeInitialReport(title: "My Report")
    ```

- Then you can perform any checks with `check` method, by returning your check result in the trailing `execution` closure

    ```swift
    danger.shoki.check("Test Result Check", into: &report) {
        if testPassed {
            return .good
            
        } else {
            if isAcceptable {
                return .acceptable(warningMessage: "Encouraged to make a change but OK at this time")
                
            } else {
                return .rejected(failureMessage: "Must fix")
            }
        }
    }
    ```

- You can also ask reviewers not to forget to do some manual checks with `askReviewer` method if needed

    ```swift
    danger.shoki.askReviewer(to: "Check whether commit messages are correctly formatted or not", into: $report)
    ```

- At last post the whole check result with `report` method

    ```swift
    danger.shoki.report(report)
    ```

## Preview

Code above will make danger producing markdown messages like below

> ## My Report
>
> Checking Item | Result
> | ---| --- |
> Test Result Check | :tada:
>
> - [ ] Check whether commit messages are correctly formatted or not
>
> Good Job :white_flower:

