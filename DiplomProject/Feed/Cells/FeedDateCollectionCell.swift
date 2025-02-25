import UIKit

final class FeedDateCollectionCell: UICollectionViewCell {
    // MARK: - Private properties
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let leftSeparatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let rightSeparatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        [
            leftSeparatorView,
            bubbleView,
            rightSeparatorView
        ].forEach(contentView.addSubview)
        
        bubbleView.addSubview(title)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(date: Date) {
        title.text = date.formatDateToDayMonth
    }
    
    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            leftSeparatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            leftSeparatorView.trailingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: -10),
            leftSeparatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            leftSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            rightSeparatorView.leadingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 10),
            rightSeparatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            rightSeparatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            rightSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            bubbleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -20),
            title.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
        ])
    }
}
