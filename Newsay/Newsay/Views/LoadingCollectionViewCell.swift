import UIKit
import TinyConstraints

class LoadingCollectionViewCell: UICollectionViewCell {
    static let identifier = "LoadingViewCell"
    
    var activiyLoaderView : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = false
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews(){
        contentView.addSubview(activiyLoaderView)
        activiyLoaderView.centerXToSuperview()
        activiyLoaderView.centerYToSuperview()
        activiyLoaderView.startAnimating()
    }
    
    private func constraintViews(){
        activiyLoaderView.height(20)
    }
    
}
