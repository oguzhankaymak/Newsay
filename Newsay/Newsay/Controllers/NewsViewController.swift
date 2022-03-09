import UIKit

class NewsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView?
    private var news: [Article] = []
    private var category: Category
    
    private var totalPage = 1
    private var currentPage = 1
    private var pageSize = 10
    
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
        fetchCategoryData(categoryKey: category.key, page: currentPage)
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 50
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        guard let collectionView = collectionView else {
            return
        }
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.identifier)
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
    
    private func fetchCategoryData(categoryKey: String, page: Int ){
        APICaller.shared.getNewsByCategory(categoryKey: categoryKey, page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.news += news.articles
                    self?.totalPage = Int((Float(news.totalResults) / Float(self!.pageSize)).rounded(.awayFromZero))
                   
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
        if currentPage < totalPage && indexPath.row == news.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:LoadingCollectionViewCell.identifier, for: indexPath) as! LoadingCollectionViewCell
            
            cell.activiyLoaderView.startAnimating()
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            
            let activeNews = news[indexPath.row]
            
            cell.configure(with: NewsCellViewModel(
                title: activeNews.title ?? "",
                imageURL: URL(string: activeNews.urlToImage ?? ""),
                description: activeNews.description ?? "")
            )
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = NewsDetailViewController(news: news[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == news.count - 1 {
            currentPage = currentPage + 1
            fetchCategoryData(categoryKey: category.key, page: currentPage)
        }
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(currentPage < totalPage && indexPath.row == news.count - 1){
            return CGSize(width: view.frame.size.width, height: 20)
        }
        return CGSize(width: view.frame.size.width-50, height: 550)
    }
    
}
