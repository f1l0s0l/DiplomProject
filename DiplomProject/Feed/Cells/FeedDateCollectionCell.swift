import UIKit

final class FeedDateCollectionCell: UICollectionViewCell {
    // MARK: - Private properties
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(title)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(date: String) {
        title.text = date
    }
    
    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -5),
            title.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
        ])
    }
}
