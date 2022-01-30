import UIKit
import SDWebImage
import TinyConstraints

class NewsCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewsCollectionViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.25
        view.backgroundColor = .white

        return view
    }()
    
    var newsImageHeight: CGFloat = 350
    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return imageView
    }()
    
    private let newsTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsContentView: UIView = {
        let view = UIView()
        return view
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
        contentView.addSubview(containerView)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsContentView)
        contentView.addSubview(newsTitle)
        contentView.addSubview(newsDescription)
    }
    
    private func constraintViews(){
        containerView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        newsContentView.height(550-newsImageHeight)
        containerView.stack([newsImage, newsContentView ,UIView()], axis: .vertical, spacing: 0)
        newsImage.height(newsImageHeight)
        
        newsTitle.top(to: newsContentView, offset: 10)
        newsTitle.left(to: newsContentView, offset: 20)
        newsTitle.right(to: newsContentView, offset: -20)
        
        newsDescription.topToBottom(of: newsTitle, offset: 10)
        newsDescription.left(to: newsContentView, offset: 20)
        newsDescription.right(to: newsContentView, offset: -20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitle.text = nil
        newsImage.image = UIImage(systemName: "newspaper", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    public func configure(with viewModel : NewsCellViewModel) {
        let prefixTitle = viewModel.title.count > 90 ? "\(viewModel.title.prefix(90))..." : viewModel.title
        newsTitle.text = prefixTitle
        newsImage.sd_setImage(with: viewModel.imageURL, completed: nil)
        
        let prefixDesription = viewModel.description.count > 120 ? "\(viewModel.description.prefix(120))..." : viewModel.description
        newsDescription.text = prefixDesription
    }
}
