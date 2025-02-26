import UIKit

final class PathHeaderView: UICollectionReusableView {
    
    // MARK: - Private properties
    
    private let pathLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray2
        return view
    }()
  
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(pathLabel)
        addSubview(separatorView)
        setupConstraints()
        
        backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(path: [String]) {
        pathLabel.text = path.joined(separator: " / ")
    }
    
    // MARK: - Public methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pathLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            pathLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pathLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            pathLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
        ])
    }
}

