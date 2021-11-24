# DangerSwiftShoki

A danger-swift plug-in to manage/post danger checking results with markdown style

## Install DangerSwiftShoki

### SwiftPM (Recommended)

- Add dependency package to your `Package.swift` file which you import danger-swift

    ```
    // swift-tools-version:5.5
    ...
    let package = Package(
        ...
        dependencies: [
            ...
            // Danger Plugins
            .package(name: "DangerSwiftEda", url: "https://www.github.com/yumemi-inc/danger-swift-shoki.git", from: "0.1.0"),
            ...
        ],
        ...
    )
    ```

- Add the correct import to your `Dangerfile.swift` file

    ```
    import DangerSwiftShoki
    ```

### Marathon ([Tool Deprecated](https://github.com/JohnSundell/Marathon))

- Just add the dependency import to your `Dangerfile.swift` file like this:

    ```
    import DangerSwiftShoki // package: https://github.com/yumemi-inc/danger-swift-shoki.git
    ```

## Usage

- First of all create a result data structure with `CheckResult` initializer

    ```
    var checkResult = CheckResult(title: "My Check")
    ```

- Then you can perform any check with `check` method, by returning your check result in the trailing `execution` closure

    ```
    checkResult.check("Test Result Check") {
        if testPassed {
            return .good
            
        } else {
            if isAcceptable {
                warn("Encouraged to make a change but OK at this time")
                return .acceptable
                
            } else {
                fail("Must fix")
                return .rejected
            }
        }
    }
    ```

- You can also ask reviewers not to forget to do some manual checks with `askReviewer` method if needed

    ```
    checkResult.askReviewer(to: "Check whether commit messages are correctly formatted or not")
    ```

- At last post the whole check result with `shoki.report` method which is available for `DangerDSL` instances

    ```
    danger.shoki.report(checkResult) // Assume you have initialized `danger` by code like `let danger = Danger()`
    ```

## Preview

Code above will make danger producing markdown messages like below

> ## My Check
>
> Checking Item | Result
> | ---| --- |
> Test Result Check | :tada:
>
> - [ ] Check whether commit messages are correctly formatted or not
>
> Good Job :white_flower:

