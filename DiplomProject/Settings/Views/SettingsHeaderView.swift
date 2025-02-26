import UIKit

final class SettingsHeaderView: UIView {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(emailLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func render(user: User, themeProvider: ThemeProvider) {
        avatarImageView.sd_setImage(with: user.avatarURL)
        avatarImageView.backgroundColor = themeProvider.commonTheme.icon.secondary
        
        nameLabel.text = user.name
        nameLabel.textColor = themeProvider.commonTheme.text.name
        
        emailLabel.text = "user1@gmail.com"
        emailLabel.textColor = themeProvider.commonTheme.text.action
        
        backgroundColor = themeProvider.commonTheme.background.grouped
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
