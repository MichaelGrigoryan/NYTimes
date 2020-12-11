//
//  Article.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

enum ArticlePeriod: Int {
    
    // MARK: - Cases
    
    case oneDay = 1, sevenDay = 7, thirtyDay = 30
}

struct Article: Decodable {
    
    // MARK: - Coding Keys
    
    enum ArticleCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case status, resultsCount = "num_results"
    }
    
    // MARK: - Properties
    
    var status: String
    var results: [ArticleData]
}

import RealmSwift

class ArticleData: Object, Decodable {
    
    // MARK: - Coding Keys
    
    enum ArticleDataCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case url, title, abstract, identifier = "id", byLine = "byline",
             publishedDate = "published_date", media = "media", period = "period"
    }
    
    // MARK: - Properties
    
    @objc dynamic var identifier: Int
    @objc dynamic var urlString: String?
    @objc dynamic var title: String?
    @objc dynamic var abstract: String?
    @objc dynamic var byLine: String?
    @objc dynamic var publishedDateString: String?
    @objc dynamic var media: ArticleDataMedia?
    @objc dynamic var periodRawValueString: String?

    // MARK: - Computed Properties
    
    var url: URL? {
        guard let string = urlString else { return nil }
        return URL(string: string)
    }
    
    var period: ArticlePeriod? {
        guard let rawValue = periodRawValueString, let rawValueInt = Int(rawValue) else { return nil }
        return ArticlePeriod(rawValue: rawValueInt)
    }
    
    override class func primaryKey() -> String? {
        return "identifier"
    }
    
    // MARK: - Decodable
    
    required init() {
        identifier = 0
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArticleDataCodingKeys.self)
        identifier = try container.decode(Int.self, forKey: .identifier)
        urlString = try container.decodeIfPresent(String.self, forKey: .url)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        byLine = try container.decode(String.self, forKey: .byLine)
        publishedDateString = try container.decodeIfPresent(String.self, forKey: .publishedDate)
        media = try container.decode([ArticleDataMedia].self, forKey: .media).first
        periodRawValueString = try container.decodeIfPresent(String.self, forKey: .period)
    }
}
