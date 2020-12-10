# NYTimes

NYTimes is a test application which is using [New York Times](https://developer.nytimes.com) most popular articles API call to show articles in the list and and navigate to details page.

## Installation

1. Open [Github](https://github.com/MichaelGrigoryan/NYTimes) project and download ZIP file.
2. Locate application folder and do ```pod install```
3. Open NYTimes.xcworkspace and run on simulator.

## What you can do in this application?

1. View list of New York Times's most popular articles simply by running application.
2. See detailed information of each article by clicking on the item on the list.
3. Update list for specified period of time (1 day, 7 days, or 30 days) by clicking on one of the top buttons in List page.

## What we have done in this application?
1. Created Articles List and Article Details page UI's using XIB
2. Created models and view model using ```MVVM```.
3. Created API service for handling HTTPS calls and callbacks.
4. Created local caching functionality for app to be able to work without internet connection.
5. Created Unit Target and UI tests.
6. Implemented SwiftLint for app to be more clear and simple.

## How you can run testes?
1. Open NYTimes.xcworkspace.
2. Do ```CMD + OPTION + U``` or in Xcode do ```Product -> Test```.

## What frameworks are we using?
1. [RealmSwift](https://realm.io/docs/swift/latest/) - Realm is a mobile database that runs directly inside phones, tablets or wearables.
2. [Alamofire](https://github.com/Alamofire/Alamofire) - Alamofire is an HTTP networking library written in Swift.
3. [AlamofireImage](https://github.com/Alamofire/AlamofireImage) - AlamofireImage is an image component library for Alamofire.
4. [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift) - This is a drop-in replacement for Apple's Reachability class. It is ARC-compatible, and it uses the new GCD methods to notify of network interface changes.
5. [SwiftLint](https://github.com/realm/SwiftLintt) - A tool to enforce Swift style and conventions, loosely based on GitHub's Swift Style Guide.

