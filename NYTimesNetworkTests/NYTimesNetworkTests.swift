//
//  NYTimesNetworkTests.swift
//  NYTimesNetworkTests
//
//  Created by Michael Grigoryan on 12/10/20.
//

import XCTest
@testable import NYTimes
import Alamofire

class NYTimesNetworkTests: XCTestCase {
    
    // MARK: - Methods to Test
    
    func testMostPopularArticlesAPICall() {
        let nyTimesAPIKey = "92CsFnMqwbdfGYjNnWTER1lvhQEwLWVJ"
        let mostPopularArticlesURLPath = "https://api.nytimes.com/svc/mostpopular/v2/viewed/%d.json?api-key=%@"
        let period = ArticlePeriod.sevenDay
        let url = URL(string: String(format: mostPopularArticlesURLPath,
                                     period.rawValue, nyTimesAPIKey))!
        let promise = expectation(description: "Data successfully converted to model.")
        AF.request(url).responseData { (data) in
            if let error = data.error?.underlyingError {
                XCTFail("Found error: \(error.localizedDescription).")
                return
            }
            if let data = data.value {
                let jsonDecoder = JSONDecoder()
                let article = try? jsonDecoder.decode(Article.self, from: data)
                if article != nil {
                    promise.fulfill()
                } else {
                    XCTFail("Could not convert data via JSONDecoder.")
                }
            } else {
                XCTFail("Neither found data nor error.")
            }
        }
        wait(for: [promise], timeout: 5.0)
    }
    
    func testDownloadingThumbnaiForArticleData() {
        let basePath = "https://static01.nyt.com/images"
        let thumbnailPromise = expectation(description: "Successfully downloaded thumbnail.")
        guard let url = URL(string: "\(basePath)/2020/12/06/opinion/04kristof-2-R/04kristof-2-thumbStandard.jpg"),
              UIApplication.shared.canOpenURL(url) else { XCTFail("Wrong download url."); return }
        URLSession.shared.dataTask(with: url) { (thumbnailData, _, thumbnailError) in
            if let error = thumbnailError {
                XCTFail("Found error: \(error.localizedDescription).")
            } else if thumbnailData != nil {
                thumbnailPromise.fulfill()
            } else {
                XCTFail("Neither found data nor error.")
            }
        }.resume()
        wait(for: [thumbnailPromise], timeout: 5.0)
    }
}
