//
//  BaseViewController.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

class BaseViewController: UIViewController {

    // MARK: - View Controller's Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        navigationController?.setupNavigationBar()
        
        createNYTimesTitleView()
    }
    
    // MARK: - Methods
        
    private func createNYTimesTitleView() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let navigationBarFrame = navigationBar.frame
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo_icon"))
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(
                equalToConstant: navigationBarFrame.height - 8.0),
            imageView.widthAnchor.constraint(
                equalToConstant: navigationBarFrame.height - 8.0)
        ])
        navigationItem.titleView = imageView
    }
    
    func showError(message: String, animated: Bool = true) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil))
        present(alert, animated: animated, completion: nil)
    }
}
