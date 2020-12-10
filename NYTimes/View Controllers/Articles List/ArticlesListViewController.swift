//
//  ArticlesListViewController.swift
//  NYTimes
//
//  Created by Michael Grigoryan on 12/9/20.
//

class ArticlesListViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var offlineModeLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var articleViewModel: ArticleViewModel!
    
    var isTableViewAvailable: Bool = false {
        willSet {
            tableView.separatorStyle = newValue ? .singleLine : .none
            tableView.isScrollEnabled = newValue
        }
    }
    
    // MARK: - View Controller's Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.shared.delegate = self
        setupTitles()
        setupTableView()
        handleViewModel()
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        offlineModeLabel.isHidden = NetworkService.shared.isNetworkConnected
    }
    
    // MARK: - Methods
    
    private func setupTitles() {
        offlineModeLabel.text = "offline_mode".localized
    }
    
    private func setupTableView() {
        isTableViewAvailable = false
        tableView.register(ArticleListCell.nib,
                           forCellReuseIdentifier: ArticleListCell.identifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(refreshControlValueChanged), for: .valueChanged)
        tableView.refreshControl?.tintColor = .white
    }
    
    func handleViewModel() {
        tableView.refreshControl?.beginRefreshing()
        articleViewModel = ArticleViewModel(success: {
            DispatchQueue.main.async {
                self.isTableViewAvailable = true
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }, failure: { (error) in
            DispatchQueue.main.async {
                self.isTableViewAvailable = true
                self.showError(message: error.localizedDescription)
                self.tableView.refreshControl?.endRefreshing()
            }
        }, noData: {
            DispatchQueue.main.async {
                self.showError(message: "something_went_wrong".localized ?? "")
            }
        })
    }
    
    private func setupSegmentedControl() {
        segmentedControl.setTitle("1_day_period".localized, forSegmentAt: 0)
        segmentedControl.setTitle("7_day_period".localized, forSegmentAt: 1)
        segmentedControl.setTitle("30_day_period".localized, forSegmentAt: 2)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
    }
    
    // MARK: - Actions
    
    @objc private func refreshControlValueChanged() {
        guard NetworkService.shared.isNetworkConnected else {
            tableView.refreshControl?.endRefreshing(); return }
        articleViewModel.refreshMostPopularArticles()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: articleViewModel.articlePeriod = .oneDay
        case 1: articleViewModel.articlePeriod = .sevenDay
        case 2: articleViewModel.articlePeriod = .thirtyDay
        default: break }
        articleViewModel.refreshMostPopularArticles()
    }
}

extension ArticlesListViewController: UITableViewDataSource {
    
    // MARK: - Table View's Data Source
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.results.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
                                                    ArticleListCell.identifier) as? ArticleListCell
        let articleData = articleViewModel.results[indexPath.row]
        cell?.setData(from: articleData)
        return cell!
    }
}

extension ArticlesListViewController: UITableViewDelegate {
    
    // MARK: - Table View's Delegate
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let articleData = articleViewModel.results[indexPath.row]
        let articleDetails = ArticleDetailsViewController(with: articleData)
        navigationController?.pushViewController(articleDetails, animated: true)
    }
}

extension ArticlesListViewController: NetworkServiceDelegate {
    
    // MARK: - Network Service Delegate
    
    func networkBecomesReachable() {
        offlineModeLabel.isHidden = true
        if articleViewModel.results.isEmpty {
            handleViewModel()
        }
    }
    
    func networkBecomesUnreachable() {
        offlineModeLabel.isHidden = false
    }
}
