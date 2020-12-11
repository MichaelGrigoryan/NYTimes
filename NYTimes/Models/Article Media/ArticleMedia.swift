//
//  ArticleMedia.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

import RealmSwift

class ArticleDataMedia: Object, Decodable {
    
    // MARK: - Coding Keys
    
    enum ArticleDataMediaCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case caption, copyright, mediaMetadata = "media-metadata"
    }
    
    // MARK: - Properties
    
    @objc dynamic var caption: String
    @objc dynamic var copyright: String
    @objc dynamic var thumbnailMetadata: ArticleDataMediaMetadata?
    @objc dynamic var imageMetadata: ArticleDataMediaMetadata?

    // MARK: - Decodable
    
    required init() {
        caption = ""
        copyright = ""
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArticleDataMediaCodingKeys.self)
        caption = try container.decode(String.self, forKey: .caption)
        copyright = try container.decode(String.self, forKey: .copyright)
        if let metadataArray = try container.decodeIfPresent([ArticleDataMediaMetadata].self, forKey: .mediaMetadata) {
            thumbnailMetadata = metadataArray.first(where: {$0.format == .standartThumbnail})
            imageMetadata = metadataArray.first(where: {$0.format == .mediumThreeByTwo440})
        }
    }
}

class ArticleDataMediaMetadata: Object, Decodable {
    
    // MARK: - Enum
    
    enum MetadataFormat: String, Decodable {
        
        // MARK: - Cases
        
        case standartThumbnail = "Standard Thumbnail",
             mediumThreeByTwo440 = "mediumThreeByTwo440"
    }
    
    // MARK: - Coding Keys
    
    enum ArticleDataMediaMetadaCodingKeys: String, CodingKey {
        
        // MARK: - Cases
        
        case url, format, data
    }
    
    // MARK: - Properties
    
    @objc dynamic var urlString: String?
    @objc dynamic var formatRawValue: String?
    @objc dynamic var data: Data?

    // MARK: - Computed Properties
    
    var url: URL? {
        guard let string = urlString else { return nil }
        return URL(string: string)
    }
    
    var format: MetadataFormat? {
        guard let rawValue = formatRawValue else { return nil }
        return MetadataFormat(rawValue: rawValue)
    }
    
    // MARK: - Decodable
    
    required init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArticleDataMediaMetadaCodingKeys.self)
        urlString = try container.decodeIfPresent(String.self, forKey: .url)
        formatRawValue = try container.decodeIfPresent(String.self, forKey: .format)
        data = try container.decodeIfPresent(Data.self, forKey: .data)
    }
}
