import UIKit

class HomeViewController: UIViewController {
    
    private var news: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()

    }
    
    private func fetchData(){
        APICaller.shared.getNews { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.news = news.articles
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
