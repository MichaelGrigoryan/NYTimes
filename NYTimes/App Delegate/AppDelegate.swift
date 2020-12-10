//
//  AppDelegate.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Application's Life Cycle
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createInitialViewController()
        NetworkService.shared.startNotifier()
        return true
    }
    
    // MARK: - Methods
    
    private func createInitialViewController() {
        window = UIWindow()
        let articlesList = ArticlesListViewController()
        window?.rootViewController = UINavigationController(rootViewController: articlesList)
        window?.makeKeyAndVisible()
    }
}
