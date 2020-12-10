//
//  ArticleViewModel.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

class ArticleViewModel: NSObject {
    
    // MARK: - Properties
    
    var results = [ArticleData]()
    
    var articlePeriod: ArticlePeriod = .oneDay
    
    private var apiService: APIService!
    private var successCompletion: (() -> Void)
    private var failureCompletion: ((Error) -> Void)
    private var noDataCompletion: (() -> Void)
    
    // MARK: - Initialization
    
    init(success: @escaping (() -> Void), failure: @escaping ((Error) -> Void), noData: @escaping (() -> Void)) {
        apiService = APIService()
        successCompletion = success
        failureCompletion = failure
        noDataCompletion = noData
        super.init()
        getMostPopularArticles()
    }
    
    // MARK: - Methods
    
    func refreshMostPopularArticles() {
        getMostPopularArticles()
    }
}

extension ArticleViewModel {
    
    // MARK: - API Service
    
    private func getMostPopularArticles() {
        guard NetworkService.shared.isNetworkConnected else {
            getDatabaseArticleDatas(); return }
        apiService.getMostPopularArticles(period: articlePeriod) { [weak self] (article, error) in
            if let article = article {
                self?.results = article.results
                self?.writeResultsToRealm(articleDatas: article.results)
                self?.successCompletion()
            } else if let error = error {
                self?.failureCompletion(error)
            } else {
                self?.noDataCompletion()
            }
        }
    }
    
    private func getDatabaseArticleDatas() {
        let realmResults =  RealmManager.shared.getDatabaseArticleDatas(for: articlePeriod)
        guard !realmResults.isEmpty else { return }
        results = realmResults
        successCompletion()
    }
    
    private func writeResultsToRealm(articleDatas: [ArticleData]) {
        RealmManager.shared.deleteAllArticleData(for: articlePeriod)
        for articleData in articleDatas {
            RealmManager.shared.tryToWriteArticleDataToRealm(articleData: articleData, period: articlePeriod)
        }
    }
}
