import UIKit
import SDWebImage

fileprivate let avatarSide: CGFloat = 60

final class FeedPostCollectionCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    private let authorView: FeedPostAuthorView = {
        let view = FeedPostAuthorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postBodyView: FeedPostBodyView = {
       let view = FeedPostBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let postInfoView: FeedPostInfoView = {
       let view = FeedPostInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(authorView)
        contentView.addSubview(postBodyView)
        contentView.addSubview(postInfoView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(post: Post, author: User, themeProvider: ThemeProvider) {
        authorView.render(user: author, themeProvider: themeProvider)
        postBodyView.render(post: post, themeProvider: themeProvider)
        postInfoView.render(themeProvider: themeProvider)
    }
    
    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            authorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postBodyView.topAnchor.constraint(equalTo: authorView.bottomAnchor),
            postBodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postBodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            postInfoView.topAnchor.constraint(equalTo: postBodyView.bottomAnchor),
            postInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
}

// MARK: - FeedPostAuthorView

final class FeedPostAuthorView: UIView {
    
    // MARK: - Private properties
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = avatarSide / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Дизайнер"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        [
            avatarImageView,
            nameLabel,
            tempLabel
        ].forEach(addSubview)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(user: User, themeProvider: ThemeProvider) {
        avatarImageView.sd_setImage(with: user.avatarURL, placeholderImage: UIImage(systemName: "person.circle"))
        nameLabel.text = user.name
        
        nameLabel.textColor = themeProvider.commonTheme.text.name
        tempLabel.textColor = themeProvider.commonTheme.text.secondary
        
        backgroundColor = themeProvider.commonTheme.background.surface
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSide),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 20),
            
            tempLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            tempLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
}

// MARK: - FeedPostBodyView

final class FeedPostBodyView: UIView {
    
    // MARK: - Private properties
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let attachImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        [
            bodyLabel,
            attachImageView,
            separatorView
        ].forEach(addSubview)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    func render(post: Post, themeProvider: ThemeProvider) {
        bodyLabel.text = post.text
//        bodyLabel.text = "akjsfbakjsdbakjsbdakjsdbakjsbdaksjdb ajsdnkj ajkhbdakjsdb aksjdh askjd ljashd aksd hasd kajshd \n jahgsdajsyd iaydsg asyaiysdg"/
        attachImageView.sd_setImage(with: URL(string: post.imageURL))
        
        bodyLabel.textColor = themeProvider.commonTheme.text.primary
        separatorView.backgroundColor = themeProvider.commonTheme.stroke.primary
        backgroundColor = themeProvider.commonTheme.background.themed
    }
    
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            separatorView.widthAnchor.constraint(equalToConstant: 1),

            bodyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            bodyLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 15),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            attachImageView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            attachImageView.leadingAnchor.constraint(equalTo: bodyLabel.leadingAnchor),
            attachImageView.trailingAnchor.constraint(equalTo: bodyLabel.trailingAnchor),
            attachImageView.heightAnchor.constraint(equalToConstant: 400),
            attachImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
}

// MARK: - FeedPostInfoView

final class FeedPostInfoView: UIView {
    private let buttonTitleIndent = "  "
    private let defaultLikeCount = 5
    
    private var likeIconSelectedColor = UIColor.clear
    private var likeIconColor = UIColor.clear

    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        
        addSubview(separatorView)
        addSubview(likeButton)
        
        setupConstraints()
        likeButton.setTitle("\(buttonTitleIndent)5", for: .normal)
        likeButton.setTitle("\(buttonTitleIndent)6", for: .selected)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func render(themeProvider: ThemeProvider) {
        backgroundColor = themeProvider.commonTheme.background.themed
        
        separatorView.backgroundColor = themeProvider.commonTheme.stroke.secondary
        
        likeIconSelectedColor = themeProvider.commonTheme.icon.negative
        likeIconColor = themeProvider.commonTheme.icon.contrast
        
        likeButton.setTitleColor(themeProvider.commonTheme.text.contrast, for: .normal)
        
        updateLikeButton()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            
            likeButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 20),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    @objc private func didTapLikeButton() {
        likeButton.isSelected.toggle()
        updateLikeButton()
    }
    
    private func updateLikeButton() {
        let likeIconTintColor = likeButton.isSelected ? likeIconSelectedColor : likeIconColor
        likeButton.imageView?.tintColor = likeIconTintColor
    }
}
