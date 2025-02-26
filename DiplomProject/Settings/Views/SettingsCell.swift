import UIKit

final class SettingsCell: UITableViewCell {
        
    let leftIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [
            leftIconImageView,
            titleLabel,
            rightIconImageView
        ].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            leftIconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            leftIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftIconImageView.heightAnchor.constraint(equalToConstant: 24),
            leftIconImageView.widthAnchor.constraint(equalToConstant: 24),
            
            rightIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            rightIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightIconImageView.heightAnchor.constraint(equalToConstant: 24),
            rightIconImageView.widthAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: leftIconImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: rightIconImageView.leadingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
