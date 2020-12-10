//
//  ArticleListCell.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

class ArticleListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ArticleListCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    // MARK: - Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Cell's Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor

        accessoryView = UIImageView(image: #imageLiteral(resourceName: "disclosure_icon"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        dateLabel.text = nil
    }
    
    // MARK: - Methods
    
    func setData(from articleData: ArticleData) {
        if let thumbnailData = articleData.media?.thumbnailMetadata?.data {
            thumbnailImageView.image = UIImage(data: thumbnailData)
        } else if let url = articleData.media?.thumbnailMetadata?.url {
            thumbnailImageView.setImage(from: url)
        }
        titleLabel.text = articleData.title
        authorLabel.text = articleData.byLine
        dateLabel.text = articleData.publishedDateString
        thumbnailImageView.isHidden =
            articleData.media?.thumbnailMetadata?.url == nil && articleData.media?.thumbnailMetadata?.data == nil
    }
}
