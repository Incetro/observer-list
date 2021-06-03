
<h1 align="center" style="margin-top: 0px;">ObserverList</h1>

<div align = "center">
  <a href="https://cocoapods.org/pods/incetro-observer-list">
    <img src="https://img.shields.io/cocoapods/v/incetro-observer-list.svg?style=flat" />
  </a>
  <a href="https://github.com/Incetro/observer-list">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" />
  </a>
  <a href="https://github.com/Incetro/observer-list#installation">
    <img src="https://img.shields.io/badge/compatible-swift%205.3-orange.svg" />
  </a>
</div>

<div align = "center">
  <a href="https://cocoapods.org/pods/incetr-observer-list" target="blank">
    <img src="https://img.shields.io/cocoapods/p/incetro-observer-list.svg?style=flat" />
  </a>
  <a href="https://cocoapods.org/pods/incetro-observer-list" target="blank">
    <img src="https://img.shields.io/cocoapods/l/incetro-observer-list.svg?style=flat" />
  </a>
  <br>
  <br>
</div>

An implementation of observable weak collection for Swift. Now you can think less about retain cycles in your applications.

- [Usage](#usage)
- [Requirements](#requirements)
- [Communication](#communication)
- [Installation](#installation)
- [Author](#author)
- [License](#license)

## Usage

If you want to notify some elements about some actions and you don't want to get a retain cycle you can use `ObserverList` for storing and notifying your elements.

### Example №1

```swift
typealias FirstClosure = (Int) -> Void
typealias SecondClosure = () -> Void
typealias ThirdClosure = (String, String) -> Void

// MARK: - SomeObserving

struct SomeObserving {

    // MARK: - Properties

    let firstClosure: FirstClosure?
    let secondClosure: SecondClosure?
    let thirdClosure: ThirdClosure?

    // MARK: - Initializers

    init(
        firstClosure: FirstClosure? = nil,
        secondClosure: SecondClosure? = nil,
        thirdClosure: ThirdClosure? = nil
    ) {
        self.firstClosure = firstClosure
        self.secondClosure = secondClosure
        self.thirdClosure = thirdClosure
    }
}

// MARK: MyService

final class MyService {

    // MARK: - Properties

    private let observers = ObserverList<SomeObserving>()

    // MARK: - Useful

    func add(observer: AnyObject, closures: SomeObserving) {
        observers.addObserver(disposable: observer, observer: closures)
    }

    func remove(observer: AnyObject) {
        observers.removeObserver(disposable: observer)
    }

    func someEvent(_ int: Int) {
        observers.forEach { closures in
            closures.firstClosure?(int)
        }
    }

    func someEvent() {
        observers.forEach { closures in
            closures.secondClosure?()
        }
    }

    func someEvent(string1: String, string2: String) {
        observers.forEach { closures in
            closures.thirdClosure?(string1, string2)
        }
    }
}

```

### Example №2

```swift
// MARK: - UserLocationPlainObject

struct UserLocationPlainObject {

    // MARK: - Properties

    /// Current user coordinate
    let coordinate: CoordinatesPlainObject

    /// User's heading
    let heading: Double

    /// Current user speed
    let speed: Double
}

/// Services success block for `Obtain` operation
typealias ServiceObtainSuccessBlock<T> = (T) -> Void

// MARK: - UserLocationServiceObservable

final class UserLocationServiceObservable: NSObject {

    // MARK: - Properties

    /// All current user location observers
    private var userLocationObservers = ObserverList<ServiceObtainSuccessBlock<UserLocationPlainObject>>()

    /// CLLocationManager instance
    private let locationManager = CLLocationManager()

    // MARK: - Initializers

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    // MARK: - Useful

    func add(
        observer: AnyObject,
        onLocationUpdate: @escaping ServiceObtainSuccessBlock<UserLocationPlainObject>
    ) {
        userLocationObservers.addObserverIfNotContains(
            disposable: observer,
            observer: onLocationUpdate
        )
    }

    func remove(observer: AnyObject) {
        userLocationObservers.removeObserver(disposable: observer)
    }

    // MARK: - Private

    private func setup() {
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
    }
}

// MARK: - CLLocationManagerDelegate

extension UserLocationServiceObservable: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let userLocation = locations[0]
        let location = UserLocationPlainObject(
            coordinate: .init(userLocation.coordinate),
            heading: userLocation.course,
            speed: max(0, (userLocation.speed * 60 * 60) / 1_000)
        )
        userLocationObservers.forEach { block in
            block(location)
        }
    }
}

```
	
## Requirements
- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 12.0
- Swift 5

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ObsserverList into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
use_frameworks!

target "<Your Target Name>" do
    pod "incetro-observer-list"
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually

If you prefer not to use any dependency managers, you can integrate ObserverList into your project manually.

#### Drag and drop

Just drag and drop `ObserverList.swift` into your project!

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add ObserverList as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/Incetro/observer-list.git
  ```

- Open the new `ObserverList` folder, and drag the `ObserverList.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `ObserverList.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `ObserverList.xcodeproj` folders each with two different versions of the `ObserverList.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `ObserverList.framework`.

- Select the top `ObserverList.framework` for iOS and the bottom one for OS X.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `Nio` will be listed as either `ObserverList iOS`, `ObserverList macOS`, `ObserverList tvOS` or `ObserverList watchOS`.

- And that's it!

  > The `ObserverList.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
  
## Author

incetro, incetro@ya.ru

## License

ObserverList is available under the MIT license. See the LICENSE file for more info.
