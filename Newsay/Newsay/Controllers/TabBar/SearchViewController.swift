import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate  {

    private var collectionView : UICollectionView?
    
    private var news : [Article] = []
    
    private var searchController : UISearchController!
    
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
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
        
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
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.news = []
        self.collectionView?.reloadData()
    }
    

}
