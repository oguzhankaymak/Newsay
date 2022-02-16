import UIKit
import WebKit

class NewsDetailViewController: UIViewController, WKNavigationDelegate {
    
    private var news: Article

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    private var activiyLoader : UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.color = .systemGray
        return activityIndicatorView
    }()
    
    init(news: Article) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenTitle = news.title ?? "News"
        
        title = screenTitle.count > 25 ? "\(screenTitle.prefix(25))..." : screenTitle
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = URL(string: news.url) else {
            return
        }
        
        webView.load(URLRequest(url: url))
        webView.addSubview(activiyLoader)
        activiyLoader.center = view.center
        activiyLoader.startAnimating()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activiyLoader.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activiyLoader.stopAnimating()
    }

}
