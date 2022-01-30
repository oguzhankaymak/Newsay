import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView?
    private var news: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 80
        layout.itemSize = CGSize(width: view.frame.size.width-50, height: 550)
        
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
    
    private func fetchData(){
        APICaller.shared.getNews { [weak self] result in
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

}
