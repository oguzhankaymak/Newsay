import UIKit

class NewsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView?
    private var news: [Article] = []
    private var category: Category
    
    private var activiyLoader : UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.color = .systemGray
        return activityIndicatorView
    }()
    
    init(category: Category) {
            self.category = category
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        activiyLoader.startAnimating()
        fetchCategoryData(categoryKey: category.key)
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 100
        layout.itemSize = CGSize(width: view.frame.size.width-50, height: 500)
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
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
    
    private func fetchCategoryData(categoryKey: String){
        APICaller.shared.getNewsByCategory(with: categoryKey) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.news = news.articles
                    self?.collectionView?.reloadData()
                    self?.activiyLoader.stopAnimating()
                    
                case.failure(let error):
                    print(error.localizedDescription)
                    self?.activiyLoader.stopAnimating()
                }
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = NewsDetailViewController(news: news[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
