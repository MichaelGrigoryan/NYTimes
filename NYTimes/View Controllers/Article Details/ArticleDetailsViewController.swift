//
//  ArticleDetailsViewController.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

class ArticleDetailsViewController: BaseViewController {
    
    // MARK: - Initialization
    
    init(with articleData: ArticleData) {
        self.articleData = articleData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailCaptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

    // MARK: - Properties
    
    private var articleData: ArticleData!
    
    // MARK: - View Controller's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPageLayout()

        setData(from: articleData)
    }
    
    // MARK: - Methods
    
    private func setTitles() {
        moreButton.setTitle("want_to_read_more".localized, for: .normal)
    }
    
    private func setPageLayout() {
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setData(from articleData: ArticleData) {
        titleLabel.text = articleData.title
        if let abstract = articleData.abstract, !abstract.isEmpty {
            abstractLabel.text = abstract
        } else { abstractLabel.isHidden = true }
        if let imageData = articleData.media?.imageMetadata?.data {
            thumbnailImageView.image = UIImage(data: imageData)
        } else if let url = articleData.media?.imageMetadata?.url {
            thumbnailImageView.setImage(from: url)
        } else { thumbnailImageView.isHidden = true }
        let media = articleData.media
        if let caption = media?.caption {
            thumbnailCaptionLabel.text = caption
        } else { thumbnailCaptionLabel.isHidden = true }
        if let copyright = media?.copyright {
            copyrightLabel.text = copyright
        } else { copyrightLabel.isHidden = true }
        authorLabel.text = articleData.byLine
        dateLabel.text = articleData.publishedDateString
        if articleData.url == nil { moreButton.isHidden = true }
    }
    
    // MARK: - Actions
    
    @IBAction func moreAction(_ sender: UIButton) {
        guard let url = articleData.url, UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
