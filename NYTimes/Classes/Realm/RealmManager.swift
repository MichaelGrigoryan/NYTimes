//
//  RealmManager.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/10/20.
//

// MARK: - Struct

struct RealmData {
    
    // MARK: - Properties
    
    var period: ArticlePeriod
    var imageData: Data?
    var thumbnailData: Data?
}

import RealmSwift

class RealmManager: NSObject {
    
    // MARK: - Instance
    
    static let shared = RealmManager()
    
    // MARK: - Properties
    
    private var realm = try? Realm()
    
    // MARK: - Writing
    
    func tryToWriteArticleDataToRealm(articleData: ArticleData, period: ArticlePeriod) {
        guard let thumbnailURL = articleData.media?.thumbnailMetadata?.url,
              let imageURL = articleData.media?.imageMetadata?.url
        else { saveArticleData(articleData: articleData, realmData: RealmData(period: period)); return }
        downloadData(for: thumbnailURL) { (thumbnailData) in
            self.downloadData(for: imageURL) { (imageData) in
                DispatchQueue.main.async {
                    let realmData = RealmData(period: period,
                                              imageData: imageData, thumbnailData: thumbnailData)
                    self.saveArticleData(articleData: articleData, realmData: realmData)
                }
            }
        }
    }
    
    private func downloadData(for url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            completion(data)
        }.resume()
    }
    
    func deleteAllArticleData(for period: ArticlePeriod) {
        guard let articleDatasForPeriod = realm?.objects(ArticleData.self)
                .filter("periodRawValueString=%@", String(period.rawValue)),
              !articleDatasForPeriod.isEmpty else { return }
        DispatchQueue.main.async {
            try? self.realm?.write {
                 self.realm?.delete(articleDatasForPeriod)
            }
        }
    }
    
    private func saveArticleData(articleData: ArticleData, realmData: RealmData) {
        try? realm?.write {
            articleData.periodRawValueString = String(realmData.period.rawValue)
            articleData.media?.thumbnailMetadata?.data = realmData.thumbnailData
            articleData.media?.imageMetadata?.data = realmData.imageData
            realm?.add(articleData)
        }
    }
    
    // MARK: - Methods
    
    func getDatabaseArticleDatas(for period: ArticlePeriod) -> [ArticleData] {
        return realm?.objects(ArticleData.self)
            .filter("periodRawValueString=%@", String(period.rawValue))
            .compactMap({$0}) ?? []
    }
}
