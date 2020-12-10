//
//  ImageViewExtensions.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

import Alamofire
import AlamofireImage

extension UIImageView {
    
    // MARK: - Methods
    
    /// Setting image retrieved from url by AlamofireImage framework.
    
    func setImage(from url: URL) {
        AF.request(url.absoluteString).responseImage { [weak self] response in
            if case .success(let image) = response.result {
                DispatchQueue.main.async { self?.image = image }
            }
        }
    }
}
