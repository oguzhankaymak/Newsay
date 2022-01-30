import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    let backgroundColors: [UIColor] = [.systemGray, .systemBrown,.systemRed, .systemBlue, .systemPink, .systemPurple, .systemTeal ]
    
    private let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let cardView : UIView = {
        let view = UIView()
        return view
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
        
    }()
    
    private let categoryTitle: UILabel = {
        let label = UILabel()
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func constraintViews(){
        containerView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        containerView.height(120)
        cardView.height(120)
        
        containerView.stack([cardView ,UIView()], axis: .vertical, spacing: 0)
        cardView.stack([categoryTitle, imageView,UIView()], axis: .horizontal, spacing: 0)
        
        categoryTitle.left(to: containerView, offset: 10)
        imageView.right(to: cardView, offset: -10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryTitle.text = nil
        imageView.image = nil
    }
    
    private func setupViews(){
        contentView.addSubview(containerView)
        contentView.addSubview(cardView)
        contentView.addSubview(categoryTitle)
        contentView.addSubview(imageView)
    }
    
    public func configure(with viewModel : CategoryCellViewModel) {
        containerView.backgroundColor = backgroundColors[viewModel.id]
        categoryTitle.text = viewModel.name
        imageView.image = UIImage(
            systemName: viewModel.imageKey,
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 50,
                weight: .regular))
    }
}
