import UIKit

final class SimpeCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.contentView.backgroundColor = self.isHighlighted ? UIColor.lightGray.withAlphaComponent(0.5) : .systemGray6
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.contentView.backgroundColor = self.isSelected ? UIColor.lightGray.withAlphaComponent(0.5) : .systemGray6
            }
        }
    }
    
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor.systemGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(label)
        contentView.addSubview(imageView)
        
        contentView.backgroundColor = .systemGray6
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1 / UIScreen.main.scale
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.clipsToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        ])
    }
}
