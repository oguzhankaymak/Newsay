import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var news: [Article] = []
    
    private var collectionView : UICollectionView?
    
    let categories : [Category] = [
        Category(id:0, name: "Business", key: "business", imageKey: "person.2"),
        Category(id:1, name: "Entertainment", key: "entertainment", imageKey: "display"),
        Category(id:2, name: "General", key:"general" , imageKey: "globe.americas"),
        Category(id:3, name: "Health",key: "health", imageKey: "heart"),
        Category(id:4, name: "Science", key: "science", imageKey: "flame"),
        Category(id:5, name: "Sports", key: "sports", imageKey: "figure.walk"),
        Category(id:6, name: "Technology", key: "technology", imageKey: "4k.tv")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 20, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        guard let collectionView = collectionView else {
            return
        }

        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        let activeCategory = categories[indexPath.row]
        cell.configure(with: CategoryCellViewModel(id: activeCategory.id ,name: activeCategory.name, imageKey: activeCategory.imageKey))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let activeCategory = categories[indexPath.row]
        
        let vc = NewsViewController(category: activeCategory)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
