import UIKit

final class FeedStoriesCollectionCell: UICollectionViewCell {
    // MARK: - Private properties
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = bounds.height / 2
        backgroundColor = .systemGray3
        
        contentView.addSubview(title)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(story: FeedStoryModel) {
        title.text = story.title
    }
    
    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
