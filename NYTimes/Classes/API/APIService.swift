//
//  APIService.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

import Alamofire

class APIService: NSObject {
        
    // MARK: - Properties
    
    private let nyTimesAPIKey = "92CsFnMqwbdfGYjNnWTER1lvhQEwLWVJ"
    
    private let mostPopularArticlesURLPath = "https://api.nytimes.com/svc/mostpopular/v2/viewed/%d.json?api-key=%@"
    
    // MARK: - API Call
    
    func getMostPopularArticles(period: ArticlePeriod, completion: @escaping (Article?, Error?) -> Void) {
        let url = URL(string: String(format: mostPopularArticlesURLPath, period.rawValue, nyTimesAPIKey))!
        AF.request(url).responseData { (data) in
            if let error = data.error?.underlyingError {
                completion(nil, error)
            } else if let data = data.value {
                let jsonDecoder = JSONDecoder()
                if let article = try? jsonDecoder.decode(Article.self, from: data) {
                    completion(article, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
}
