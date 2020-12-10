//
//  NavigationControllerExtensions.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

extension UINavigationController {
    
    // MARK: - Methods
    
    /// Setting up navigation bar by passing background and tint colors to it.

    func setupNavigationBar(backgroundColor: UIColor = .black,
                            tintColor: UIColor = .white) {
        let standardAppearance = navigationBar.standardAppearance
        standardAppearance.shadowColor = .clear
        standardAppearance.backgroundColor = backgroundColor
        navigationBar.standardAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = standardAppearance
        navigationBar.tintColor = tintColor
    }
}
