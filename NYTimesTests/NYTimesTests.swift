//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Michael Grigoryan on 12/10/20.
//

import XCTest
@testable import NYTimes

class NYTimesNetworkTests: XCTestCase {
    
    // MARK: - Properties
    
    /// SUT stands for  System Under Test.
    
    var sut: ArticlesListViewController!

    // MARK: - XCTest's Life Cycle
    
    override func setUp() {
        sut = ArticlesListViewController()
        sut.view.layoutIfNeeded()
            
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Methods to Test

    func testHandlingArticleViewModel() {
        let promise = expectation(description: "Article View Model succesfully created.")
        sut.articleViewModel = ArticleViewModel(success: {
            promise.fulfill()
        }, failure: { (error) in
            XCTFail("Found error: \(error.localizedDescription).")
        }, noData: {
            XCTFail("Neither found data nor error.")
        })
        wait(for: [promise], timeout: 5.0)
    }
    
    func testSegmentedControlIndexChanges() {
        var articlePeriod: ArticlePeriod?
        switch sut.segmentedControl.selectedSegmentIndex {
        case 0: articlePeriod = .oneDay
        case 1: articlePeriod = .sevenDay
        case 2: articlePeriod = .thirtyDay
        default: break }
        XCTAssertEqual(articlePeriod == nil, false, "Article period is null.")
    }
    
    func testOfflineLabelAppearance() {
        let isNetworkConnected = NetworkService.shared.isNetworkConnected
        let isOfflineModeLabelHidden = sut.offlineModeLabel.isHidden
        if isNetworkConnected && !isOfflineModeLabelHidden {
            XCTFail("Network is connected but offline mode label is visible.")
        }
        if !isNetworkConnected && isOfflineModeLabelHidden {
            XCTFail("Network is not connected but offline mode label is not visible.")
        }
    }
}
