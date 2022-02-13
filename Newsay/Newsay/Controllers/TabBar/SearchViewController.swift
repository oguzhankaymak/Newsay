import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate  {

    private var collectionView : UICollectionView?
    
    private var news : [Article] = []
    
    private var searchController : UISearchController!
    
    private var isSearch = false
    
    private var activiyLoader : UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.color = .systemGray
        return activityIndicatorView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Please search"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        
        searchController =  UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search here"
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 100
        layout.itemSize = CGSize(width: view.frame.size.width-50, height: 500)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(activiyLoader)
        activiyLoader.center = view.center
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if (self.news.count == 0) {
            collectionView.showEmptyMessage(isSearch ? "News not found :(" : "Please search news...")
        } else {
            collectionView.restore()
        }

        return self.news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
        
        let activeNews = news[indexPath.row]
        
        cell.configure(with: NewsCellViewModel(
            title: activeNews.title ?? "",
            imageURL: URL(string: activeNews.urlToImage ?? ""),
            description: activeNews.description ?? "")
        )
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activiyLoader.startAnimating()
        isSearch = true
        guard let text = searchBar.text else {
            return
        }
        self.collectionView!.reloadData()
        
        APICaller.shared.getNewsBySearch(with: text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.news = news.articles
                    self?.collectionView?.reloadData()
                    self?.activiyLoader.stopAnimating()
                case.failure(let error):
                    self?.activiyLoader.stopAnimating()
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.news = []
        isSearch = false
        self.collectionView?.reloadData()
    }
    

}

extension UICollectionView {
    func showEmptyMessage(_ message: String) {
        let message: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .gray
            label.font = .systemFont(ofSize: 18, weight: .medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        
        self.backgroundView = message;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
